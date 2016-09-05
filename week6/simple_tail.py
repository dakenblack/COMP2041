#!/usr/bin/python

import sys
for filename in sys.argv[1:] :
    fileObject = open(filename,"r")
    count = 0
    arr = []
    for line in reversed(fileObject.readlines()) :
        if count >= 10 :
            break
        count+= 1
        arr.append(line.strip())

    #has to be reversed again for reasons
    for line in reversed(arr) :
        print(line)
    fileObject.close()
