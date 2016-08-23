#!/bin/sh
#assuming all arguments are images


for f in $@ ; do
  if [ -f "$f" ] ; then
    display "$f"
    echo -n "Address to e-mail this image to? "
    read recipient
    echo -n "Message to accompany image? "
    read mes

    mutt -s "$mes" -a "$f" -- "$recipient"
  fi
done
