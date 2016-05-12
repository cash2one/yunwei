


show plugins; //查看插件

show variables like 'plugin_dir'; //插件的位置


semisync_master.so // 主 
semisync_slave.so  //从


1.异步同步先设置好。

2.安装插件



主库：
install plugin rpl_semi_sync_master soname 'semisync_master.so';

//建议：将这些变量保存在配置文件中
set global rpl_semi_sync_master_enabled =1;  //启用
set global rpl_semi_sync_master_timeout = 3000;  //等待salve响应时间,超过3s,则临时转换异步复制


从库：
install plugin rpl_semi_sync_slave soname 'semisync_slave.so';

//建议：将这些变量保存在配置文件中
set global rpl_semi_sync_slave_enabled =1;  //启用

//重新其中io_thread
stop slave io_thread;
start slave io_thread; 




主库：
show status like 'rpl_semi_sync%'; 
+--------------------------------------------+-------+
| Variable_name                              | Value |
+--------------------------------------------+-------+
| Rpl_semi_sync_master_clients               | 1     |
| Rpl_semi_sync_master_net_avg_wait_time     | 0     |
| Rpl_semi_sync_master_net_wait_time         | 0     |
| Rpl_semi_sync_master_net_waits             | 0     |
| Rpl_semi_sync_master_no_times              | 0     |
| Rpl_semi_sync_master_no_tx                 | 0     |
| Rpl_semi_sync_master_status                | ON    |
| Rpl_semi_sync_master_timefunc_failures     | 0     |
| Rpl_semi_sync_master_tx_avg_wait_time      | 0     |
| Rpl_semi_sync_master_tx_wait_time          | 0     |
| Rpl_semi_sync_master_tx_waits              | 0     |
| Rpl_semi_sync_master_wait_pos_backtraverse | 0     |
| Rpl_semi_sync_master_wait_sessions         | 0     |
| Rpl_semi_sync_master_yes_tx                | 0     |
+--------------------------------------------+-------+

插入数据后：

mysql> show status like 'rpl_semi_sync%';
+--------------------------------------------+-------+
| Variable_name                              | Value |
+--------------------------------------------+-------+
| Rpl_semi_sync_master_clients               | 1     |
| Rpl_semi_sync_master_net_avg_wait_time     | 972   |
| Rpl_semi_sync_master_net_wait_time         | 972   |
| Rpl_semi_sync_master_net_waits             | 1     |
| Rpl_semi_sync_master_no_times              | 0     |
| Rpl_semi_sync_master_no_tx                 | 0     |  //  异常,会累加
| Rpl_semi_sync_master_status                | ON    |
| Rpl_semi_sync_master_timefunc_failures     | 0     |
| Rpl_semi_sync_master_tx_avg_wait_time      | 889   |
| Rpl_semi_sync_master_tx_wait_time          | 889   |
| Rpl_semi_sync_master_tx_waits              | 1     |
| Rpl_semi_sync_master_wait_pos_backtraverse | 0     |
| Rpl_semi_sync_master_wait_sessions         | 0     |
| Rpl_semi_sync_master_yes_tx                | 1     |
+--------------------------------------------+-------+











从库：
show status like 'rpl_semi_sync%';
+----------------------------+-------+
| Variable_name              | Value |
+----------------------------+-------+
| Rpl_semi_sync_slave_status | ON    |
+----------------------------+-------+

//Slave has read all relay log 证明从主库读取完成了正在等待中..
mysql> show processlist;
+----+-----------------+-----------+------+---------+------+-----------------------------------------------------------------------------+------------------+
| Id | User            | Host      | db   | Command | Time | State                                                                       | Info             |
+----+-----------------+-----------+------+---------+------+-----------------------------------------------------------------------------+------------------+
|  1 | event_scheduler | localhost | NULL | Daemon  | 1997 | Waiting on empty queue                                                      | NULL             |
|  7 | system user     |           | NULL | Connect |  707 | Slave has read all relay log; waiting for the slave I/O thread to update it | NULL             |
|  8 | root            | localhost | NULL | Query   |    0 | NULL                                                                        | show processlist |
|  9 | system user     |           | NULL | Connect | 1016 | Waiting for master to send event                                            | NULL             |
+----+-----------------+-----------+------+---------+------+-----------------------------------------------------------------------------+------------------+
4 rows in set (0.00 sec)



