


def Qsort(items):
    Sort(items,0,len(items)-1)

def Sort(items,left,right):
    if left >= right:
        return
    l,r = left,right
    middle = items[left]
    while l < r :
        while items[r] >= middle and l <r:
            r = r -1

        items[l] = items[r]

        while items[l] <= middle and l<r:
            l = l +1

        items[r] = items[l]

    items[l]=middle
    #Sort(items,left,l-1)
    Sort(items,l+1,right)

items=[2,1,3,4,5,7,11,65,33,55,22]

Qsort(items)
print items











