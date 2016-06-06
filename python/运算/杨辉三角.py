


#################    方法  1  #################
def triangle(n):
    L=[1]
    while True:
        yield(L)
        L.append(0)
        L=[L[i]+L[i-1] for i in range(len(L))]
        if len(L)>n:
            break
    #return "done"


g=triangle(11)
for i in g:
    print(i)



#################    方法  2  #################

def triangles():
    b = [1]
    while True:
        yield b
        b = [1] + [b[i] + b[i+1] for i in range(len(b)-1)] + [1]    

n = 0
for t in triangles():
    print(t)
    n = n + 1
    if n == 5:
        break

