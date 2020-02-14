#!/bin/bash

if netstat -lantp | grep LISTEN | grep ':80 ' | grep httpd
then
  export WEB_SERVER=httpd
elif netstat -lantp | grep LISTEN | grep ':80 ' | grep nginx
then
  export WEB_SERVER=nginx
fi

systemctl stop $WEB_SERVER

certbot certonly -n --agree-tos --email odo@mrel.de -d $(hostname -f) --standalone

systemctl start $WEB_SERVER

ln -s /etc/letsencrypt/live/$(hostname -f)/fullchain.pem /etc/ssl/$(hostname -f)-le.pem 
ln -s /etc/letsencrypt/live/$(hostname -f)/privkey.pem /etc/ssl/$(hostname -f)-le.key
