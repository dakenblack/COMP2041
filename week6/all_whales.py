#!/usr/bin/python
import sys
import re

mapPods = {}
mapCount = {}
for line in sys.stdin.read().strip().split('\n') :
    line = line.strip()
    line = re.sub(r'  +',' ',line)
    arr = line.strip().split(' ', 1)

    arr[1] = arr[1].lower()
    arr[1] = re.sub(r' +$','',arr[1])
    arr[1] = re.sub(r's$','',arr[1])
    arr[1] = re.sub(r'  +',' ',arr[1])

    if( not arr[1] in mapPods):
        mapPods[arr[1]] = 0
    if( not arr[1] in mapCount):
        mapCount[arr[1]] = 0

    mapPods[arr[1]] += 1
    mapCount[arr[1]] += int(arr[0])

for it in sorted(mapPods.keys()) :
    print("%s observations: %d pods, %d individuals" % (it,mapPods[it], mapCount[it]))
