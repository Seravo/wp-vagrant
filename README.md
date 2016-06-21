![WP-palvelu.fi](https://wp-palvelu.fi/wp-content/uploads/2015/01/wp-palvelu-header.jpg)

# WP-palvelu Vagrant Box

Brought to you by [wp-palvelu.fi](https://wp-palvelu.fi).

This project is used to build [our precompiled WordPress Vagrant Box](https://vagrantcloud.com/seravo/boxes/wordpress)

See [github.com/Seravo/wordpress](https://github.com/Seravo/wordpress) to get started using this.

This box imitates the functionality of [wp-palvelu.fi](http://wp-palvelu.fi) WordPress instances. We aim to help our users develop WordPress locally with the best tools available.

## What's inside?

A LEMP stack with interchangeable PHP5 / PHP7 / HHVM
- Nginx
- MariaDB 10.0
- PHP5.6
- PHP7
- HHVM LTS

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

Pre-configured for WP-palvelu.fi customers
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

### Create vagrant image on your machine

Create it using vagrant cli and then upload to atlas.hashicorp.com

```
vagrant up --provision
vagrant ssh -c 'sudo rm -r /data/log/*.log'
vagrant package
```

### Create vagrant image using packer

```
packer push packer.json
```

You may now upload your precompiled package to the Vagrant Cloud!

