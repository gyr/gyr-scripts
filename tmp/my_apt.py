#!/usr/bin/env python
#coding: utf8

import os
try:
    import apt, apt_pkg, apt.debfile
except ImportError: # This is not Debian or Ubuntu
    pass
else:
    apt_pkg.init()

class MyApt:

    def __init__(self):
        self.apt_cache = None # an instance of apt.cache.Cache
        self.lock1_fd = -1 # a fd
        self.lock2_fd = -1 # a fd

    def destroy(self, widget, data=None):
        print "GRANDE SACADA!!!!!"

    def hello(self, widget, data=None):
        print "Hello World"

    def create_apt_window(self):
        import gtk
        import apt.progress.gtk2
        window = gtk.Window(gtk.WINDOW_TOPLEVEL)
        window.set_position(gtk.WIN_POS_CENTER)
        window.set_border_width(10)
        window.set_title("OCDC Installer")
        window.set_deletable(False)
        window.set_resizable(False)
        #window.connect("destroy", self.destroy)
        progress = apt.progress.gtk2.GtkAptProgress()
        progress.set_size_request(700, -1)
        progress.show_terminal(True)
        progress.connect("destroy", self.destroy)
        button = gtk.Button("First Button")
        button.connect("clicked", self.hello, None)
        vbox = gtk.VBox(False, 2)
        vbox.pack_start(progress, False, False, 5)
        vbox.pack_start(button, False, False, 5)
        #window.add(progress)
        window.add(vbox)
        #window.iconify()
        window.show_all()
        return window, progress

    def lock_apt(self, path):
        if not os.path.exists(path):
            os.mkdir(path)
        lockfile = path + 'lock'
        # This will create an empty file of the given name and lock it.
        # Once this is done all other calls to GetLock in any other process will fail with -1.
        # The return result is the fd of the file, the call should call close at some time
        lock = apt_pkg.GetLock(lockfile)
        if lock < 0:
            print "ERROR: Can NOT lock apt cache (%s)" % lockfile
            raise Exception
        return lock

    def apt_lock_cache(self):
        try:
            # /var/lib/apt/lists/lock,
            # locked by apt-get update
            self.lock1_fd = self.lock_apt(apt_pkg.Config.FindDir("Dir::State::Lists"))
            # /var/cache/apt/archives/lock,
            # try the lock in /var/cache/apt/archive/lock first
            # this is because apt-get install will hold it all the time
            # while the dpkg lock is briefly given up before dpkg is
            # forked off. this can cause a race (LP: #437709)
            self.lock2_fd = self.lock_apt(apt_pkg.Config.FindDir("Dir::Cache::Archives"))
            apt_pkg.PkgSystemLock()
        except SystemError, e:
            print "ERROR [SystemError]: Can NOT lock apt cache (apt_pkg.PkgSystemLock - %s)" % e
            return False
        except Exception, e:
            print "ERROR: Can NOT lock apt cache (%s)" % e
            return False
        return True

    def close_lock1(self):
        if self.lock1_fd > 0:
            os.close(self.lock1_fd)
            self.lock1_fd = -1

    def close_lock2(self):
        if self.lock2_fd > 0:
            os.close(self.lock2_fd)
            self.lock2_fd = -1

    def apt_unlock_cache(self):
        self.close_lock1()
        self.close_lock2()
        self.unlock_apt_pkg_global_lock()

    def apt_open_cache(self):
        if self.apt_cache:
            self.apt_cache.open()
        else:
            self.apt_cache = apt.cache.Cache()

    def apt_update(self):
        try:
            self.apt_cache.update(self.apt_progress.fetch)
        except SystemError, e:
            print "ERROR [SystemError]: Can NOT update apt database (%s)" % e #e.message
            return False
        except apt.cache.FetchFailedException, e:
            print "ERROR [apt.cache.FetchFailedException]: Can NOT update apt database (%s)" % e
            return False
        # FetchFailedException raised if some URL of ppa failed.
        # Sometimes it can be ignored. Sometimes it cannot be ignored.
        except Exception, e:
            print "ERROR: Can NOT update apt database (%s)" % e
            return False
        return True

    def unlock_apt_pkg_global_lock(self):
        try:
            apt_pkg.PkgSystemUnLock()
        except SystemError, e:
            print "WARNNING [SystemError]: Can NOT unlock apt (%s)" % e
            #raise Exception
            pass

    def apt_install(self, package_names):
        '''package_names -- package names concatenated by comma (,)
        may raise apt.cache.FetchFailedException, apt.cache.FetchCancelledException, SystemError'''
        for pkg_name in package_names.split(','):
            if self.apt_cache.has_key(pkg_name):
                pkg = self.apt_cache[pkg_name]
            else:
                print "ERROR: Package %s does NOT exist" % pkg_name
                return False
            pkg.mark_install()
        try:
            self.unlock_apt_pkg_global_lock()
            self.apt_cache.commit(self.apt_progress.fetch, self.apt_progress.install)
        #except apt.cache.FetchFailedException, e:
        #    print "ERROR [apt.cache.FetchFailedException]: Can NOT download package (%s)" % e
        #    return False
        except Exception, e:
            print "ERROR: Can NOT install package(s) %s (%s)" % (package_names, e)
            return False
        finally:
            apt_pkg.PkgSystemLock()
        return True

    def apt_install_local(self, package_path):
        try:
            deb = apt.debfile.DebPackage(package_path, self.apt_cache)
        except SystemError, e:
            print "ERROR [SystemError]: %s" % e
            return 1
        if not deb.check():
            print "ERROR: Local debian package resolution error"
            return False
        self.unlock_apt_pkg_global_lock()
        (install, remove, unauth) = deb.required_changes
        for name in install:
            self.apt_cache[name].mark_install()
        for name in remove:
            self.apt_cache[name].mark_delete()
        self.apt_cache.commit(self.apt_progress.fetch, self.apt_progress.install)
        deb.install(self.apt_progress.dpkg_install)
        apt_pkg.PkgSystemLock()

    def apt_remove(self, package_names):
        '''package_names -- package names concatenated by comma (,)'''
        for pkg_name in package_names.split(','):
            if self.apt_cache.has_key(pkg_name):
                pkg = self.apt_cache[pkg_name]
            else:
                print "ERROR: Package %s does NOT exist" % pkg_name
                return False
            pkg.mark_delete()
        try:
            self.unlock_apt_pkg_global_lock()
            self.apt_cache.commit(self.apt_progress.fetch, self.apt_progress.install)
        except Exception, e:
            print "ERROR: Can NOT remove package(s) %s (%s)" % (package_names, e)
            return False
        finally:
            apt_pkg.PkgSystemLock()
        return True

    def apt_command(self, command, argument):
        self.apt_window, self.apt_progress = self.create_apt_window()
        try:
            ret = self.apt_lock_cache()
            if not ret:
                return ret
            self.apt_open_cache()
            print ">>> %s %s" % (command, argument)
            if command == 'install':
                ret = self.apt_install(argument)
            elif command == 'install_local':
                ret = self.apt_install_local(argument)
            elif command == 'remove':
                ret = self.apt_remove(argument)
            elif command == 'update':
                ret = self.apt_update()
            else:
                print "ERROR: Unknow command %s" % command
        finally:
            try:
                self.apt_unlock_cache()
            except Exception, e:
                print "ERROR: Can NOT unlock apt (%s)" % e
            self.apt_window.destroy()
            self.apt_window = self.apt_progress = None
        return ret

def main():
    my_apt = MyApt()
    result = "FAILED"
    #if my_apt.apt_command("update", None):
        #if my_apt.apt_command("install_local", "/work/gyr/blabla_1.0_all.deb"):
        #    result = "SUCCESS"
    if my_apt.apt_command("install", "cw"):
        if my_apt.apt_command("remove", "cw"):
            result = "SUCCESS"
    print result

if __name__ == '__main__':
    main()
