#!/usr/bin/python

#nagios plugin for check mysql slave status
#write by yyr

import _mysql
import optparse
import sys
import re
import pdb
def main(argv):
	usage = "usage: %prog -H host -P port -u username -p password -q query"
	parser = optparse.OptionParser(usage)
	parser.add_option("-H",action="store",dest="host",help="mysql host name or ip,default localhost",metavar="host")
	parser.add_option("-P",action="store",dest="port",type="int",help="mysql port,default 3306",metavar="port")
	parser.add_option("-u",action="store",dest="username",help="mysql username,default root",metavar="username")
	parser.add_option("-p",action="store",dest="password",help="mysql password,default None",metavar="password")
	parser.add_option("-q",action="store",dest="query",help="query specify slave status",metavar="query")
	parser.add_option("-w",action="store",dest="warning",help="the threshold of warning",metavar="warning")
	parser.add_option("-c",action="store",dest="critical",help="the threshold of critical",metavar="critical")
	parser.add_option("-D",action="store_true",dest="perf_data",help="for the nagios grapth etc(pnp4nagios)")
	option,args = parser.parse_args()
	host = option.host or "localhost"
	port = option.port or 3306
	username = option.username or "root"
	password = option.password or None
	query = option.query
	perf_data = option.perf_data or False
	warning = option.warning or None
	critical = option.critical or None
	slavestatus(host,port,username,password,query,perf_data,warning,critical)

def numeric_type(param):
    if ((type(param)==float or type(param)==int or param==None)):
        return True
    return False

def check_levels(param, warning, critical,message,ok=[]):
    if (numeric_type(critical) and numeric_type(warning)):
        if param >= critical:
            print "CRITICAL - " + message
            exit(2)
        elif param >= warning:
            print "WARNING - " + message
            exit(1)
        else:
            print "OK - " + message
            return 0
    else:
        if param in critical:
            print "CRITICAL - " + message
            exit(2)

        if param in warning:
            print "WARNING - " + message
            exit(1)

        if param in ok:
            print "OK - " + message
            return 0

        # unexpected param value
        print "CRITICAL - Unexpected value : %d" % param + "; " + message
        exit(2)

def performance_data(perf_data,param):
    data=''
    if perf_data:
        data= " |"
        for p in param:
            p+=(None,None,None,None)
            param,param_name,warning,critical=p[0:4];
            data +=" %s=%s" % (param_name,str(param))
            if warning or critical:
                warning=warning or 0
                critical=critical or 0
                data+=";%s;%s"%(warning,critical)
    return data
	
def exit_with_general_warning(e):
    if isinstance(e, SystemExit):
        return e
    else:
        print "WARNING - General mysql warning:", e
    exit(1)

def exit_with_general_critical(e):
    if isinstance(e, SystemExit):
        return e
    else:
        print "CRITICAL - General mysql Error:", e
    exit(2)

def slavestatus(host,port,username,password,query,perf_data,warning,critical):
	try:
		warning =warning or 120
		critical=critical or 180
		db = _mysql.connection(host=host,port=port,user=username,passwd=password)
		db.query("show slave status")
		result = db.store_result()
		status = result.fetch_row(how=2)[0]
		if query in status:
			param = status[query]
			if re.match(r"^\d+$",param):
				param = float(param)
		else:
			print "WARNING - there are on status %s in slave" % query
			exit(1)
		message="%s is %.2f" % (query,param)
		message+=performance_data(perf_data,[(param,query,warning,critical)])
		return check_levels(param,warning,critical,message)
	except Exception, e:
		print e
		return exit_with_general_critical(e)

if __name__ == "__main__":
	main(sys.argv)
