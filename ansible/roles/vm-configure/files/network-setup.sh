#!/bin/bash

# if vm-data/ip in xenstore is empty, it means we want to use DHCP. otherwise set static IP-address

if ! xenstore-read vm-data/ip >/dev/null 2>&1; then
	cat << EOF > /etc/network/interfaces
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
allow-hotplug eth0
iface eth0 inet dhcp
EOF

else

	IPADDRESS=$(xenstore-read vm-data/ip)
	NETMASK=$(xenstore-read vm-data/netmask)
	GATEWAY=$(xenstore-read vm-data/gateway)
	DNS=$(xenstore-read vm-data/dns)

	cat << EOF > /etc/network/interfaces
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
allow-hotplug eth0
iface eth0 inet static
	address $IPADDRESS
	netmask $NETMASK
	gateway $GATEWAY
	dns-nameserver $DNS
EOF

fi

ifup eth0
