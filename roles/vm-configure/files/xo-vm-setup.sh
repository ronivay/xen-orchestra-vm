#!/bin/bash

/usr/local/bin/common.sh
/usr/local/bin/ssh-setup.sh
/usr/local/bin/certificate-setup.sh
/usr/local/bin/network-setup.sh

systemctl enable xo-server
systemctl start xo-server

rm -f /usr/local/bin/common.sh
rm -f /usr/local/bin/network-setup.sh
rm -f /usr/local/bin/certificate-setup.sh
rm -f /usr/local/bin/ssh-setup.sh

resize2fs /dev/xvda1
