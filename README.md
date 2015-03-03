# Seravo Wordpress as Vagrant
This project is used to create [our precompiled vagrant box](https://vagrantcloud.com/seravo/boxes/wordpress) for virtualbox.

This is for cloning [wordpress-palvelu](http://wp-palvelu.fi) to local development

#Todo

##Better box packaging
Vagrant docs say that it is possible to [include provisioning scripts in a box](https://docs.vagrantup.com/v2/cli/package.html)

It would be cool to include ansible scripts which would generate:
* .ssh/config (for easier logging into production)
* download production db with details from config.yml
* enable 

It should ask if you want to enable git commit hooks on master

##Ruby gems installed only to root user
* Check ansible gem module to have them globally
* Even though rspec is installed there's no binary


