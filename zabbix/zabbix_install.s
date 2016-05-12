
rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime



yum install \
gcc \
mysql-devel \
net-snmp-devel \
net-snmp-utils \
php-gd \
php-mysql \
php-common \
php-bcmath \
php-mbstring \
php-xml \
curl-devel \
iksemel* \
OpenIPMI \
OpenIPMI-devel \
fping \
libssh2-devel \
unixODBC \
unixODBC-devel \
mysql-connector-odbc \
openldap \
openldap-devel \
java \
java-devel \
httpdphp-xml \
libgcc \
make \
net-snmpnet-snmp-devel \
net-snmp-utils \
libxml2 \
libxml2-devel

groupadd zabbix
useradd -g zabbix zabbix

./configure --prefix=/usr/local/zabbix \
--enable-server \
--enable-agent \
--enable-proxy \
--with-mysql \
--enable-java \
--enable-net-snmp \
--with-libcurl \
--with-ldap \
--with-ssh2 \
--with-jabber \
--with-openipmi \
--with-unixodbc


make  && make install


mysql -p`cat /data/save/mysql_root`
create database zabbix character set utf8;
grant all privileges on zabbix.* to 'zabbix'@'192.168.1.%' identified by 'zabbix';
grant all privileges on zabbix.* to 'zabbix'@'127.0.0.1' identified by 'zabbix';
grant all privileges on zabbix.* to 'zabbix'@'localhost' identified by 'zabbix';
quit


cd /root/zabbix-2.4.6/database/mysql
mysql -p`cat /data/save/mysql_root`  zabbix < schema.sql
mysql -p`cat /data/save/mysql_root`  zabbix < images.sql
mysql -p`cat /data/save/mysql_root`  zabbix < data.sql


cd /root/zabbix-2.4.6/conf
cp -R zabbix_agentd /usr/local/zabbix/etc/
cp -R zabbix_agentd.win.conf /usr/local/zabbix/etc/
cp -R zabbix_proxy.conf /usr/local/zabbix/etc/ 


vim /usr/local/zabbix/etc/zabbix_server.conf

DBUser=zabbix
DBPassword=zabbix


vim /etc/services 
zabbix-agent    10050/tcp
zabbix-agent    10050/udp
zabbix-trapper  10051/tcp
zabbix-trapper  10051/udp

chown -R zabbix.zabbix /usr/local/zabbix/


ln -s /usr/local/zabbix/bin/* /usr/bin/
ln -s /usr/local/zabbix/sbin/* /usr/sbin/


cd /root/zabbix-2.4.6/misc/init.d/fedora/core
cp * /etc/init.d/

vim /etc/init.d/zabbix_server
BASEDIR=/usr/local/zabbix
vim /etc/init.d/zabbix_agentd 
BASEDIR=/usr/local/zabbix
chmod +x /etc/init.d/zabbix_*


chkconfig --add zabbix_server
chkconfig --add zabbix_agentd
chkconfig --level 35 zabbix_server on
chkconfig --level 35 zabbix_agentd on

mkdir /data/zabbix 
cd /data/zabbix 
cp -a /root/zabbix-2.4.6/frontends/php/* .
cd ..
chown -R zabbix.zabbix zabbix/



vim /etc/php.ini

max_execution_time = 600
max_input_time = 600
memory_limit = 256M
post_max_size = 32M
upload_max_filesize = 16M

date.timezone = PRC

/etc/init.d/php-fpm restart
cp zabbix.conf /usr/local/services/nginx/conf/conf.d/
./nginx -s reload
/etc/init.d/zabbix_server start
/etc/init.d/zabbix_agentd start


http://zabbix.dz.com





UserParameter=custom.vfs.dev.read.ops[*],cat /proc/diskstats | grep $1 | head -1 | awk '{print $$4}'
UserParameter=custom.vfs.dev.read.ms[*],cat /proc/diskstats | grep $1 | head -1 | awk '{print $$7}'
UserParameter=custom.vfs.dev.write.ops[*],cat /proc/diskstats | grep $1 | head -1 | awk '{print $$8}'
UserParameter=custom.vfs.dev.write.ms[*],cat /proc/diskstats | grep $1 | head -1 | awk '{print $$11}'
UserParameter=custom.vfs.dev.io.active[*],cat /proc/diskstats | grep $1 | head -1 | awk '{print $$12}'
UserParameter=custom.vfs.dev.io.ms[*],cat /proc/diskstats | grep $1 | head -1 | awk '{print $$13}'
UserParameter=custom.vfs.dev.read.sectors[*],cat /proc/diskstats | grep $1 | head -1 | awk '{print $$6}'
UserParameter=custom.vfs.dev.write.sectors[*],cat /proc/diskstats | grep $1 | head -1 | awk '{print $$10}'




测试：
zabbix_get -s 172.31.28.78 -p 10050 -k custom.vfs.dev.write.ops[xvdb1]
zabbix_get -s 172.31.28.78 -p 10050 -k custom.vfs.dev.write.ops[xvdb]







agent install



groupadd zabbix
useradd -g zabbix zabbix

tar xf zabbix-2.4.6.tar.gz

cd zabbix-2.4.6
./configure --prefix=/usr/local/zabbix --enable-agent

make && make install


cp /root/zabbix-2.4.6/misc/init.d/fedora/core/zabbix_agentd  /etc/init.d/


vim /etc/init.d/zabbix_agentd 
BASEDIR=/usr/local/zabbix
chmod +x $_

scp zabbix_agentd.conf 172.31.23.191:/usr/local/zabbix/etc

scp zabbix_agentd.conf.d/disk.conf 172.31.23.191:/usr/local/zabbix/etc/zabbix_agentd.conf.d


默认：
用户名:Admin    注A大写
密码：zabbix




zabbix  安装出错


1：
configure: error: Jabber library not found

tar zxvf iksemel-1.4.tar.gz
cd iksemel-1.4
./configure
make
make install


2：
configure: error: unixODBC library not found

yum install unixODBC-devel


3：
configure: error: SSH2 library not found

yum install php-pecl-ssh2.x86_64 libssh2-devel.x86_64



4:
configure: error: Invalid OPENIPMI directory - unable to find ipmiif.h

yum install OpenIPMI OpenIPMI-devel rpm-build

5:
configure: error: Unable to find "javac" executable in path

yum install java*


6:
[root@salt-master vhosts]# /etc/init.d/zabbix_server restart
Shutting down zabbix_server:                               [FAILED]
Starting zabbix_server:  /usr/local/zabbix/sbin/zabbix_server: error while loading shared libraries: libmysqlclient.so.18: cannot open shared object file: No such file or directory
                                                           [FAILED]
[root@salt-master vhosts]# locate libmysqlclient.so.18
/usr/local/mysql/lib/libmysqlclient.so.18
/usr/local/mysql/lib/libmysqlclient.so.18.0.0
[root@salt-master vhosts]# echo "/usr/local/mysql/lib" >> /etc/ld.so.conf
[root@salt-master vhosts]# ldconfig 













 2.权限问题，zabbix_agentd是zabbix用户启动的，默认不能执行netstat -p等命令，导致从服务器取到的自动发现脚本为空
(Not all processes could be identified, non-owned process info
 will not be shown, you would have to be root to see it all.)
解决方法 ：
chmod +s /bin/netstat 






