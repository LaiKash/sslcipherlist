#!/usr/bin/env bash
if [ "$#" -ne 1 ]; then
    echo "Need host:port as the only argument. Usage: sslciphlist.sh host:port"
    exit 1
fi
if [ "$1" == "-h" ]; then
  echo "Usage: sslciphlist.sh host:port"
  exit 0
fi
# OpenSSL requires the port number=$SERVER=$1
HOST=$1
WAIT=1
#Use all ciphers, even the ones with no encryption.
ciphers=$(openssl ciphers 'ALL:eNULL' | sed -e 's/:/ /g')

echo Obtaining cipher list from $(openssl version).
for cipher in ${ciphers[@]}
do
echo -n Testing $cipher...

#Connecting to the server with s_client.
result=$(echo -n | openssl s_client -cipher "$cipher" -connect $HOST 2>&1)
#If there is an error in the response, print FALSE.
#Print the column 6. Colums are made separating the output by the ":" character. Eg: 140375896680080:error:14077410:SSL routines:SSL23_GET_SERVER_HELLO:sslv3 alert handshake failure:s23_clnt.c:802:
if [[ "$result" =~ ":error:" ]] ; then
  error=$(echo -n $result | cut -d':' -f6)
  echo -e "\e[31mFALSE\e[0m ($error)"
else
#If there is not error, print TRUE. Otherwise, print UNKNOWN RESPONSE.
  if [[ "$result" =~ "Cipher is ${cipher}" || "$result" =~ "Cipher    :" ]] ; then
    echo -e "\e[92mTRUE\e[0m"
  else
    echo UNKNOWN RESPONSE
    echo $result
  fi
fi
sleep $WAIT
done
