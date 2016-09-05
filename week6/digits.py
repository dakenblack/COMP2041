#!/usr/bin/python
import sys;
import re;

for line in sys.stdin.read().strip().split('\n') :
    line = re.sub(r'[0-4]','<',line)
    line = re.sub(r'[6-9]','>',line)
    print(line)
