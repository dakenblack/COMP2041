#!/usr/bin/python
import sys

# includes file name as well
if ( len(sys.argv) != 3) :
    print('Usage: ./echon.pl <number of lines> <string> at ./echon.pl line 3')
    sys.exit(1);

try:
    num = int(sys.argv[1])
except ValueError:
    print('./echon.py: argument 1 must be a non-negative integer')
    sys.exit(1)

for i in range(num) :
    print(sys.argv[2]);
