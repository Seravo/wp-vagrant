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
````

## Packaging

### Create a Vagrant image on your machine

```
vagrant up --provision
vagrant package
```

To publish the box on on Vagrant Cloud you can either use `packer` (requires Vagrant Enterprise subscription) or upload manually at https://atlas.hashicorp.com/. The packer.json file was removed from this repository in Jan 2017 as it had not been used for a while and it wasn't properly maintained.
