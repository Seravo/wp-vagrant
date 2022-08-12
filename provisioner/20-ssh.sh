#!/bin/bash

VAGRANT_KEY_URL="https://raw.githubusercontent.com/hashicorp/vagrant/master/keys"

mkdir -p /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh

# Authorize Vagrant public key
curl "$VAGRANT_KEY_URL/vagrant.pub" > /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys

# Download Vagrant private key for connecting to container
curl "$VAGRANT_KEY_URL/vagrant" > /home/vagrant/.ssh/id_rsa_vagrant
chmod 0600 /home/vagrant/.ssh/id_rsa_vagrant

chown -R vagrant:vagrant /home/vagrant/.ssh

# Silence last login message
sed -i "s/#PrintLastLog.*/PrintLastLog no/1" /etc/ssh/sshd_config
