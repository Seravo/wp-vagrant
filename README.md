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

First make sure you have the latest Ubuntu base images on your system by running `vagrant box update`.

Then build the Seravo Vagrant box using with `make rebuild`.

### Test the new box locally first

Make Vagrant box available for local testing with `make import` and fire up a WordPress project where the `Vagrantfile` has been modified to contain:

```
  config.vm.box_version = "= 0"
  config.vm.box = 'seravo/wordpress-beta'
```

### Publish on Vagrant Cloud

Make available for public testing by publishing first as [Seravo/WordPress-Beta](https://app.vagrantup.com/seravo/boxes/wordpress-beta) and only later as the official [Seravo/WordPress](https://app.vagrantup.com/seravo/boxes/wordpress) Vagrant box.

When publishing on Vagrant boxes, see previous releases on how to define the version number, release notes and checksums. When making new official releases (not beta), also remember to write release notes at https://seravo.com/docs/get-started/release-notes/.

### Alternative Vagrant box formats

To create a libvirt box, make sure you have installed the same dependencies as listed in .travis.yml, and run the same commands as Travis-CI does to provision a libvirt image. The resulting image is 1.5x larger than the VirtualBox image and the audience of libvirt is rather limited, so for now we have not put much effort in publishing boxes in the libvirt format.

