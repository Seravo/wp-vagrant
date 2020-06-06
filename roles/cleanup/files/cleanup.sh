#!/bin/sh

# Fill disk until it's full
dd if=/dev/zero of=/EMPTY
sync

# Remove contents
rm -f /EMPTY
sync

# Run zerofree as well
echo "u" > /proc/sysrq-trigger
mount /dev/mapper / -o remount,ro
zerofree -v /dev/sda1

# remove myself
rm -f "$0"
sync
