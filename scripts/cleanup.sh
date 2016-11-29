#!/bin/bash

# Removing leftover leases and persistent rules
echo "cleaning up dhcp leases"
rm /var/lib/dhcp/*

echo "Removing logs from /data/logs/"
rm -f /data/logs/*
