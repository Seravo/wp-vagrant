#!/bin/bash

# This script zeroes out any space not needed for packaging a new Ubuntu Vagrant base box.
# Run the following command in a root shell:
#
# bash <(curl -s https://gist.github.com/justindowning/5670884/raw/vagrant-clean.sh)
#
# Original file by Justin Downing <justin@downing.us>
# Seravo additions by Otto Kekäläinen <otto@seravo.fi>

function print_green {
  echo -e "\e[32m${1}\e[0m"
}

print_green 'Clean Apt'
apt-get -y autoremove
aptitude clean
aptitude autoclean

print_green 'Cleanup bash history'
unset HISTFILE
[ -f /root/.bash_history ] && rm /root/.bash_history
[ -f /home/vagrant/.bash_history ] && rm /home/vagrant/.bash_history

print_green 'Cleanup log files'
find /var/log -type f | while read f; do echo -ne '' > $f; done

print_green 'Removing logs from /data/logs/'
rm -f /data/logs/*

print_green 'Whiteout disk'
count=`df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}'`
let count--
dd if=/dev/zero of=/tmp/whitespace bs=1024 count=$count
sync
rm /tmp/whitespace

# Sync to ensure that the delete completes before this moves on
sync
sync
sync

print_green 'Vagrant cleanup complete!'
