#!/bin/bash

# detect services
unset SERVICES
if ps faux | grep -v grep | grep -q gogs
then
  export SERVICES="$SERVICES gogs"
fi

if ps faux | grep -v grep | grep -q nginx
then
  export SERVICES="$SERVICES nginx"
fi

if ps faux | grep -v grep | grep -q httpd
then
  export SERVICES="$SERVICES httpd"
fi

# stop services
for service in $SERVICES
do
  systemctl stop $service
done

# renew certificates
certbot renew

# start services
for service in $SERVICES
do
  systemctl start $service
done
