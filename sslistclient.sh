#!/usr/bin/env bash

ciphers=$(openssl ciphers 'ALL:eNULL' | sed -e 's/:/ /g')

echo Obtaining cipher list from $(openssl version).
for cipher in ${ciphers[@]}
do
echo $cipher
done
