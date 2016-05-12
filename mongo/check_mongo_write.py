#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
reload(sys)
sys.setdefaultencoding('utf-8')
import datetime
from pymongo import Connection
import os
from optparse import OptionParser
import syslog
import subprocess
import pdb

email = "lupuxiao1@163.com"

mongo_partner=None
d = datetime.datetime.today()
hostname = os.popen("hostname").read().strip()
host = "127.0.0.1"
#初始化日志
syslog.openlog(os.path.basename(sys.path[0]))


def getports():
        '''获取本地正在运行的实例端口'''
        cmd = """ports=(`netstat -tnpl | gawk '$NF ~/\/mongod$/{gsub(/.+:/,"",$4);print $4}'|sort -n`)
                 end=`expr ${#ports[@]} / 2`
                 echo -n ${ports[@]::$end}"""
        query = subprocess.Popen(cmd,stdout=subprocess.PIPE,stderr=subprocess.PIPE,shell=True)
        stdout,stderr = query.communicate()
	if query.returncode != 0 or not stdout:
                message = '"fail","主机%s没有mongodb 运行实例"' % hostname
		print message
                syslog.syslog(syslog.LOG_ERR,message)
        ports = stdout.rstrip().split()
        ports = [int(port) for port in ports]
        return ports


def inotify(info,email):
		try:
			print info
			syslog.syslog(syslog.LOG_ERR,info)
			send_mail = 'echo "%s" |mail -S from="root@mail.ly.xunwan.com" -s "mongo_problem"  "%s"' % (info,email)
			send = subprocess.Popen(send_mail,stdout=subprocess.PIPE,stderr=subprocess.PIPE,shell=True)
			stdout,stderr = send.communicate()
			if send.returncode != 0:
				raise Exception(stderr)
		except Exception,err:
			message = '"fail","检查到mongo有问题，但发送邮件失败,邮件信息:%s,失败信息:%s"' % (info,err)
			print message
			syslog.syslog(syslog.LOG_ERR,message)

def check_data(host,port):
	status = "Normal"
	try:
		content = {"hostname":hostname,"stat":"unupdate","datetime":d}
		cnx = Connection(host=host,port=port)
		dbs = cnx.database_names()
		exclude = ["admin","local"]
		for e in exclude:
			if e in dbs:
				dbs.remove(e)
		for db in dbs:
			database = cnx[db]
			#进行删除测试
			database.yunwei_check.remove({"hostname":hostname})
			#检查删除测试
			result = database.yunwei_check.find_one({"hostname":hostname})
			if result:
				info = "host: %s,	port: %s,	database: %s delete operation failed" % (hostname,port,db)
				inotify(info,email)
			#进行插入测试
			database.yunwei_check.insert(content)
			#检查插入测试
			result = database.yunwei_check.find_one(content)
			if not result:
				info = "host: %s,	port: %s,	database: %s insert operation failed" % (hostname,port,db)
				inotify(info,email)
			#进行更改测试
			database.yunwei_check.update({"hostname":hostname},{"$set":{"stat":"update"}})
			#检查更改测试
			result = database.yunwei_check.find_one({"stat":"update"})
			if not result:
				info = "host: %s,	port: %s,	database: %s update operation failed" % (hostname,port,db)
				inotify(info,email)			
	except Exception,err:
		info = '"fail","host:	%s,port %s,mongodb check error,	error info:%s"' % (hostname,port,err)
		inotify(info,email)
	finally:
		cnx.close()


def main():
	mongo_ports = getports()
	if mongo_ports:
		for port in mongo_ports:
			check_data(host,port)

if __name__ == "__main__":
	main()
