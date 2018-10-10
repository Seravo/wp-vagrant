![Seravo.com](https://seravo.com/wp-content/themes/seravo/images/seravo-banner-808x300.png)

# Seravo Vagrant Box

Brought to you by [Seravo.com](https://seravo.com).

This project is used to build [our precompiled WordPress Vagrant Box](https://vagrantcloud.com/seravo/boxes/wordpress)

See [github.com/Seravo/wordpress](https://github.com/Seravo/wordpress) to get started using this.

This box imitates the functionality of [seravo.com](https://seravo.com) WordPress instances. We aim to help our users develop WordPress locally with the best tools available.

## What's inside?

Quite recent Docker CE. It spins up `seravo/wordpress:development`  Docker image, which in turn provides production-like environment for your development needs.

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

First make sure you have the latest baseimages on your system by running `vagrant box update`.

```
make rebuild
make package.box
```

To publish the box on on Vagrant Cloud you can upload manually at https://app.vagrantup.com/seravo/boxes/wordpress.

