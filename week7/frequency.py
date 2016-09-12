#!/usr/bin/python3

import sys, re, glob

freq = {}
word = sys.argv[1].lower()
for fil in sorted(glob.glob("poems/*.txt")) :
    artist = re.sub(r'poems\/([^\.]*).txt',r'\1',fil)
    artist = ' '.join(artist.split('_'))

    F = open(fil,"r")
    arr = list(filter(None, re.split(r'[^a-zA-Z]+',' '.join(F.readlines()))))
    allCount = len(arr)

    count = len(list(filter(lambda x: x == word,list(map(lambda x: x.lower(), arr)))))

    freq[artist] = count / allCount
    print("%4d/%6d = %.9f %s" % (count, allCount, freq[artist], artist) )
    F.close()
