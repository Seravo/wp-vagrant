# Seravo Wordpress as Vagrant
This project is used to create [our precompiled vagrant box](https://vagrantcloud.com/seravo/boxes/wordpress) for virtualbox.

This is used for cloning [wordpress-palvelu](http://wp-palvelu.fi) sites to local development

# How to add into atlas cloud

## Package the box into file
```
$ vagrant up --provision
$ vagrant -c 'sudo rm -r /data/log/*.log'
$ vagrant package
```
## Upload it into https://vagrantcloud.com/seravo/boxes/wordpress

#Todo

##Better box packaging
Vagrant docs say that it is possible to [include provisioning scripts in a box](https://docs.vagrantup.com/v2/cli/package.html)

It would be cool to include ansible scripts which would generate:
* .ssh/config (for easier logging into production)
* download production db with details from config.yml
* enable 
