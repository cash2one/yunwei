#!/usr/bin/python
# -*- coding: utf-8 -*-
import subprocess
import syslog
import time
import os
import sys
import pdb
from leyou.php import phplog
from leyou.fileoperate import chown,chmod,mkdir,rm
import mysql.connector

'''数据库备份和还原模块

由yyr编写'''

class mongodb():
	'''mongodb备份和还原类

	主要用于备份和还原mongodb数据库'''
	def __init__(self,host="127.0.0.1",port=27017,username=None,password=None,logfile=None,errlog=None):
		self.host = host
		self.port = port
		self.username = ""
		self.password = ""
		if username:self.username = "--username "+username
		if password:self.password = "--password "+password
		self.log = phplog(logfile)
		self.errlog = phplog(errlog,verbose=False)
		syslog.openlog(os.path.basename(sys.argv[0]))

		

	def backup(self,database,outdir):
		'''备份mongodb函数，

		当参数database为数据库名时就单独备份一个数据库，当为full时就对整个实例的所有数据库备份'''
		if database == "full":
			cmd = "mongodump --journal --host %s --port %d %s %s -o %s" % (self.host,self.port,self.username,self.password,outdir)
			sizedir = outdir
			#清空目录下的文件，保证备份干净
			rm(outdir+"/*",rf=True)
		else:
			cmd = "mongodump --journal --host %s --port %d %s %s -d %s -o %s" % (self.host,self.port,self.username,self.password,database,outdir)
			sizedir = outdir+"/"+database
			#清空目录下的文件，保证备份干净
			rm(sizedir,rf=True)
		starttime=time.time()
		result = subprocess.Popen(cmd,stdout=subprocess.PIPE,stderr=subprocess.PIPE,shell=True)
		stdout,stderr = result.communicate()
		processTime = time.time() - starttime
		if result.returncode != 0:	
			message = '"fail","%s: 备份mongodb实例%s 数据库%s 失败,失败信息：%s"' % (self.host,self.port,database,stderr.rstrip())
			self.log.savelog(message)
			self.errlog.savelog(message)
			syslog.syslog(syslog.LOG_ERR,message)
			raise IOError(message)
		else:
			sizecmd = subprocess.Popen("du -sh %s |cut -f 1" % sizedir,stdout=subprocess.PIPE,shell=True)
			size = sizecmd.communicate()[0].rstrip()
			message = '"success","%s: 备份mongodb实例%s 数据库%s 完成,路径 %s ,备份大小为%s,历时%.7f s"' % \
			(self.host,self.port,database,outdir,size,processTime)
			self.log.savelog(message)
                        syslog.syslog(message)

	def restore(self,database,indir):
		'''还原mongodb函数，

		当参数database为数据库名时就单独还原一个数据库当中，当为full时就对indir目录下的所有目录还原到实例当中'''
		if database == "full":
			cmd = "mongorestore --host %s --port %d --drop %s %s %s" % (self.host,self.port,self.username,self.password,indir)
		else:
			cmd = "mongorestore --host %s --port %d --drop %s %s -d %s %s" % (self.host,self.port,self.username,self.password,database,indir)
		starttime=time.time()
		result = subprocess.Popen(cmd,stdout=subprocess.PIPE,stderr=subprocess.PIPE,shell=True)
                stdout,stderr = result.communicate()
		processTime = time.time() - starttime
		if result.returncode != 0:
                        message = '"fail","%s: 还原mongodb实例%s 数据库%s 失败，失败信息：%s"' % (self.host,self.port,database,stderr.rstrip())
                        self.log.savelog(message)
                        self.errlog.savelog(message)
                        syslog.syslog(syslog.LOG_ERR,message)
			raise IOError(message)
                else:
                        message = '"success","%s: 还原mongodb实例%s 数据库%s 完成,历时%.7f s"' % (self.host,self.port,database,processTime)
                        self.log.savelog(message)
                        syslog.syslog(message)

