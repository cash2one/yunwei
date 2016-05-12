




1:No route to host  //防火墙问题

telnet: connect to address 192.168.1.60: No route to host



2:Connection refused   //端口未开

telnet: connect to address 203.151.82.215: Connection refused



结论：说明No route to host是防火墙的返回，先经过防火墙，不管端口有没有。
      然后如果通过了防火墙，但监听未启动，则提示Connection refused的错误






iptables -I INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT
iptables -I INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT
iptables -I INPUT -p tcp -m state --state NEW -m tcp --dport 443 -j ACCEPT
iptables -I INPUT -p tcp -m state --state NEW -m tcp --dport 10000:29999 -j ACCEPT
iptables -I INPUT -s ${network/%,/} -p tcp -m state --state NEW -m tcp --dport 5001:5004 -j ACCEPT



iptables -I INPUT -s 58.248.139.12 -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT
iptables -I INPUT -s 203.162.76.151 -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT




iptables -I INPUT -p tcp -m state --state NEW -m tcp --dport 9100:9900 -j ACCEPT
iptables -I INPUT -s 113.196.57.219/32 -p tcp -m state --state NEW -m tcp --dport 8300:8900 -j ACCEPT
service iptables save
















4t 5l
4张表5条链

表：
filter:定于允许或者不允许
nat:定义地址转换
mangle:修改报文原数据
raw: 数据跟踪处理 //或者4张表



链：
prerouting
INPUT
OUTPUT
FORWARD
POSTROUTING


4种状态
NEW
ESTABLISHED
RELATED
invalid

进来的只允许状态为NEW和ESTABLISHED的进来，出去只允许ESTABLISHED的状态出去，这就可以将比较常见的反弹式木马有很好的控制机制。



















*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
##########################################################################################################################
-A INPUT -s 203.151.82.217/32 -p tcp -m state --state NEW -m tcp --dport 8501:8599 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 9501:9599 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
##########################################################################################################################
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT



*filter
:INPUT DROP [637:170375]
:FORWARD ACCEPT [0:0]
:OUTPUT DROP [4:288]
-A INPUT -s 219.237.193.145/26 -p tcp -m tcp --dport 22 -j ACCEPT
-A OUTPUT -d 219.237.193.145/26 -p tcp -m tcp --sport 22 -j ACCEPT
-A INPUT -s 58.248.139.12 -p tcp -m tcp --dport 22 -j ACCEPT
-A OUTPUT -d 58.248.139.12 -p tcp -m tcp --sport 22 -j ACCEPT
-A INPUT -s 121.201.11.19 -p tcp --dport 22 -j ACCEPT
-A OUTPUT -d 121.201.11.19 -p tcp --sport 22 -j ACCEPT
-A INPUT -s 10.0.0.0/8 -i eth0 -p tcp -j ACCEPT
-A OUTPUT -d 10.0.0.0/8 -o eth0 -p tcp -j ACCEPT
-A INPUT -s 219.237.193.145/26 -p icmp --icmp-type echo-request -j ACCEPT
-A OUTPUT -d 219.237.193.145/26 -p icmp --icmp-type echo-reply -j  ACCEPT
-A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT
-A INPUT -p icmp --icmp-type echo-reply -j ACCEPT
-A OUTPUT -p tcp -m multiport --dport 53,80,443 -j ACCEPT
-A INPUT -p tcp -m  multiport --sport 53,80,443 -j ACCEPT
-A OUTPUT -p udp -m udp  -m state --state NEW,ESTABLISHED -j ACCEPT
-A INPUT -p udp -m udp  -m state --state ESTABLISHED -j ACCEPT
-A INPUT  -p tcp -m tcp -i lo -j ACCEPT
-A OUTPUT -p tcp -m tcp -o lo -j ACCEPT
-A INPUT -s 119.161.240.233 -p tcp -m multiport --dport 10050,10051 -j ACCEPT
-A OUTPUT -d 119.161.240.233 -p tcp -m multiport --sport 10050,10051 -j ACCEPT
-A OUTPUT  -p tcp -m state --state NEW,ESTABLISHED  --dport 3306 -j ACCEPT
-A INPUT  -p tcp -m state --state ESTABLISHED  --sport 3306 -j ACCEPT
-A OUTPUT -p tcp -m multiport --sport 20,21,80,873 -j ACCEPT
-A INPUT -p tcp -m  multiport --dport 20,21,80,873 -j ACCEPT
-A OUTPUT -p tcp -m multiport --sport 5000:5005 -j ACCEPT
-A INPUT -p tcp -m  multiport --dport 5000:5005 -j ACCEPT
-A INPUT  -p tcp -m tcp -m state --state ESTABLISHED -j ACCEPT
-A OUTPUT -p tcp -m tcp -m state --state ESTABLISHED -j ACCEPT
COMMIT
























//魔王与公主 设置
# Firewall configuration written by system-config-firewall
# Manual customization of this file is not recommended.
*filter
:INPUT DROP [637:170375]
:FORWARD ACCEPT [0:0]
:OUTPUT DROP [4:288]
-A INPUT -i lo -j ACCEPT
-A OUTPUT -o lo -j ACCEPT
-A INPUT -s 219.237.193.145 -p tcp -m tcp --dport 22 -j ACCEPT
-A OUTPUT -d 219.237.193.145 -p tcp -m tcp --sport 22 -j ACCEPT
-A INPUT -s 58.248.139.12 -p tcp -m tcp --dport 22 -j ACCEPT
-A OUTPUT -d 58.248.139.12 -p tcp -m tcp --sport 22 -j ACCEPT
-A INPUT -s 219.237.193.145 -p icmp --icmp-type echo-request -j ACCEPT
-A OUTPUT -d 219.237.193.145 -p icmp --icmp-type echo-reply -j  ACCEPT
-A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT
-A INPUT -p icmp --icmp-type echo-reply -j ACCEPT
-A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
-A OUTPUT -p tcp -m tcp --sport 80 -j ACCEPT
-A OUTPUT -p tcp -m tcp --dport 80 -j ACCEPT
-A INPUT -p tcp -m  tcp --sport 80 -j ACCEPT
-A OUTPUT -p tcp -m tcp --dport 53 -j ACCEPT
-A OUTPUT -p udp -m udp --dport 53 -j ACCEPT
-A INPUT -p tcp -m  tcp --sport 53 -j ACCEPT
-A INPUT -p udp -m  udp --sport 53 -j ACCEPT
-A OUTPUT -p tcp -m tcp --dport 443 -j ACCEPT
-A INPUT -p tcp -m tcp --sport 443 -j ACCEPT
-A OUTPUT -p udp -m udp  -m state --state NEW,ESTABLISHED -j ACCEPT
-A INPUT -p udp -m udp  -m state --state ESTABLISHED -j ACCEPT
-A INPUT -s 10.254.0.0/16 -p tcp -m tcp -j ACCEPT
-A OUTPUT -d 10.254.0.0/16 -p tcp -m tcp -j ACCEPT
-A INPUT -s 120.26.1.162 -p tcp -m multiport --dport 10050,10051 -j ACCEPT
-A OUTPUT -d 120.26.1.162 -p tcp -m multiport --sport 10050,10051 -j ACCEPT
COMMIT






