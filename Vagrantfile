# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

ANSIBLE_PATH = '.' # path targeting Ansible directory (relative to Vagrantfile)

Vagrant.require_version '>= 2.0.0'

Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/bionic64'
  config.vm.hostname = 'seravo-wordpress'

  config.ssh.insert_key = true

  config.vm.provision :ansible do |ansible|
    ansible.compatibility_mode = '2.0'
    ansible.playbook = File.join(ANSIBLE_PATH, 'site.yml')
    ansible.extra_vars = {
      ansible_ssh_user: 'vagrant',
      user: 'vagrant',
      ansible_python_interpreter: '/usr/bin/python3'
    }
    ansible.raw_arguments = ['--diff']
  end
  config.vm.provider 'virtualbox' do |vb|
    vb.customize ['modifyvm', :id, '--uartmode1', 'file', File::NULL]
  end
end
