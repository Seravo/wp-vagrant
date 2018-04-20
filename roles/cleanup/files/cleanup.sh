#!/bin/sh

# Fill disk until it's full
dd if=/dev/zero of=/EMPTY
sync

# Remove contents
rm -f /EMPTY
sync

# remove myself
rm -f "$0"
sync