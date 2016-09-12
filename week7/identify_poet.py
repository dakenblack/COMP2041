#!/usr/bin/python

import sys, re, glob, math

debug = False
files = sys.argv[1:]
if(sys.argv[1] == "-d") :
    debug = True
    files = sys.argv[2:]

words = {}
for fil in files :
    F = open(fil,"r")
    arr = list(filter(None, re.split(r'[^a-zA-Z]+',' '.join(F.readlines()))))
    words[fil] = {}
    for word in arr :
        word = word.strip().lower()
        words[fil][word] = words[fil].get(word,1) + 1

log_prob = {}
for fil in sorted(glob.glob("poems/*.txt")) :
    artist = re.sub(r'poems\/([^\.]*).txt',r'\1',fil)
    artist = ' '.join(artist.split('_'))

    F = open(fil,"r")
    arr = list(filter(None, re.split(r'[^a-zA-Z]+',' '.join(F.readlines()))))
    allCount = len(arr)

    log_prob[artist] = {}
    for fil1, d in words.items() :
        for word in d :
            if (word in log_prob[artist]) :
                continue

            count = len(list(filter(lambda x: x == word,list(map(lambda x: x.lower(), arr)))))
            log_prob[artist][word] = math.log((count+1) / allCount)
    F.close()

for fil in sorted(words.keys()) :
    prob = {}
    for artist, d in log_prob.items():
        prob[artist] = 0
        for word in d :
            prob[artist] += ( log_prob[artist][word] * d[word])

    chosen = ''
    sortedKeys = sorted(prob, key=prob.get)
    if(debug) :
        for artist in sortedKeys :
            print ("%s: log_probability of %.1f for %s"% (fil,prob[artist],artist))
    print("%s most resembles the work of %s (log-probability=%.1f)" % (fil,sortedKeys[0], prob[sortedKeys[0]]))
