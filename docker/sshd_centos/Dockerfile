FROM centos
MAINTAINER from lupuxiao  2016-06-15 14:50

RUN yum update
RUN yum install -y openssh-server
RUN mkdir -p /var/run/sshd
RUN mkdir -p /root/.ssh

RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ""
RUN ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ""
RUN ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""
RUN sed -i '/pam_loginuid.so/d' /etc/pam.d/sshd

#加入key 文件
ADD authorized_keys /root/.ssh/authorized_keys


#开放端口
EXPOSE 22

#设置自动启动
CMD ["/usr/sbin/sshd","-D"]


##生成sshd
#docker build -t sshd:v2 .
#docker run -d -p 10021:22 sshd:v2
#ssh 192.168.1.85 -p 10021 -v     





