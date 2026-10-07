#!/bin/bash

# clear existing SSH-keys..
rm -f /etc/ssh/ssh_host_*_key /etc/ssh/ssh_host_*key.pub

# .. and recreate them
dpkg-reconfigure openssh-server

# disable rootlogin through SSH
sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

systemctl enable --now ssh
