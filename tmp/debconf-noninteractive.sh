###
# Turn interactive mode back on
echo "debconf	debconf/frontend	select	Noninteractive" | debconf-set-selections
echo "debconf	debconf/priority	select	critical"   | debconf-set-selections

###
# Turn pam configs not interactive
echo "libpam-runtime libpam-runtime/override boolean true" | debconf-set-selections