class mysql ():
	'''mysql 备份和还原类

	用于进行mysql的备份和还原'''
	def __init__ (self,host,port,username,password,logfile=None,errlog=None):
		self.host = host
		self.port = port
		self.username = ""
		self.password = ""
		if username:self.username = "-u"+username
		if password:self.password = "-p"+password
		self.log = phplog(logfile)
		self.errlog = phplog(errlog,verbose=False)
		syslog.openlog(os.path.basename(sys.argv[0]))

	def backup(self,database,outdir,exclude=None):
		mkdir(outdir)
		chown(outdir,"mysql","mysql",R=True)
		parameter = {"host":self.host,"port":self.port,"username":self.username,"password":self.password,"database":database,"outdir":outdir,"exclude":exclude}
                cmd = "/usr/local/mysql/bin/mysqldump -h %(host)s -P %(port)d %(username)s %(password)s %(database)s -T %(outdir)s &&\
		/usr/local/mysql/bin/mysqldump -h %(host)s -P %(port)d %(username)s %(password)s -B %(database)s -d > \
		%(outdir)s/structure.sql &&\
		/usr/local/mysql/bin/mysqldump -h %(host)s -P %(port)d %(username)s %(password)s -R -t -n -d %(database)s > \
		%(outdir)s/routine.sql" % parameter
		if exclude:
			cmd = """
			tbs=`/usr/local/mysql/bin/mysql -h %(host)s -P %(port)d %(username)s %(password)s -s -D %(database)s -e \
			'show tables where Tables_in_%(database)s not REGEXP "%(exclude)s"'` && \
			/usr/local/mysql/bin/mysqldump -h %(host)s -P %(port)d %(username)s %(password)s -B %(database)s --tables $tbs -T %(outdir)s && \
			/usr/local/mysql/bin/mysqldump -h %(host)s -P %(port)d %(username)s %(password)s -B %(database)s -t -d > %(outdir)s/structure.sql && \
			/usr/local/mysql/bin/mysqldump -h %(host)s -P %(port)d %(username)s %(password)s -B %(database)s -d --tables $tbs >> %(outdir)s/structure.sql &&\
			/usr/local/mysql/bin/mysqldump -h %(host)s -P %(port)d %(username)s %(password)s -R -t -n -d -B %(database)s >%(outdir)s/routine.sql""" % parameter
                #清空目录下的文件，保证备份干净
		rm(outdir+"/*",rf=True)
		starttime=time.time()
		result = subprocess.Popen(cmd,stdout=subprocess.PIPE,stderr=subprocess.PIPE,shell=True)
		stdout,stderr = result.communicate()
		processTime = time.time() - starttime
		if result.returncode != 0:	
			message = '"fail","%s: 备份mysql实例%s 数据库%s 失败,失败信息：%s"' % (self.host,self.port,database,stderr.rstrip())
			self.log.savelog(message)
			self.errlog.savelog(message)
			syslog.syslog(syslog.LOG_ERR,message)
			raise IOError(message)
		else:
			sizecmd = subprocess.Popen("du -sh %s |cut -f 1" % outdir,stdout=subprocess.PIPE,shell=True)
			size = sizecmd.communicate()[0].rstrip()
			message = '"success","%s: 备份mysql实例%s 数据库%s 完成,路径 %s ,备份大小为%s,历时%.7f s"' % \
			(self.host,self.port,database,outdir,size,processTime)
			self.log.savelog(message)
                        syslog.syslog(message)

	def restore(self,indir,database=None):
			
		parameter = {"host":self.host,"port":self.port,"username":self.username,"password":self.password,"database":database,"indir":indir}
		if not database:
			cmd = """gawk -F':' 'NR == 3 && /Database:/{gsub(/ /,"",$NF);print $NF}' %(indir)s/*structure.sql""" % parameter
			old_database = os.popen(cmd).read().strip()
			if not old_database:
				message = '"fail","不能获取要还原的数据库名"'
				self.log.savelog(message)
                        	self.errlog.savelog(message)
                        	syslog.syslog(syslog.LOG_ERR,message)
				raise IOError(message)
			parameter["database"] = old_database
		
		cmd = """structure=`find %(indir)s -name "*structure.sql"`;routine=`find %(indir)s -name "*routine.sql"`;
			 [ -z "$structure" ] && { echo "there no structure file";exit 1; }
			 [ -z "$routine" ] && { echo "there no routine file";exit 1; }
			 old_database=`gawk -F':' 'NR == 3 && /Database:/{gsub(/ /,"",$NF);print $NF}' $structure`
		         [ -z "$old_database" ] && { echo make be no structure file;exit 1; }
		         [ "$old_database" != %(database)s ] &&  sed -i 's/'$old_database'/%(database)s/g' $structure $routine
		         /usr/local/mysql/bin/mysql -h %(host)s -P %(port)d %(username)s %(password)s <`find %(indir)s -name "*structure.sql"` &&\
		         /usr/local/mysql/bin/mysqlimport -L -h %(host)s -P %(port)d %(username)s %(password)s %(database)s %(indir)s/*.txt &&\
		         /usr/local/mysql/bin/mysql -h %(host)s -P %(port)d %(username)s %(password)s <$routine""" % parameter
		starttime=time.time()
		result = subprocess.Popen(cmd,stdout=subprocess.PIPE,stderr=subprocess.PIPE,shell=True)
                stdout,stderr = result.communicate()
		processTime = time.time() - starttime
		if result.returncode != 0:
                        message = '"fail","%s: 还原mysql实例%s 数据库%s失败，失败信息：%s"' % (self.host,self.port,parameter["database"],stderr.rstrip())
                        self.log.savelog(message)
                        self.errlog.savelog(message)
                        syslog.syslog(syslog.LOG_ERR,message)
			raise IOError(message)
                else:
                        message = '"success","%s: 还原mysql实例%s 数据库%s完成,历时%.7f s"' % (self.host,self.port,parameter["database"],processTime)
                        self.log.savelog(message)
                        syslog.syslog(message)

	def update(self,database,sql):
		cnx = mysql.connector.connect(host=self.host,port=self.port,user=self.username,password=self.password,connection_timeout=10,autocommit=True)
		#cnx.cmd_query('set max_allowed_packet=67108864')
		cursor = cnx.cursor()
		result = cursor.execute(sql,multi=True)
		for r in result:
			if r.with_rows:print r.fetchall()
		cnx.close()
	#def update (self.database,sql):
	#	cmd = """mysql -h %s -P %d -u%s -p%s -B %s -e '%s' """ % (self.host,self.port,self.username,self.password,sql)
	#	query = subprocess.Popen(cmd,stdout=subprocess.PIPE,stderr=subprocess.PIPE,shell=True)
	#	stdout,stderr = query.comunicate()
	#	if query.returncode != 0:
	#		raise Exception(stderr)
			

if __name__ == "__main__":
	db = mysql("127.0.0.1",3306,"root",None)
	db.backup("zerodb","/data/database/zerodb_2")
