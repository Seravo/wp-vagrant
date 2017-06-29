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

print_green 'Remove unnecessary -dev and -doc packages'
dpkg --get-selections | grep -e "-dev" | cut -f 1 | xargs apt-get remove --yes

print_green '..but reinstall virtualbox-guest-dkms'
apt install ---yes virtualbox-guest-dkms

print_green 'Clean Apt'
apt-get -y autoremove
aptitude clean
aptitude autoclean

# Reset package listing. A simple apt update will re-create them if needed.
rm -rf /var/cache/apt/*.bin
rm -rf /var/cache/debconf/*-old
rm -rf /var/lib/apt/lists/*

print_green 'Clean Gem cache'
rm -rf /var/lib/gems/2.2.0/cache/*
rm -rf /root/.gem

print_green 'Clean NPM cache'
rm -rf /root/.npm

print_green 'Clean Composer cache'
rm -rf /root/.composer

# This step is disabled as subsequent Ansible runs will fail then the git repos
# it expected to exist have disappeared. This works well then Ansible runs
# in a single run.
#print_green 'Delete all git repositories (used during installation phase)'
#for repo in $(find / -xdev -type d -name .git)
#do
#  rm -rf $repo
#done

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
