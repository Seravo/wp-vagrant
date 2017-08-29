![Seravo.com](https://seravo.com/wp-content/themes/seravo/images/seravo-banner-808x300.png)

# Seravo Vagrant Box

Brought to you by [Seravo.com](https://seravo.com).

This project is used to build [our precompiled WordPress Vagrant Box](https://vagrantcloud.com/seravo/boxes/wordpress)

See [github.com/Seravo/wordpress](https://github.com/Seravo/wordpress) to get started using this.

This box imitates the functionality of [seravo.com](https://seravo.com) WordPress instances. We aim to help our users develop WordPress locally with the best tools available.

## What's inside?

A LEMP stack with interchangeable PHP5 / PHP7 / PHP 7.1
- Nginx
- MariaDB 10.0
- PHP5.6
- PHP7.0 / 7.1

Tooling for PHP/WordPress development
- Composer
- WP-CLI
- Adminer
- XDebug
- Webgrind
- Node.js 4.x LTS

Testing suite
- Codesniffer
- RSpec
- Capybara
- Poltergeist
- PhantomJS
- Mailcatcher

Pre-configured for Seravo.com customers
- Nginx proxy_pass configuration for static assets from production (images)
- Scripts for syncing databases between production / staging / development

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

#### Known problems during provisioning

Problem:

```
TASK [libsass : Install sassc] *************************************************
fatal: [default]: FAILED! => {"changed": false, "cmd": "/usr/bin/git checkout --force 3.2.1", "failed": true, "msg": "Failed to checkout 3.2.1", "rc": 1, "stderr": "error: pathspec '3.2.1' did not match any file(s) known to git.\n", "stdout": "", "stdout_lines": []}
```

Workaround (inside Vagrant, enter with `vagrant ssh`):

```
cd /usr/local/lib/sassc
sudo git fetch --tags
sudo git checkout 3.2.1

/usr/local/lib/libsass
sudo git fetch --tags
sudo git checkout 3.2.3
```
