#!/bin/sh
for f in * ; do
  if [[ "$f" =~ ".jpg" ]] ; then
    newF=`echo "$f" | sed -e "s/\.jpg/\.png/"`
    convert "$f" "$newF"
    rm "$f"
  fi
done
