![WP-palvelu.fi](https://wp-palvelu.fi/wp-content/uploads/2015/01/wp-palvelu-header.jpg)

# Seravo WordPress Vagrant Box

Brought to you by [wp-palvelu.fi](http://wp-palvelu.fi).

This project is used to build [our precompiled WordPress Vagrant Box](https://vagrantcloud.com/seravo/boxes/wordpress) for Virtualbox.

See [github.com/Seravo/wordpress](https://github.com/Seravo/wordpress) to get started using this.

This box imitates the functionality of [wp-palvelu.fi](http://wp-palvelu.fi) WordPress instances. We aim to help our users develop WordPress locally with the best tools available.

## Installation

1. Clone [github.com/Seravo/wordpress](https://github.com/Seravo/wordpress).
2. Install.
```
composer update
vagrant up
````

## Packaging

# Create vagrant image on your machine

Create it using vagrant cli and then upload to atlas.hashicorp.com

```
vagrant up --provision
vagrant ssh -c 'sudo rm -r /data/log/*.log'
vagrant package
```

# Create vagrant image using packer

```
packer push packer.json
```

You may now upload your precompiled package to the Vagrant Cloud!


## Todo

It would be cool to include ansible scripts which would generate:
* .ssh/config (for easier logging into production)
* download production db with details from config.yml
