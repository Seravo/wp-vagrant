#!/bin/bash

# The /etc/hosts modifications made by the vagrant-hosts plugin needs root
# permissions to test that sudo works
sudo true

if git clone https://github.com/Seravo/WordPress.git tmp
then
  echo "Using a fresh git clone of Seravo/WordPress"
  cd tmp
  vagrant destroy --force
else
  echo "Resetting existing git clone of Seravo/WordPress"
  cd tmp
  vagrant destroy --force
  git reset --hard && git clean -fdx
fi

sed "s|'seravo/wordpress'|'seravo/wordpress-beta'|" -i Vagrantfile
sed 's|config.vm.box_version = ">= .*"|config.vm.box_version = "= 0"|' -i Vagrantfile

vagrant up
vagrant ssh --command wp-test
vagrant ssh --command s-test-commands
sleep 5

vagrant halt
vagrant up
vagrant ssh --command wp-test
vagrant ssh --command s-test-commands
sleep 5

vagrant destroy --force
vagrant up
vagrant ssh --command wp-test
vagrant ssh --command s-test-commands

echo "Tests completed successfully!"
