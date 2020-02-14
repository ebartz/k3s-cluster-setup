#!/bin/bash

#Required
domain=$1
commonname=$domain

#Change to your company details
country=DE
state=Bremen
locality=Bremen
organization=OneDeskOffice
organizationalunit=AWESOME
email=bartz@mrel.de

#Optional
password=BxtVQKyJBXzJXsx6EvgArRhmMZoAVFACswYZMyEcDNdfttiFN

if [ -z "$domain" ]
then
    echo "Argument not present."
    echo "Useage $0 [common name]"

    exit 99
fi

echo "Generating key request for $domain"

#Generate a key
openssl genrsa -des3 -passout pass:$password -out $domain.key 4096 -noout

#Remove passphrase from the key. Comment the line out to keep the passphrase
echo "Removing passphrase from key"
openssl rsa -in $domain.key -passin pass:$password -out /etc/ssl/$domain.key

#Create the request
echo "Creating CSR"
openssl req -new -key $domain.key -out /etc/ssl/$domain.csr -passin pass:$password \
    -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"

openssl x509 -in /etc/ssl/$domain.csr -out /etc/ssl/$domain.pem -req -signkey /etc/ssl/$domain.key -days 3650
cat /etc/ssl/$domain.key>>/etc/ssl/$domain.pem
