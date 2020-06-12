#!/bin/sh

## @TODO: Disable this as if makes Trqvis-CI fail on timout after there was
## no output in 10 minutes
# Fill disk until it's full
#dd if=/dev/zero of=/EMPTY
#sync

# Remove contents
rm -f /EMPTY
sync

# remove myself
rm -f "$0"
sync

# Run zerofree as well
echo "u" > /proc/sysrq-trigger
mount /dev/mapper / -o remount,ro
zerofree -v /dev/sda1
