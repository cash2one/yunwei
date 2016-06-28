import re


url=["www.baidu.com","www.a.pgb",'www.b.rar','www.png.com','www.c.bmp','www.hello.jpeg']

#.*(\.zip|\.rar|\.tar|\.gz|\.bz2)$

reurl=r"www\..*(\.png|\.jpg|\.ico|\.jpeg|\.bmp)$"
regex=re.compile(reurl)
for u in url:
    #print u
    if regex.findall(u):
    #if regex.search(u):
        print u



