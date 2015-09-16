#!/bin/bash
#
# Setup the the box. This runs as root

apt-get install software-properties-common ca-certificates
# Don't use latest since it might have problems
# apt-add-repository ppa:ansible/ansible
apt-get -y update
apt-get -y install ansible curl

# You can install anything you need here.
