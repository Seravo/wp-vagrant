#!/bin/bash

# Fail on errors
set -e

# The /etc/hosts modifications made by the vagrant-hosts plugin needs root
# permissions to test that sudo works
sudo true

if git clone https://github.com/Seravo/WordPress.git tmp
then
  echo "Using a fresh git clone of Seravo/WordPress"
else
  echo "Resetting existing git clone of Seravo/WordPress"
fi

cd tmp || exit

# Cleanup any cruft from previous run
git reset --hard && git clean -fdx
vagrant destroy --force

# Use the locally build beta box
sed "s|'seravo/wordpress'|'seravo/wordpress-beta'|" -i Vagrantfile
sed 's|config.vm.box_version = ">= .*"|config.vm.box_version = "= 0"|' -i Vagrantfile

# Pristine startup
vagrant up
vagrant ssh --command wp-test
vagrant ssh --command "s-test-commands --yes"
vagrant destroy --force

sleep 5

# Startup with pre-existing project files
# e.g. composer will run much faster
vagrant up
vagrant ssh --command wp-test
vagrant ssh --command "s-test-commands --yes"
vagrant halt

sleep 5

# Reboot same box and with existing project files
vagrant up
vagrant ssh --command wp-test
vagrant ssh --command "s-test-commands --yes"
vagrant destroy --force

echo "Tests completed successfully!"
