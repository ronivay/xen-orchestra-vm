#!/bin/bash

# clear possible dhcp leases
rm -f /var/lib/dhcp/*.leases /var/lib/dhclient/*.leases

# make sure no compressed logs exist and log files are cleared
rm -f $(find /var/log -type f -name "*.[1-9]" -o -name "*.[1-9].gz")
for i in $(find /var/log -type f); do cat /dev/null > $i; done

# Clear root and xo user home directories
find /home/xo -mindepth 1 ! -path "*/.bashrc" ! -path "*/.profile" ! -path "*/.bash_logout" -exec rm -rf {} \;
find /root -mindepth 1 ! -path "*/.bashrc" ! -path "*/.profile" ! -path "*/.bash_logout" ! -path "*/.config*" -exec rm -rf {} \;

# remove backups of shadow/passwd/group/gshadow/subgid/subuid files
rm -f /etc/shadow- /etc/passwd- /etc/group- /etc/gshadow- /etc/sub[ug]id-

# clear tmp directories
rm -rf /tmp/* /var/tmp/*

# clear any xo-server data generated during install
rm -rf /var/lib/xo-server/data
rm -rf /var/lib/redis/dump.rdb

# clear apt cache
apt-get clean

# make sure machine-id is regenerated on reboot
[ -f /etc/machine-id ] && : > /etc/machine-id
[ ! -L /var/lib/dbus/machine-id ] && ln -sf /etc/machine-id /var/lib/dbus/machine-id

# remove this script
rm "$0"
