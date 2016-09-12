#!/usr/bin/python3

import sys, re, glob, math

log_prob = {}
word = sys.argv[1].lower()
for fil in sorted(glob.glob("poems/*.txt")) :
    artist = re.sub(r'poems\/([^\.]*).txt',r'\1',fil)
    ' '.join(artist.split('_'))

    F = open(fil,"r")
    arr = list(filter(None, re.split(r'[^a-zA-Z]+',' '.join(F.readlines()))))
    allCount = len(arr)

    count = len(list(filter(lambda x: x == word,list(map(lambda x: x.lower(), arr)))))

    log_prob[artist] = math.log((count+1) / allCount)
    print("log((%d+1)/%6d) = %8.4f %s" % (count, allCount, log_prob[artist], artist) )
    F.close()
