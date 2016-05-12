#!/bin/sh
#if not input certify_username,print usage
[ -z "$1" ] && { echo usage:$0 certify_username;exit 1; }
#get the real_dir
real_dir=$(dirname `/usr/sbin/lsof -p $$ | gawk '$4 =="255r"{print $NF}'`)
cd $real_dir
#create the dir
[ -d private ] && mkdir private   
# The base of where our SSL stuff lives.   
base="$real_dir/private"  
# Were we would like to store keys... in this case we take the username given to us and store everything there.   
[ ! -d $base/users ] && mkdir -p $base/users  
  
# Let's create us a key for this user... yeah not sure why people want to use DES3 but at least let's make us a nice big key.   
openssl genrsa -des3 -out $base/users/$1.key 1024  
# Create a Certificate Signing Request for said key.   
openssl req -new -key $base/users/$1.key -out $base/users/$1.csr   
# Sign the key with our CA's key and cert and create the user's certificate out of it.   
openssl ca -config ./openssl.cnf -in $base/users/$1.csr -cert $base/ca.crt -keyfile $base/ca.key -out $base/users/$1.crt   
  
# This is the tricky bit... convert the certificate into a form that most browsers will understand PKCS12 to be specific.   
# The export password is the password used for the browser to extract the bits it needs and insert the key into the user's keychain.   
# Take the same precaution with the export password that would take with any other password based authentication scheme.   
openssl pkcs12 -export -clcerts -in $base/users/$1.crt -inkey $base/users/$1.key -out $base/users/$1.p12  

