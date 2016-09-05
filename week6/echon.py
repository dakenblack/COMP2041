#!/usr/bin/python
import sys

# includes file name as well
if ( len(sys.argv) != 3) :
    print('Usage: ./echon.pl <number of lines> <string> at ./echon.pl line 3')
    sys.exit(1);

for i in range(int(sys.argv[1])) :
    print(sys.argv[2]);
