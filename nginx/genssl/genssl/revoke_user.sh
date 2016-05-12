#!/bin/bash

#get the real_dir
real_dir=$(dirname `/usr/sbin/lsof -p $$ | gawk '$4 =="255r"{print $NF}'`)
cd $real_dir

[ ! -f private/users/$1.crt ] && { echo there no client $1 file;exit 1; }

openssl ca -config ./openssl.cnf -revoke  private/user/$1.crt

openssl ca -gencrl -config ./openssl.cnf -crldays 30 -crlhours 1 -out private/ca.crl
