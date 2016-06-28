#!/usr/bin/python
# -*- coding: utf-8 -*-
import sys
reload(sys)
sys.setdefaultencoding('utf-8')
import time
#with  用法
#读文件的size
#yield 内容装进,for 循环
#
#既节省了内存也可以有返回
#
#





def read_file(fpath):
	BLOCK_SIZE = 1024
	with open(fpath, 'rb') as f:
		while True:
			block = f.read(BLOCK_SIZE)
			if block:
				yield block
			else:
				return

start = time.clock()
for n in read_file("test.txt"):
	print n
#print read_file("test.txt")
end =time.clock()
print 'used:', end - start  # 6s
exit()
start = time.clock()
# for line in open("test.txt").readlines():
#     print line    #10s
for line in open("test.txt"):   #use file iterators 利用迭代器每次读取下一行
    print line
end =time.clock()
print 'used:', end - start  # 9s









exit()
def fab(max): 
	n, a, b = 0, 0, 1 
	while n < max: 
		yield b 
# print b 
		a, b = b, a + b 
		n = n + 1

for i in fab(5):
	print i