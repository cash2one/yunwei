mount -t cifs -o username=lpx,password=lpx //192.168.1.100/admin admin

mount -t cifs -o username=lpx,password=lpx,uid=27,gid=27,rw  //192.168.1.100/yunwei2 h2_admin/

//192.168.1.100/yunwei  /data/yunwei_django     cifs    username=lpx,password=lpx 0 0






/etc/sudoers
developer       ALL=(ALL)       NOPASSWD:ALL