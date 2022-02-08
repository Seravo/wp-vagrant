![Seravo.com](https://seravo.com/wp-content/themes/seravo/images/seravo-banner-808x300.png)

# Seravo Vagrant Box

Brought to you by [Seravo.com](https://seravo.com).

This project is used to build [our precompiled WordPress Vagrant Box](https://app.vagrantup.com/seravo/boxes/wordpress). See [github.com/Seravo/wordpress](https://github.com/Seravo/wordpress) to get started using this.

This box imitates the functionality of [seravo.com](https://seravo.com) WordPress instances. We aim to help our users develop WordPress locally with the best tools available.

## What's inside?

Quite recent Docker CE. It spins up `seravo/wordpress:development` Docker image, which in turn provides production-like environment for your development needs.

You could also run plain Docker, but with Vagrant you get all the workflow benefits, start/shutdown triggers, domain names working reliably etc.

## Installation

You just need to clone our project template & start vagrant.

    git clone https://github.com/seravo/wordpress myproject
    cd myproject
    vagrant up

Pre-requirement is of course that you have recent VirtualBox and Vagrant installed on your machine.

## Similar projects

See also:
 * [Varying Vagrant Vagrants](https://varyingvagrantvagrants.org/)
 * [Kalabox](http://www.kalabox.io/)
 * [Flywheel Local](https://local.getflywheel.com/)

Unlike some of the alternatives listed above, the Seravo WordPress Vagrant comes
with all batteries included and there is no separate paid version. Our Vagrant
box is also fully integrated into the workflow, so that users can effortlessly
import and export data from and to production.

## Packaging

### Create a Vagrant image on your machine

Seravo Vagrant box is built with Packer. Make sure you have a fairly
recent version of Packer installed before building the box with the following:
```
packer build -force virtualbox.pkr.hcl
```
You may also specify the version (default `0`) or show the VirtualBox GUI to see the build happen. Be sure to not touch any keys running with `headless=false`:
```
packer build -var "version=20220216.0.0" -var "headless=false" -force virtualbox.pkr.hcl
```

### Test the new box locally first

To make the box available for local testing, find the build files and import the box file:
```
cd build/virtualbox/
vagrant box add --name "seravo/wordpress-beta" seravo-wordpress_20220216.box
```

You should then be ready to fire up a WordPress project where the `Vagrantfile` has been modified to contain:

```
  config.vm.box_version = "= 0"
  config.vm.box = 'seravo/wordpress-beta'
```

### Publish on Vagrant Cloud

Make available for public testing by publishing first as [Seravo/WordPress-Beta](https://app.vagrantup.com/seravo/boxes/wordpress-beta) and only later as the official [Seravo/WordPress](https://app.vagrantup.com/seravo/boxes/wordpress) Vagrant box.

When publishing on Vagrant boxes, see previous releases on how to define the version number, release notes and checksums. When making new official releases (not beta), also remember to write release notes at https://seravo.com/docs/get-started/release-notes/.

### Alternative Vagrant box formats

Alternative Vagrant box formats may be published in the future.
