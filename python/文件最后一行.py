import time
fname="test.txt"

start = time.clock()
with open(fname, 'rb') as fh:  
    first = next(fh)  
    offs = -100  
    while True:  
        fh.seek(offs, 2)  
        lines = fh.readlines()  
        if len(lines)>1:  
            last = lines[-1]  
            break  
        offs *= 2  
    #print first  
    print last
end =time.clock()
print 'used:', end - start  # 9s










    