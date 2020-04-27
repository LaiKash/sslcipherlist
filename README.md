# Description

Very simple script to check the cihpersuit used by a server from the ones that a client supports, using s_client.

As a probe of concept, lets think that the host is in 128.10.10.10. Create a key and a certificate in the host as follows (port 4430):

~~~
openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout keyout.pem -out out.pem
~~~

Create a really simple HTTPS server in the host with s_server:

~~~
openssl s_server -key key.pem -cert cert.pem -accept 4430 -www 
~~~

Use sslcipherlist (in the client) and check what happens:

~~~
./sslcipherlist.sh 128.10.10.10:4430
~~~


Additionally, if you want only to list the ciphers valid for the client, execute (in the client) the script sslistclient.sh.
