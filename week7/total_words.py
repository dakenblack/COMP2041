#!/usr/bin/python3

import sys
import re

# http://stackoverflow.com/questions/16099694/how-to-remove-empty-string-in-a-list
arr = list(filter(None, re.split(r'[^a-zA-Z]+',' '.join(sys.stdin.readlines()))));
print(len(arr) + " words");
