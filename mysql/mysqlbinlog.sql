


#导入表结构
mysql -p`cat /data/save/mysql_root`
source 表结构;
exit;
#恢复表
mysqlimport --local -p`cat /data/save/mysql_root` dzmo_admin_tw_1 *.txt


#查找记录
mysqlbinlog --no-defaults --database=dzmo_admin_tw_1 --start-date="2015-10-20 04:05:00" --stop-date="2015-10-20 20:35:00" mysql-bin.000731 


#恢复到数据库中
mysqlbinlog --no-defaults --database=dzmo_admin_tw_1 --start-date="2015-10-20 04:05:00"  mysql-bin.000731 |mysql -p`cat /data/save/mysql_root`
mysqlbinlog --no-defaults --database=dzmo_admin_tw_1  mysql-bin.000732 |mysql -p`cat /data/save/mysql_root`
mysqlbinlog --no-defaults --database=dzmo_admin_tw_1  mysql-bin.000733 |mysql -p`cat /data/save/mysql_root`
mysqlbinlog --no-defaults --database=dzmo_admin_tw_1  mysql-bin.000734 |mysql -p`cat /data/save/mysql_root`
mysqlbinlog --no-defaults --database=dzmo_admin_tw_1  mysql-bin.000735 |mysql -p`cat /data/save/mysql_root`
mysqlbinlog --no-defaults --stop-date="2015-10-20 20:35:00" --database=dzmo_admin_tw_1  mysql-bin.000736 |mysql -p`cat /data/save/mysql_root` test




#起始bin   最后的时间
mysqlbinlog mysql-bin.32 --start-position=xxx  --stop-datetime "2015-5-14 20:20:00" > /tmp/mybinlog.sql

























mysqlbinlog --no-defaults --database=dzmo_tw_1 --start-date="2015-10-20 04:05:00"  mysql-bin.000731 |mysql -p`cat /data/save/mysql_root`
mysqlbinlog --no-defaults --database=dzmo_tw_1  mysql-bin.000732 |mysql -p`cat /data/save/mysql_root`
mysqlbinlog --no-defaults --database=dzmo_tw_1  mysql-bin.000733 |mysql -p`cat /data/save/mysql_root`
mysqlbinlog --no-defaults --database=dzmo_tw_1  mysql-bin.000734 |mysql -p`cat /data/save/mysql_root`
mysqlbinlog --no-defaults --database=dzmo_tw_1  mysql-bin.000735 |mysql -p`cat /data/save/mysql_root`
mysqlbinlog --no-defaults --stop-date="2015-10-20 20:35:00" --database=dzmo_tw_1  mysql-bin.000736 |mysql -p`cat /data/save/mysql_root`








#测试
从导出的sql完成时间到指定时间导入(一张表) ok
mysqlbinlog --no-defaults --database=test --start-date="2016-03-07 10:50:21" --stop-date="2016-03-07 10:53:37" mysql-bin.* |mysql -p`cat /data/save/mysql_root`
















