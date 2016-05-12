

NAME
       check_mysql_all - Nagios checks for 4.0+ versions of MySQL

SYNOPSIS
        check_mysql_all -K <check_name> [options]

        Options:
          -a, --args=<key=value>    Optional arguments.
          -K, --check=<check_name>  The check to run
          -c, --critical=<limit>    The level at which a critical alarm is raised.
          -d, --database=<dbname>   The database to use
          -h, --help                Display this message and exit
          -H, --host=<hostname>     The target MySQL server host
          -p, --password=<password> The password of the MySQL user
          --port=<portnum>          The port MySQL is listening on
          -s, --socket=<sockfile>   Use the specified mysql unix socket to connect
          -t, --timeout=<timeout>   Seconds before connection/query attempts timeout
          -u, --username=<username> The MySQL user used to connect
          -v, --verbose             Increase verbosity level
          -V, --version             Display version information and exit
          -w, --warning             The level at which a warning is raised.

        Defaults are:

        ATTRIBUTE                  VALUE
        -------------------------- ------------------
        args                       No default value
        check                      No default value
        critical                   Check-specific
        database                   No default value
        help                       FALSE
        host                       localhost
        password                   No default value
        port                       3306
        socket                     No default value
        timeout                    10 seconds
        username                   No default value
        verbose                    1 (out of 3)
        version                    FALSE
        warning                    Check-specific

        The following checks are supported:

        connect repl_io repl_sql repl_sbm repl_all mysql_query connections table_status

OPTIONS
       --args⎪-a
           Optional additional arguments for a particular check. Always takes the for‐
           mat "--args 'foo=bar'". Check specific and can be repeated as often as nec‐
           essary.

       --check⎪-K
           The check to run, see CHECKS section for details. Only one check may be
           specified at a time.

       --critical⎪-c
           The level at which a critical alarm is raised. Check-specific.

       --database⎪-d
           The database to use. No default value, will connect without a database if
           not specified.

       --help⎪-h
           Display a short help message and exit.

       --host⎪-H
           The target MySQL server host.

       --password⎪-p
           The password of the MySQL user.

       --port
           The port MySQL is listening on.

       --socket⎪-s
           Use the specified unix socket to connect with. Ignored if --host is speci‐
           fied or is anything except 'localhost'.

       --timeout⎪-t
           Seconds before connection/query attempts timeout. Note that this does NOT
           mean that the whole plugin will timeout in this interval, just the initial
           connection and each subsequent db query. The "mysql_query" check has also
           has a separate timeout for the test query in case a different timeout is
           desired.

       --username⎪-u
           The MySQL user used to connect

       --verbose⎪-v
           Increase verbosity level. Can be used up to three times.

       --version⎪-V
           Display version information and exit.

       --warning⎪-w
           The level at which a warning is raised.  Check-specific.

CHECKS
       connect
           Checks connectivity to the target database server.  Returns CRITICAL if not
           able to connect, OK otherwise.
               Permissions required: USAGE
               --args => ignored
               --warning => ignored
               --critical => ignored

       repl_io
           Checks whether on not the IO Replication thread is running.  Returns CRITI‐
           CAL if not running, OK otherwise.
               Permissions required: REPLICATION CLIENT
               --args => ignored
               --warning => ignored
               --critical => ignored

       repl_sql
           Check to see whether or not the SQL Replication thread is running.  Returns
           CRITICAL if not running, OK otherwise.
               Permissions required: REPLICATION CLIENT
               --args => ignored
               --warning => ignored
               --critical => ignored

       repl_sbm
           Check how many seconds behind the master the slave is.
               Permissions required: REPLICATION CLIENT
               --args => ignored
               --warning => default 30 seconds
               --critical => default 60 seconds

       repl_all
           Combine repl_io, repl_sql, and repl_sbm checks into one.  Returns CRITICAL
           on failure of IO or SQL threads or if seconds behind master is greater than
           the limit.  Returns WARNING only if seconds behind master is greater than
           the limit.
               Permissions required: REPLICATION CLIENT
               --args => ignored
               --warning => default 30 seconds
               --critical => default 60 seconds

       mysql_query
           Run a given query, test if it executes properly.  Returns CRITICAL if the
           query fails to execute for whatever reason, OK otherwise.
               Permissions required: depends on the query
               --args => no default:
                   "query=..." => the query to run
                   "query_timeout=..." => optional query timeout (default 30 seconds)
               --warning => ignored
               --critical => ignored

       connections
           Test if the percentage of used connections is over a given threshold.
               Permissions required: PROCESS
               --args => ignored
               --warning => default 80%
               --critical => default 90%

       table_status
           Test all tables in a given database for errors, or all tables in all data‐
           bases if --database is not given.
               Permissions required: SELECT
               --args => ignored
               --warning => ignored
               --critical => ignored

SYSTEM REQUIREMENTS
       check_mysql_all requires the following Perl modules:

         Pod::Usage
         Getopt::Long
         DBI
         DBD::mysql

BUGS
       Please report all bugs and feature requests to
       http://code.google.com/p/check-mysql-all

LICENSE
       This program is copyright (c) 2008 Ryan Lowe.  Feedback and improvements are
       welcome (rlowe@pablowe.net).

       THIS PROGRAM IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES,
       INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND
       FITNESS FOR A PARTICULAR PURPOSE.

       This program is free software; you can redistribute it and/or modify it under
       the terms of the GNU General Public License as published by the Free Software
       Foundation, version 2; OR the Perl Artistic License.  On UNIX and similar sys‐
       tems, you can issue `man perlgpl' or `man perlartistic' to read these licenses.

       You should have received a copy of the GNU General Public License along with
       this program; if not, write to the Free Software Foundation, Inc., 59 Temple
       Place, Suite 330, Boston, MA  02111-1307 USA.

AUTHOR
       Ryan Lowe (rlowe@pablowe.net)

VERSION
       This manual page documents 0.0.3 of check_mysql_all

