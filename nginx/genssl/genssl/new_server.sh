#!/bin/bash
#get the real_dir
if [ $# -lt 1 ];then
	printf "usage:$0 servername\n"
	exit 1
fi
servername=$1
real_dir=$(dirname `/usr/sbin/lsof -p $$ | gawk '$4 =="255r"{print $NF}'`)
cd $real_dir
#create the dir
[ -d private ] && mkdir private
# Create us a key. Don't bother putting a password on it since you will need it to start apache. If you have a better work around I'd love to hear it.   
openssl genrsa -out private/${servername}.key   
# Take our key and create a Certificate Signing Request for it.   
openssl req -new -key private/${servername}.key -out private/${servername}.csr   
# Sign this bastard key with our bastard CA key.   
openssl ca -config ./openssl.cnf -in private/${servername}.csr -cert private/ca.crt -keyfile private/ca.key -out private/${servername}.crt  

