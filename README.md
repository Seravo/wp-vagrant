![Seravo.com](https://seravo.com/wp-content/themes/seravo/images/seravo-banner-808x300.png)

# Seravo Vagrant Box

Brought to you by [Seravo.com](https://seravo.com).

This project is used to build [our precompiled WordPress Vagrant Box](https://vagrantcloud.com/seravo/boxes/wordpress)

See [github.com/Seravo/wordpress](https://github.com/Seravo/wordpress) to get started using this.

This box imitates the functionality of [seravo.com](https://seravo.com) WordPress instances. We aim to help our users develop WordPress locally with the best tools available.

## What's inside?

Quite recent Docker CE. It spins up `seravo/wordpress:vagrant`  docker image, which in turn provides production-like environment for your development needs.

## Installation

1. Clone [github.com/Seravo/wordpress](https://github.com/Seravo/wordpress).
2. Install.
```
composer update
vagrant up
```

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
vagrant up --provision
vagrant package
```

To publish the box on on Vagrant Cloud you can either use `packer` (requires Vagrant Enterprise subscription) or upload manually at https://app.vagrantup.com/seravo/boxes/wordpress. The packer.json file was removed from this repository in Jan 2017 as it had not been used for a while and it wasn't properly maintained.

