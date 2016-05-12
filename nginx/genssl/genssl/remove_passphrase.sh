#!/bin/bash

#remove passphrase from crt
#wirte by yyr

if [ $# -lt 1 ];then
	printf "usage:$0 certfile\n"
	exit 1
fi

certfile=$1
basedir=`dirname $certfile`
basename=`basename $certfile`
if ! [[ "$basename" =~ ^.*\.key$ ]];then
	echo "$certfile isn't a key file"
	exit 1
fi
openssl rsa -in $certfile  -out ${basedir}/nophrase_${basename}
if [ "$?" = 0 ];then
	echo "success remove passphrase of $certfile and general to ${basedir}/nophrase_${basename}"
fi
