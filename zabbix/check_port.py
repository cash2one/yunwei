#!/usr/bin/python
__author__ = 'Yan'
import os
import json

data = {}
tcp_list = []
port_list = []
command = 'netstat -anp |grep "\<LISTEN\>" |grep "mysql"'
lines = os.popen(command).readlines()
for line in lines:
    port= line.split()[3].split(":")[1]
#    port = line.split()[1].split(':')[1]
    port_list.append(port)

for port in list(set(port_list)):
    port_dict = {}
    port_dict['{#TCP_PORT}'] = port
    tcp_list.append(port_dict)

data['data'] = tcp_list
jsonStr = json.dumps(data, sort_keys=True, indent=4)
print jsonStr