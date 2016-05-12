



yum install nfs portmap -y


/etc/init.d/rpcbind start
/etc/init.d/rpcidmapd start
/etc/init.d/nfs start


修改iptables配置文件/etc/sysconfig/iptables，放开111（portmap服务端口），2049（nfs服务端口）

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/etc/exports文件内容格式：

<输出目录> [客户端1 选项（访问权限,用户映射,其他）] [客户端2 选项（访问权限,用户映射,其他）]

a. 输出目录：

输出目录是指NFS系统中需要共享给客户机使用的目录；

b. 客户端：

客户端是指网络中可以访问这个NFS输出目录的计算机

客户端常用的指定方式

    指定ip地址的主机：192.168.0.200
    指定子网中的所有主机：192.168.0.0/24 192.168.0.0/255.255.255.0
    指定域名的主机：david.bsmart.cn
    指定域中的所有主机：*.bsmart.cn
    所有主机：*

c. 选项：

选项用来设置输出目录的访问权限、用户映射等。

NFS主要有3类选项：

访问权限选项

    设置输出目录只读：ro
    设置输出目录读写：rw

用户映射选项

    all_squash：将远程访问的所有普通用户及所属组都映射为匿名用户或用户组（nfsnobody）；
    no_all_squash：与all_squash取反（默认设置）；
    root_squash：将root用户及所属组都映射为匿名用户或用户组（默认设置）；
    no_root_squash：与rootsquash取反；
    anonuid=xxx：将远程访问的所有用户都映射为匿名用户，并指定该用户为本地用户（UID=xxx）；
    anongid=xxx：将远程访问的所有用户组都映射为匿名用户组账户，并指定该匿名用户组账户为本地用户组账户（GID=xxx）；

其它选项

    secure：限制客户端只能从小于1024的tcp/ip端口连接nfs服务器（默认设置）；
    insecure：允许客户端从大于1024的tcp/ip端口连接服务器；
    sync：将数据同步写入内存缓冲区与磁盘中，效率低，但可以保证数据的一致性；
    async：将数据先保存在内存缓冲区中，必要时才写入磁盘；
    wdelay：检查是否有相关的写操作，如果有则将这些写操作一起执行，这样可以提高效率（默认设置）；
    no_wdelay：若有写操作则立即执行，应与sync配合使用；
    subtree：若输出目录是一个子目录，则nfs服务器将检查其父目录的权限(默认设置)；
    no_subtree：即使输出目录是一个子目录，nfs服务器也不检查其父目录的权限，这样可以提高效率；



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////





vim /etc/exports
/data/salt 10.10.172.0/24(rw)





$$$默认就有sync，wdelay，hide 等等，no_root_squash 是让root保持权限，root_squash 是把root映射成nobody，no_all_squash 不让所有用户保持在挂载目录中的权限。所以，root建立的文件所有者是nfsnobody。


$$$普通用户就是自己的名字
-rw-rw-r-- 1 root1     root1            2 May  7 11:43 2.txt






//客户端

错误1：
[root@salt-minion ~]# mount -t nfs 10.10.172.10:/data/salt /data/salt
mount: wrong fs type, bad option, bad superblock on 10.10.172.10:/data/salt,
       missing codepage or helper program, or other error
       (for several filesystems (e.g. nfs, cifs) you might
       need a /sbin/mount.<type> helper program)
       In some cases useful info is found in syslog - try



解决：

yum install nfs-utils  -y 




错误2：
[root@salt-minion salt]# showmount -e
clnt_create: RPC: Unknown host


解决：
[root@salt-minion salt]# /etc/init.d/rpcsvcgssd start
[root@salt-minion salt]# /etc/init.d/nfs restart


showmount -e nfsIP






自动挂载：
/etc/fstab









