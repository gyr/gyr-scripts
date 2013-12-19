###
# Turn interactive mode back on
echo "debconf	debconf/frontend	select	Dialog" | debconf-set-selections
echo "debconf	debconf/priority	select	high"   | debconf-set-selections

###
# Make PAM config interactive again
echo "libpam-runtime libpam-runtime/override boolean false" | debconf-set-selections
