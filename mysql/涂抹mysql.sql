

innoDB 高并发写入 比MyISAM 效果好
因为：innnoDB 是行级锁，MyISAM是表级锁


MyISAM 主要优点：查询快,写入快。




列的长度加起来不能超过 65532B





mysql 多线程并行的数据库系统





desc tablename;
show create table tablename;


alter table dbname.tablename  add email varchar(10),modify username varchar(10);

#尽可能减少sql语句的执行次数,尤其针对InnoDB引擎的表对象,每次执行结构的变更都相当于整表的重建.


rename table tablename to new_tablename  #不仅能够对表重命名,而且可以用来移动表,比如从一个库移到另一个库

rename table dbname.tablename to  dbname.tablename;


#给lpx设设置密码
set password for lpx=password('password')

#设置lpx用户密码过期//用户可以登陆但不能操作
alter user lpx password expire;

show engines; //查看所有引擎
show variables like '%storage_engine%'; //当前存储引擎
show create table 表名; //查看表使用什么引擎



grant all on *.* to root@'127.0.0.1' identified by '${PASSWD}';

flush privileges;

#授予lpx用户查询mysql库的user表的权限
grant select on mysql.user to lpx@"localhost";


grant create on test001.* to lpx@localhost;

#查看授予的权限
show grants for lpx@localhost;

#回收lpx在mysql数据库user表查询的权限
revoke select on mysql.user from lpx@localhost;



#回收所有权限
revoke all,grant option from lpx@'localhost';


#删除用户
drop user lpx@localhost,lpx@'192.168.1.1'



#全局
#没有权限密码和主机 可以无需密码与主机登陆mysql
grant create on *.* to lpx;

select * from mysql.user where user='lpx'\G




#用户什么权限
desc mysql.tables_priv;


grant all on lpxdb.users to lpx;

select * from mysql.tables_priv;



#列权限
#授予lpx用户在dbname库tablename表name列的查询权限
grant select (name) on dbname.tablename to lpx@localhost;

#限制之后lpx用户只显示name列
desc test001.username;

#查询列限制
select * from mysql.columns_priv;



#mysql操作日志存在在~/.mysql_history


======================
#忘记密码
/usr/local/mysql/bin/mysqld_safe --defaults-file=/etc/my_5002.cnf --skip-grant-tables --skip-networking&

mysql #登陆root权限

#修改密码
#在关闭mysql
mysqladmin shutdown -S /tmp/mysql_5002.sock -pExia@LeYou

#常规重启
======================




#字符集和校队规则的设定
1:首先是连接数据库，执行操作时所使用的字符集
2:其次保存数据是所使用的字符集

1:编译时指定2个参数
--DDEFAULT_CHARSET=utf8 \
--DDEFAULT_COLLATION=utf8_general_ci \
2:启动mysql服务是通过参数设置
3：在参数文件配置
chararter_set_server=utf8
collation_server=utf8_general_ci
4：在mysql服务运行期间实施修改
#查看
show global variables like '%server';

#设置
set global chararter_set_server=
set collation_server=



#存储引擎
show engines\G  

MyISAM:
mysql 5.5版本之前数据库默认的引擎

文件扩展名：
.frm   对象结构定义文件,用于储存表对象的结构
.MYD    数据文件
.MYI   索引文件


主要优点：查询快,写入快。

引擎存储格式：
1：定长(Fixed,也称静态)              空间大,时间短
2：动态(dynamic)                     空间小,时间长
3: 压缩(compressed)


查看表的格式：
show table status like 'tablename'\G



InnoDB 
mysql 5.5 ..

特性：
1.设计遵循ACID模型,支持事务,拥有从服务器崩溃中恢复的能力,能够最大限度的保护用户的数据
ACID   原子性(Atomiocity),一致性(Consistency),隔离性(Isolation),持久性(Durability)
2.支持行级锁,以提高多用户并发时的读写性能
3.在维护数据完整性方面,InnoDB支持外键约束
4.mysql服务在启动时能够自动进行故障恢复
5.拥有自己独立的缓冲池
6.对于insert,update,delete操作,会被一种称为change buffering的机制自动优化。
7.InnoDB不仅仅提供了一致性读,而且还能够缓存变更的数据,以减少磁盘I/O

//查看事务
show variables like 'autocommit';
//设置
set autocommit=off;

innoDB 逻辑存储结构,从小到大分成4种粒度
1.页,pagesize = 16KB  innodb_page_size  4 8 16KB 三种
2.扩展//区  固定1M 
3.段
4.表空间




 show variables like '%query_log%';

