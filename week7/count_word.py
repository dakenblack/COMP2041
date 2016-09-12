#!/usr/bin/python3

import sys, re

arr = list(filter(None, re.split(r'[^a-zA-Z]+',' '.join(sys.stdin.readlines()))));
word = sys.argv[1].lower()

count = len(list(filter(lambda x: x == word,list(map(lambda x: x.lower(), arr)))))
print (word + " occurred "+str(count)+" times")
