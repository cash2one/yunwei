#!/bin/bash

#添加history格式
cat >> /etc/bashrc << EOF 
export HISTTIMEFORMAT='%F %T  '
EOF
[ $? -ne 0 ] && error "修改bashrc失败"
source /etc/bashrc || error "重新加载bashrc失败"
    



sed -i 's/#PermitUserEnvironment no/PermitUserEnvironment yes/' /etc/ssh/sshd_config
grep "PermitUserEnvironment yes" /etc/ssh/sshd_config
service sshd reload

vim /root/.ssh/authorized_keys

environment="NAME_OF_KEY=litaocheng" ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDfF9MEpqqz7KOcIqFJOmhCz2FRCQlrbFhU8izZ7MEilfveuTboE8mbhUu+eslhk88OM+wCWnvpygbgGwQd6NEviBr6PnT+Vzb9YOFOJnQ+Gc9vDLxQeMgyMdfMaoL5EINK6XuPzA++0vnTApyEd9QkXJYQOkH05XxmAkJGEwj4hN2BFdhFSIwz+QUgEnPpNmj+xFw8u7/PJnd17qOJdbo/XYPXfpL2UsKylzjALMJf4Fa6/Qls9xgmEU+G5Eu2aUQJgjRQ8BsR7zT3BtdpYAkugGWfCLL5Bhl2W921amo4ncslt66DuD6kiiWh5qqoIlu6l7pP7jNE/oQr7+sFIM6p litaocheng@hoye
environment="NAME_OF_KEY=yansheng" ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC0pQg5BHoYjlLcfVmZle0J4voWWtvCbuVmjktQXj+XUiNcUCtwlKAoErok837yySp71sLsHhINyE/weHGqsaSL72OYzXKMGzEb6+IWUxnFQtRvV4eN/Se6ea8zVHCYscqBGvGoOcZHrHpfqwVgIYmSPrWO9csx4qnXEAlPz6wl81GxNpqhpJCOKm6fPyyoXaPB5gXHMJ3yIv6aH69LdNlB9/LajDhd27OXTn4iAUvGQFyA3DF6kulduKvAOTAdMnj2RwaRErqbgQb097jGe+ISQ5P6FnPfnOtL8ZeiuteqUwy48BfzXC74847trXJQWHzMBiOlwaEpEtOe3X4RD1H7 yansheng@Haoyue
environment="NAME_OF_KEY=zhengheng" ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAr/qEjbuewpUBLECfwLwb/znMYPrvBJO7AkOYlDdI2wPtF38GBvNE7XK4nCS8BT5B3kdoYxExu53e1+GKDXzgNA+iOry+/Tzv95bn8kFKLCK+Z5pyjQDkhOItkaJrxYM7kt1HNk55D2k1QFd5BGjgt2r3RUhnxfqhFARRDH6C7N9I4MVmJI0Fh82ihlAwI1BVacm6nsR1626kBwo7Ds/D6ZbnQSwpbJhmhRovmnwUYEbdZVnZBpHfUk9XT/VHCVkwP21CbkYhPGL5B4zL8ge75/Jpw5ziJGuboV0fdPGjHcY2r/7I8051lMUSozeyhBYCdjjlpTXEXiRjWfxL0TPkWw== zhengheng@heng
environment="NAME_OF_KEY=linwu@w" ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBmJuMG1JgFH3UFAl04SoO2nF5cgljG+KbtO0270D/cZSTNyECBWLo5qUIv8K77OjRJftsKVMAdweldnPq/5e14g12preiTHSB4jrf+BapLIs2GyNqlbZ6xSRv12pOrthdE6XRYAGaF253RWR6y93kI933JOH/MXytKnqGfeZujK2G4lYRVjn3q7MELEBLsy0faarIxVRs582D++XYaaEqeQEyNC7X9m28WSUApY+oAi3JzZt9noPsPELsYaAkyYUBpdt/ubQlmdVjI3ZW4em2YfDkE6/GHZQgiG3NFe5spBabzxTXHXI6HqJFSrlbXhHTTydO3qWbtS/0WBHoqh0t linwu@windows
environment="NAME_OF_KEY=chenyansheng" ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCmY5CiAS1HiEZGIkxlCLxxw3RcASDx+ckmD9t5A6QvFpsJyI4F9Act+qxmXHQiQI8FU0SrGOuyd4mERECTHXkfOW2uuza6nIl9qgVtCGZQavNPZ2C96UYUBxGguEBxeZB17gEH9BlY3e1M+6eCjCL9G2nIKhvsxIgElztRoPN90RlvZX+GZN8HSMUbbEAP4oh+gV1bjYbCTS5C1J+T/HkD5jDQZMTM3JVw5LSTAn6wg4S/ryPcCKvPOK5RBv1N47s9JoniERj2oMBoF0SZPz89RKAmnan+doG5qZBQsNu6iov3SDp8xyz2dbKmjI5WIGW3Ixo2/LNi2kX4lnm++JSz chenyansheng
environment="NAME_OF_KEY=copy@litao" ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAqZ+S0p+97mZfwkM1ldaAzKSill/btND95A1YdjUHrdsBt6oehyO9rF+NEke2rsa6ifAby6XuqS5bUrF+o/MsyvTyiiTHqoUbTRRK5ISBVQao8gcdKVt+re1j0zJ2mSsaJX0uT5YdfkgKXfRekA/7yEXG5kXtTPLj7tRSghhl54qaoxHeapTQiv1p5jwwPsKqKAdovF1k2MIdjM6bPs4z4E3hCzzZ/icLy4OOM2iYoe++9MEY5/Z8aFY6gWWjWFrNB5BC582NAMza2dieFqjdDlfCsFe6TRuklArHGlb+g5Ez50ipLKxkOQkAcwNH+Xsppy6FbgaMh0ShQkmqPEx0rw== copy@litao
environment="NAME_OF_KEY=linwu@u" ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAw67UkRskwd0ycmIwaLdeBiGFyO36Kt8qfd0CtGpYWGnBmUi90bGU6V0GPWHcLG1rldFOZ8IiEkX4oewt88agskhtfK0DRYfUA59KyUa63ZQ0wwAGHqWJsDAjXbtgFjBxYDVCrqEYm3vF5LRJSPI+/O81PTzpyPe6nXFymby2EimTl5K56ucvpPQQniH5Px6YrElOZYV5BCdf5No97eisBWnTwZ6kA26rrvTP8cETCBCcbkFQ5SS+/UpdSTwjQ+yrC1sWFbCRTUXWeKL0R2Jd9qkONRtTzCrN1/ZfCGwIT23ffPhQJwoYtWVawoN0SLlfMyPiFd/mGPs3/d0KFugL+w== linwu@ubuntu
environment="NAME_OF_KEY=lupuxiao" ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQC4dnbSUB9eCBDUDHiQgoQDvD/U53boERbXdAVcs46e+mXzALkjYlXZGsp3jM3ZlRXezLdy2ZzK/bJh459hA36XA6bKaXrhElhypPIiKb3OGMvKv2HpQo/tE6oow2KoTGl8uysSunAa3dri1X2VpwemaVGoCAvvjVjnacufvFcYqw== lupuxiao



vim /etc/profile

############################添加history分离##############################

if [ ! -d /var/log/history-log/ ];then
        sudo /bin/mkdir -p /var/log/history-log/
        sudo /bin/chmod 777 /var/log/history-log/
fi

shopt -s histappend
history -a

if [ -n "$NAME_OF_KEY" ];then
        if [ ! -f /var/log/history-log/$NAME_OF_KEY ];then
                sudo touch /var/log/history-log/$NAME_OF_KEY
        fi

        export HISTFILE="/var/log/history-log/$NAME_OF_KEY"
fi

export PROMPT_COMMAND='history -a;history -w'




source /etc/profile


rz whois_history.sh
