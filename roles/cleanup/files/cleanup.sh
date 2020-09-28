#!/bin/sh

# Some Vagrant boxes have sda1, others vda1
ROOT_FS_DEVICE=$(mount / 2>&1 | grep -o -e '/dev/[a-z0-9]*')

# Run zerofree
echo "u" > /proc/sysrq-trigger
mount -o remount,ro /

zerofree -v "$ROOT_FS_DEVICE"

# Try to mount writeable again, otherwise Ansible will error. This does however
# not work on libvirt where it seems only a reboot makes / writeable again
mount -o remount,rw / || true
