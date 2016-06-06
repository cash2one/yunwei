

//层
层其实就是AUFS(一种联合文件系统),是实现增量保存与更新的基础

docker pull ubuntu:14.04
相当与
docker pull registry.hub.docker.com/ubuntu:lastest


运行
docker run -t -i ubuntu /bin/bash


标签
docker tag 

获取详细信息
docker inspect  55xoansjql

//json 格式
docker inspect -f {{".键"}} 55x


创建容器的方法有三种：
1：基于已有的镜像的容器创建
2：基于本地模板导入
3：基于Dockerfile创建





docker commit -m "注释" -a "作者"  镜像 名字





//存出

docker save -o ubuntu_14.04.tar ubuntu:14.04


//载入
docker load --input ubuntu_14.04.tar
或者
docker load < ubuntu_14.04.tar



//新建

docker create -it ubuntu:lastest

docker ps -a 



// 2 种 启动方式


docker run 

#交互
docker run -i -t 


//守护态运行
-d 
 docker run -d  ubuntu /bin/sh -c "while true;...."


docker ps 

docker logs C-id

//终止

docker stop C-id



//进入
docker exec -ti C-id /bin/bash 





//私有仓库
通过官方提供的registry镜像搭建


docker run -d -p 5000:5000 registry

通过-v 将镜像文件存放在本地路径


docker run -d -p 5000:5000  -v /opt/data/registry:/tmp/registry registry



//上传
//下载






////数据卷
-v 


////数据卷容器
专门用它提供数据卷供其它容器挂载使用

docker run -it -v /dbdata --name dbdata ubuntu

查看/dbdata 目录
ls 


其它容器使用 --volumes-from 来挂载 dbdata 容器中的数据卷

docker run -it --volumes-from dbdata --name db1 ubuntu
docker run -it --volumes-from dbdata --name db2 ubuntu


3个容器任何一方写入,其它都能看到


还可以从挂载了容器卷的容器来挂载数据卷

docker run -d --name db3 --volumes-from db1 training/postgres



//利用数据卷容器迁移数据
 //备份
 docker run --volumes-from dbdata -v ${pwd}:/backup  --name worker ubuntu
 tar cvf /backup/backup.tar /dbdata




 //恢复
 #创建一个带数据卷的容器dbdata2
 docker run -v /dbdata --name dbdata2 ubuntu /bin/bash

docker run --volumes-from dbdata2 -v ${pwd}:/backup busybox tar xvf /backup/backup.txr





///端口映射

-P 随机一个 49000-49900

docker run -d -P training/webapp python app.py 

docker ps -l 



-p  指定端口

//查看映射端口配置

docker port c_name 5000


//自定义容器名字
--name 

docker run -d -P --name web training/webapp python app.py 




//#  -- rm   容器早终止是会立刻删除   --rm  和 -d 不能同时使用




//互联

docker run -d --name db training/postgres

docker run -d -P --name web --link db:db training/webapp python app.py 


--link  name:alias


使用env 命令查看容器的环境变量


docker  run --rm --name  web2 --link db:db  training/webapp env


还提供了/etc/hosts 
查看父容器web的host文件





////dockerfile 

4部分：
基本镜像信息
维护者信息
镜像操作指令
容器启动执行指令






























































