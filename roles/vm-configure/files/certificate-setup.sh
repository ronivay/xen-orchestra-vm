#!/bin/bash

# create SSL-certificate and key on first start so it's unique

mkdir /opt/ssl

openssl req -nodes -x509 -newkey rsa:4096 -keyout /opt/ssl/key.pem -out /opt/ssl/cert.pem -days 1095 -subj "/CN=xo-ce"

chmod 600 /opt/ssl
