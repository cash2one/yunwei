#!/usr/bin/python
#-*- coding: utf-8 -*-
import time


##################  与下面效果一样  #######################

def d(fp):
    def _d(*arg, **karg):
        print "do sth before fp.."
        #r = fp(*arg, **karg)   #替代
        fp(*arg, **karg)
        print "do sth after fp.."
        #return r               #替代
    return _d

@d
def f():
    print "call f"
#上面使用@d来表示装饰器和下面是一个意思
#f = d(f)


f()#调用f




exit()









#================================================================================================
def f():
    def d(fp):
        def _d(*arg, **karg):
            print "do sth before fp.."
            #r = fp(*arg, **karg)   #替代
            fp(*arg, **karg)
            print arg
            print "do sth after fp.."
            #return r               #替代
        return _d
    return  d

@f()
def f():
    print "call f"
#上面使用@d来表示装饰器和下面是一个意思
#f = d(f)


f()#调用f















exit()

##################  与下面效果一样  #######################

def d(fp):
    def _d(*arg, **karg):
        print "do sth before fp.."
        #r = fp(*arg, **karg)   #替代
        fp(*arg, **karg)
        print "do sth after fp.."
        #return r               #替代
    return _d

@d
def f():
    print "call f"
#上面使用@d来表示装饰器和下面是一个意思
#f = d(f)


f()#调用f




exit()

















########################################第一种方式###################################################
# 定义一个计时器，传入一个，并返回另一个附加了计时功能的方法
def timeit(func):
     
    # 定义一个内嵌的包装函数，给传入的函数加上计时功能的包装
    def wrapper():
        start = time.clock()
        func()
        end =time.clock()
        print 'used:', end - start
     
    # 将包装后的函数返回
    # 必须有返回
    return wrapper

@timeit 
def foo():
    print 'in foo()' 
#foo = timeit(foo)
foo()

#########################################第二种方式#################################################


# 定义一个计时器，传入一个，并返回另一个附加了计时功能的方法
def timeit():
    def d(func):
    # 定义一个内嵌的包装函数，给传入的函数加上计时功能的包装
        def wrapper(*args,**kwargs):
            start = time.clock()
            func()
            end =time.clock()
            print 'used:', end - start

        # 将包装后的函数返回
        # 必须有返回
        return wrapper
    return d

@timeit()
def foo():
    print 'in foo()'
#foo = timeit(foo)
foo()


##########################################################################################




exit()

def deco(func):
    print("before myfunc() called.")
    func()
    print("after myfunc() called.")
    # 必须有返回
    return func  

@deco 
def myfunc():
    print(" myfunc() called.")
 
#myfunc = deco(myfunc)
 
myfunc()

exit()