慢查询：
slow_query_log : 1 表输出   0：不输出(默认)

slow_query_log_file:  日志文件存储路径


long_query_time 默认10s 查询语句执行时间超过

min_examined_row_limit 访问的记录数 默认0 条


工具:mysqldumpslow




mysql> show variables like '%general%';  
+------------------+----------------------------+
| Variable_name    | Value                      |
+------------------+----------------------------+
| general_log      | OFF                        |
| general_log_file | /var/run/mysqld/mysqld.log |


普通查询：
 不仅仅查询语句,而且能够记录mysqld进程所做的几乎所有操作,不仅仅是客户端发出的sql语句会被记录到普通查询日志中,
 对于数据库或对象的管理操作也会记录下来,甚至连客户端连接或断开连接,也会向文件写入相应信息.

1.默认不启用
general_log 0:禁用 1：启用
general_log_file 文件路径 


set global general_log = 'OFF';




bin-log

reset master 清除所有的二进制日志文件
purge binary logs 用来删除知道的某个或某些日志文件


--binlog-do-db  指定某数据库修改行为 记录二进制日志
--binlog-ignore-db     不记录





导入
mysqlimport 

-L 客户端本地读取文件
-d 导入时先删除数据
-l 导入时先锁表
-s 静默模式
--use-threads=  //并行加载数据,  32 64 线程


mysqlimport ${SILENT} --local -u ${DB_USER} -p"${DB_PASS}" ${DB_NAME} `find ${DB_DIR} -name "*.txt"`




导入
//默认以tab作为分隔符
load data infile 'tables.txt' into table ;


导出格式

select * from tablename into outfile '路径'

//以,分隔 以""作为字段值使用双引号
select * from tablename into outfile '路径' fields terminated by ','  optionally enclosed by '"';








mysqldump
 --default-character-set:设置字符集,默认utf-8
 -A 导出所有数据库
-B 导出指定数据库或几个数据库
--tables 导出表(--tables db table)

-d ,--no-date 只导出对象结构
-t  只导出结构 
-l 锁表//默认选项

--single-transaction  

-F,--flush-logs ,导出前 先刷新日志，如果全库导出，建议刷新日志文件


-T tab 导出以txt文件结尾的文件

//备份数据库; 备份结构与txt.....后面用mysqlimport 导入
mysqldump -u${DB_USER} -p${DB_PASS} -d ${ONE_DB_NAME} > ${WORK_DIR}/${ONE_DB_NAME}_db_struc.sql
mysqldump --default-character-set=binary -F -u${DB_USER} -p${DB_PASS} -T ${WORK_DIR}/ ${ONE_DB_NAME}



//锁tablename 只读
flush tables tablename with read lock;

//解锁
unlock tablename;


mysqlhotcopy         //只用于myisam
它将flush tables,lock tables 以及cp/scp等命令封装调用

//将database库保存在/tmp
mysqlhotcopy -u -p  database /tmp/






mysqlbinlog

--set-charset 
-d 只处理与指定数据库相关的日志
--start-datetime  分析的起始时间点
--stop-datetime  分析的结束时间点
--stop-positison 结束时间位置












innobackupex备份  ---  既有MyISAM 又有innodb 


XtraBackup 热备工具 ---若只有innodb
优点: 
备份集高效,完整,可用
备份任务执行过程中不会阻塞事务
节省磁盘空间,降低网络带宽占用
备份集自动验证机制
恢复更快





mysql 复制过程默认是异步的。



启动sql_thread 线程
start slave sql_thread; 

start slave io_thread;





异步：
mysql复制默认是异步的,主节点down,从节点可能会丢失数据(因为,主节点不知道从节点什么时候来读取二进制文件)

异步无法解决及时性.出现半同步机制

同步机制：(目前自身不支持同步复制,考虑到mysql定位)
master 节点每进行一个操作,在事务提交并返回成功信息给发出请求的回话前
先等待slave节点本地执行这个事务,并返回成功信息给master节点
再分布式事务中,叫两阶段提交.
优点：保证数据安全
缺点：中间可能出现较长时间的延迟，对性能造成影响。


读写分离-由于主从之间数据同步是异步机制,默认情况下无法保障,对于数据的一致性和及时性要求较高的场景

半同步 
可以有效解决主从读写分离

半同步原理：
master 再返回操作成功(失败)信息给发起请求的客户端前，
还是要将事务发给slave节点，只要一个从节点 *接收* 到了事务,不需要等待从节点返回 *执行* 完这个事务,就算成功
不过为了降低中间的数据通信，数据传输及事件等待等成本。




