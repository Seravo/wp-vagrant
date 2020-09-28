#!/bin/sh

# Run zerofree
echo "u" > /proc/sysrq-trigger
mount / -o remount,ro

# Some Vagrant boxes have sda1, others vda1
if [ -e /dev/sda1 ]
then
  zerofree -v /dev/sda1
elif [ -e /dev/vda1 ]
then
  zerofree -v /dev/vda1
else
  echo "ERROR: Root filesystem not found at any of the expected locations"
  exit 1
fi

# Mount writeable again, otherwise Ansible will error
mount / -o remount,rw
