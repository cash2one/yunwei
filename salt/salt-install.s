1：安装epel yum 源
2：yum install -y salt-master
3:/etc/init.d/salt-master start
4:yum install -y salt-minion
5:/etc/init.d/salt-minion start


------------------client------------------
空格master:空格192.168.172.213
 id: salt-client-01

#版本
salt --versions-report

 


salt 不能与spawn公用








认证：
salt-key -L
#若没有发现任何key
#则增加hosts  (master,minion)
salt-minion -l debug

salt '*' state.highstate -v test=True   #测试
salt '*' state.highstate

salt 'sa10-003' state.sls nginx 


#显示客户端的基本信息
salt \* grains.items

//pillar  

salt '*' pillar.data  //查看minion的数据

salt '*' saltutil.refresh_pillar //刷新


salt \*  pillar.get vhost:name
salt \*  pillar.item vhost:name



master_job_cache 
可将event输出到数据库





salt '*' saltutil.sync_returners 


salt '*' pillar.items 

salt \* grains.items
//同步modules
salt '*' saltutil.sync_all




传送文件：
#master 配置
 file_roots:
   base:
     - /data/salt/

[root@salt-master ~]# salt '*'  cp.get_file salt://1.txt /root/1.txt
salt-client-01:
    /root/1.txt


#计算md5
salt '*' file.get_sum /etc/resolv.conf md5
#查看状态 
salt '*' file.stats /etc/resolv.conf


#network模块（返回被控主机网络信息）
salt '*' network.ip_addrs
salt '*' network.interfaces

## 远程命令执行测试
salt '*' cmd.run 'uptime'
#-L 列表
salt -L 'salt-minion,salt-master' cmd.run 'w'
#-E 正则
salt -E 'salt-*' cmd.run 'w'
#-G 这个参数很强大 会根据默认的grain的结果来 指定最新 grain这个东西就像puppet里面的facter这个东西
salt -G 'cpuarch:x86_64' grains.item num_cpus

#节点分类
# name and a compound target.
  nodegroups:
    base: 'L@salt-master,salt-minion'
    minion1: 'G@os:Centos'
    minion2: 'L@salt-minion'

[root@salt-master salt]# salt -N base test.ping
salt-master:
    True
salt-minion:
    True
[root@salt-master salt]# salt -N minion1 test.ping
salt-minion:
    True
salt-master:
    True
[root@salt-master salt]# salt -N minion2 test.ping
salt-minion:
    True

#-C表示多参数(表示在测试多台主机的存活状态)
salt -C 'salt-minion or salt-master' test.ping 

#磁盘利用率
salt \* disk.usage

#执行脚本 会将文件传到客户端 /var/cache/salt/minion/files/base/下
salt \* cmd.script salt://1.sh



## 远程代码执行测试
salt '*' cmd.exec_code python 'import sys; print sys.version'



## 显示被控主机的操作系统类型
salt '*' grains.item os

#安装包
salt '*' pkg.install nmap 
salt '*' pkg.file_list nmap

#分组
salt -G 'os:Centos' test.ping












#计划任务
salt \* cron.set_job root '*/1' '*' '*' '*' '*' 'date>/dev/null 2>&1'
salt '*' cron.raw_cron root



salt \* cron.set_job root '*/1' '*' '*' '*' '*' ' tw.pool.ntp.org >/dev/null 2>&1'

salt \* cron.set_job root '*/5' '*' '*' '*' '*' '/usr/sbin/ntpdate -u asia.pool.ntp.org > /var/log/ntpdate.log 2>&1'





#安装软件
#1
salt \* cmd.run 'yum install -y crontabs '
#2
salt '*' pkg.install crontabs



sls 配置文件语法：
	缩进：使用两个空格进行缩进
		类似于”rendering sls files errors“等错误，请检查你的sls文件，确保没有Tabs出现





minion:
    'state.highstate' is not available.


删除了 /var/cache/master  和  /var/cache/minion   
restart



如果Minion连接不上, 想删除它的pillar缓存, 可以使用salt-run中的cache模块来处理, 比如你这个, 假设minion是 minion-01

salt-run cache.clear_pillar  tgt='minion-1' 即可






########################################################################################################################################


########################################################################################################################################

//输出格式化到文件
salt \* test.ping --out=json --out-file=json --no-color

salt \* test.ping --out=yaml


/var/cache/salt/minion








将所有被控主机的/etc/httpd/httpd.conf文件的LogLevel参数的warn修改成info

salt '*' file.sed /etc/httpd/httpd.conf 'LogLevel warn' 'LogLevel info'

给所有被控主机的/tmp/test/test.conf 文件追加内容'maxclient 1000'

salt '*' file.append /tmp/test/test.conf 'maxclient 1000'

删除所有被控主机的/etc/foo文件

salt '*' file.remove /etc/foo


###jid   /var/cache/salt

查看以前操作的历史记录
salt-run jobs.list_jobs
通过jid 查看返回信息
salt-run jobs.lookup_jid 20160918105014110668 

查看正在运行的任务
salt-run jobs.active


Job常用管理

saltutil模块中的job管理⽅法

saltutil.running #查看minion当前正在运⾏的jobs

saltutil.find_job<jid> #查看指定jid的job(minion正在运⾏的jobs)

saltutil.signal_job<jid> <single> #给指定的jid进程发送信号

saltutil.term_job <jid> #终⽌指定的jid进程(信号为15)

saltutil.kill_job <jid> #终⽌指定的jid进程(信号为9)


curl -k https://139.196.231.187:8888/login -H "Accept: application/x-yaml" \
     -d username='saltapi' \
     -d password='saltapi' \
     -d eauth='pam'




curl -sSk https://192.168.30.129:8888/run \
    -H 'Accept: application/x-yaml' \
    -d client='local' \
    -d tgt='*' \
    -d fun='test.ping' \
    -d username='saltapi' \
    -d password='saltapi' \
    -d eauth='pam'


curl -sik https://139.196.231.187:8888 \
        -H "Accept: application/x-yaml" \
        -H "X-Auth-Token: bada51e58f7b59470a91b4de9b1eddfc400835c1" \
        -d client=local \
        -d tgt='data-2' \
        -d fun='cmd.run' \
        -d arg="uanme -a"



curl -k https://192.168.30.129:8888/keys -H "Accept: application/x-yaml" -H "X-Auth-Token: 496233d095aa7b8635fc7c91446816258bf0f7ae" 
 
192.168.30.129
139.196.231.187 
/////////////////////////////////////////////////
curl -k https://192.168.30.129:8888/jobs/ \
     -H "Accept: application/x-yaml" \
     -H "X-Auth-Token: dfb9a18e618fd0576f2887cd5a6a47578f0798e2"




curl -k https://139.196.231.187:8888/ \
        -H "Accept: application/x-yaml" \
        -d client='wheel' \
        -d fun='key.list_all' \
        -H "X-Auth-Token: c972b71aa7935069d6fa9bafdc5a7cfa38180e9f"     






