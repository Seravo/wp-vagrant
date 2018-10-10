# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

ANSIBLE_PATH = '.' # path targeting Ansible directory (relative to Vagrantfile)

Vagrant.require_version '>= 1.5.1'

Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/bionic64'
  config.vm.hostname = 'seravo-wordpress'

  config.ssh.insert_key = true

  config.vm.provision :ansible do |ansible|
    ansible.playbook = File.join(ANSIBLE_PATH, 'site.yml')
    ansible.groups = {
      'web' => ['default'],
      'development' => ['default']
    }
    ansible.extra_vars = {
      ansible_ssh_user: 'vagrant',
      user: 'vagrant',
      ansible_python_interpreter: '/usr/bin/python3'
    }
  end

  config.vm.provider 'virtualbox' do |vb|
    # Disable UART (prevents creating UART config with hard-coded path
    vb.customize ['modifyvm', :id, '--uartmode1', 'disconnected']
  end
end