查看半同步插件的位置

show variables like 'plugin_dir';

semisync_master.so 主节点
semisync_slave.so 从节点


master节点：
install plugin rpl_semi_sync_master soname 'semisync_master.so';

slave节点：
install plugin rpl_semi_sync_master soname 'semisync_slave.so';


master节点：
set global rpl_semi_sync_master_enabled = 1;
set global rpl_semi_sync_master_timeout = 3000;

3000毫秒=3s

slave节点：
set global rpl_semi_sync_master_enabled = 1;


stop slave io_thread;
start slave io_thread;


监控半同步复制环境

show status like 'rpl_semi_sync_%'

若干个以Rpl_semi_sync_* 开头的状态变量

slave节点：
Rpl_semi_sync_slave_status

master节点：
Rpl_semi_sync_master_clients  slave节点数量
Rpl_semi_sync_master_status   是否启用
Rpl_semi_sync_master_no_tx     未成功发送到slave事务数量
Rpl_semi_sync_master_yes_tx    成功发送到slave事务数量


============================================================= 性能：=============================================================



IOPS : 每秒能够处理的I/O请求次数,不是读写的数据吞吐量


硬盘IO检测

1：top
查看%wa 
IO等待所占用的CPU时间的百分比,高过30%时IO压力高


2：iostat -x 1 10

查看%util 100.10 %idle 66.29

如果 %util 接近 100%，说明产生的I/O请求太多，I/O系统已经满负荷，该磁盘可能存在瓶颈。
idle小于70% IO压力就较大了,一般读取速度有较多的wait.



数据库
QPS:每秒请求查询次数
QPS=Questions/uptime //uptime 时间单位

show global status like 'Questions';//mysql生命周期
每秒获取Questions的值相减



TPS 提交事务指标

TPS = (Com_commit + Com_rollback) / seconds



1.mysqladmin

mysqladmin extended-status命令可以获得所有MySQL性能指标，
即show global status的输出，不过，因为多数这些指标都是累计值，如果想了解当前的状态，则需要进行一次差值计算，
这就是mysqladmin extended-status的一个额外功能，非常实用。
默认的，使用extended-status，看到也是累计值
但是，加上参数-r(--relative)，就可以看到各个指标的差值，配合参数-i(--sleep)就可以指定刷新的频率
-r 能够自动将状态变量本次输出的参数值与前次参数值相减

//得到QPS
mysqladmin -hlocalhost -S /tmp/mysql_5001.sock -pExia@LeYou extended-status -r -i 1|grep "Questions"

//得到查询与更新数
mysqladmin -hlocalhost -S /tmp/mysql_5001.sock -pExia@LeYou extended-status -r -i 1|grep -E "Com_select|Com_update"





2.mysqlslap 专用轻量压测工具


mysqlslap -hlocalhost -S /tmp/mysql_5001.sock -pExia@LeYou --query="select * from auth_user" --number-of-queries=1000000 -c 30 -i 1 --create-schema=blog


--number-of-queries 请求数次
-c 并发度
-i 运行次数
--create-schema 指定库



Benchmark
        Average number of seconds to run all queries: 12.471 seconds
        Minimum number of seconds to run all queries: 12.471 seconds
        Maximum number of seconds to run all queries: 12.471 seconds
        Number of clients running queries: 30
        Average number of queries per client: 33333


//获取QPS
#执行300万次(插入+查询)请求:
mysqlslap -hlocalhost -S /tmp/mysql_5001.sock -pExia@LeYou \
--auto-generate-sql --auto-generate-sql-add-autoincrement \
--auto-generate-sql-execute-number=100000 \
--auto-generate-sql-unique-query-number=10000 \
-c 30 --commit=10000 --create-schema=blog





3：TPCC




性能：

show global variables like 'max_con%';
#允许连接不成功的最大尝试次数
max_connect_errors // 忽略 或者设置10w以上
#最大并发连接数
max_connections    //show variables like 'max_connections';


skip-name-resolve 启动,加快网络连接速度




MyISAM 专用参数

1：key_buffer_size  //MyISAM 表索引的缓存区大小

该参数不是越大越好,建议该值不要超过物理内存的25%,128M 就顶天了.




mysqlsla 处理慢查询日志,还可以分析其它日志(二进制,普通日志..)


#mysql语句在做什么
show processlist;
查看Time command  id 

kill  id



mysql监控  

nagios
check_mysql_health 插件














