#!/bin/bash
#@author:goooood
#694366594@qq.com
#对文件名的截取分析
#

file="/dir1/dir2/dir3/my.file.txt"


"# 左边第一个"
"## 左边 贪婪" 
" * 所有匹配 "

#以第一个点删除左边
echo ${file#*.} 
#输出：file.txt

#以最后一个点删除左边
echo ${file##*.}
#输出：txt

#左边遇到第一个3全部去掉
echo ${file#*3}
#输出：/my.file.txt


#左边开始3结束全部去掉
#file="/dir1/dir2/dir3/my3.file.txt"
echo ${file##*3}
#输出：.file.txt



#拿掉左边所有到/ (贪婪)
echo ${file##*/}
#输出：my.file.txt



"% 右边第一个"
"%% 右边 贪婪"

#拿掉最后一个/及右边
echo ${file%/*}
#输出：/dir1/dir2/dir3

#拿掉第一个点及右边
echo ${file%%.*}
#输出：/dir1/dir2/dir3/my

#拿掉一个/ 及右边的
echo ${file%%/*}
#输出： 空

#例子：拿掉右边的第一个3
#file="/dir1/dir2/dir3/my3.file.txt"
echo ${file%3*}
#输出：/dir1/dir2/dir3/my

#例子：拿掉右边开始遇到3去掉
#file="/dir1/dir2/dir3/my3.file.txt"
echo ${file%%3*}
#输出：/dir1/dir2/dir


#切除右边的.file.txt 
echo ${file%.file.txt}
#等于
echo ${file%%.file.txt}
#输出：/dir1/dir2/dir3/my

#file="/dir1.file.txt/dir2/dir3/my3.file.txt"
#%% 可以贪婪
echo ${file%%.file.txt*}
#输出：/dir1

#file="/dir1.file.txt/dir2/dir3/my3.file.txt"
#% 之匹配在右边第一个
echo ${file%.file.txt*}
#输出：/dir1.file.txt/dir2/dir3/my3