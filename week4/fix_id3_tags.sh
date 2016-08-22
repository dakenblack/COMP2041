#!/bin/sh
for dir in "$@" ; do
  raw_dir=`echo "$dir" | rev | cut -d'/' -f'1' | rev`
  album=`echo "$raw_dir" | cut -d',' -f1`
  year=`echo "$raw_dir" | cut -d',' -f2 | tr -d ' '`

  #echo -e "album:$album\t\tyear:$year"

  for f in "$dir"/* ; do
    raw_f=`echo "$f" | rev | cut -d'/' -f'1' | rev`
    track=`echo "$raw_f" | cut -d'-' -f1 | sed -e 's/\ *$//' | sed -e 's/^\ *//'`
    name=`echo "$raw_f" | cut -d'-' -f2 | sed -e 's/\ *$//' | sed -e 's/^\ *//'`
    artist=`echo "$raw_f" | cut -d'-' -f3 | sed -e 's/\ *$//' | sed -e 's/^\ *//' | sed -e 's/\.mp3//'`

    id3 -t "$name" -T "$track" -a "$artist" -A "$album" -y "$year" "$f"

  done

done
