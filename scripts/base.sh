#!/bin/bash

perl -p -i -e 's#http://us.archive.ubuntu.com/ubuntu#http://mirror.rackspace.com/ubuntu#gi' /etc/apt/sources.list

# Update the box
apt-get -y update >/dev/null
apt-get -y install facter linux-headers-$(uname -r) build-essential zlib1g-dev libssl-dev libreadline-gplv2-dev curl unzip >/dev/null

# Tweak sshd to prevent DNS resolution (speed up logins)
echo 'UseDNS no' >> /etc/ssh/sshd_config

# Remove 5s grub timeout to speed up booting
cat <<EOF > /etc/default/grub
# If you change this file, run 'update-grub' afterwards to update
# /boot/grub/grub.cfg.

GRUB_DEFAULT=0
GRUB_TIMEOUT=0
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT="quiet"
GRUB_CMDLINE_LINUX="debian-installer=en_US"
EOF

update-grub

  # Install the same locales as in production
# Enable multiple North-European locales but keep C as default locale
DEBIAN_FRONTEND=noninteractive locale-gen --purge \
  en_US en_US.utf8 \
  fi_FI fi_FI.utf8 \
  sv_SE sv_SE.UTF-8 \
  fr_FR fr_FR.UTF-8 \
  de_DE de_DE.UTF-8 \
  ru_RU ru_RU.UTF-8 \
  et_EE et_EE.UTF-8 \
  nn_NO nn_NO.UTF-8 && \
  dpkg-reconfigure locales
