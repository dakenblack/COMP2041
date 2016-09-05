#!/usr/bin/python
import sys

pods = 0
count = 0

for line in sys.stdin.read().strip().split('\n') :
    arr = line.strip().split(' ', 2)
    if(arr[1] == sys.argv[1]) :
        pods += 1
        count += int(arr[0])

print( "%s observations: %d pods, %d individuals\n" % (sys.argv[1], pods, count))
