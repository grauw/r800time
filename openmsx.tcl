diskmanipulator create /tmp/r800time.dsk 32M
virtual_drive /tmp/r800time.dsk
diskmanipulator format virtual_drive
diskmanipulator import virtual_drive bin/
virtual_drive eject
hda /tmp/r800time.dsk

set maxframeskip 100
set throttle off
after time 12 "set throttle on"
