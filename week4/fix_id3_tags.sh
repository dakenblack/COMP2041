#!/bin/sh
for dir in "$@" ; do

  raw_dir=`echo "$dir" | sed -e 's/\/*$//' | rev | cut -d'/' -f'1' | rev`
  album=`echo "$raw_dir" | cut -d',' -f1`
  year=`echo "$raw_dir" | cut -d',' -f2 | tr -d ' '`
  album="$album"," $year"

  #echo -e "album:$album\t\tyear:$year"

  for f in "$dir"/* ; do
    raw_f=`echo "$f" | rev | cut -d'/' -f'1' | rev`
    track=`echo "$raw_f" | cut -d'-' -f1 | sed -e 's/\ *$//' | sed -e 's/^\ *//'`
    name=`echo "$raw_f" | cut -d'-' -f2 | sed -e 's/\ *$//' | sed -e 's/^\ *//'`
    artist=`echo "$raw_f" | cut -d'-' -f3 | sed -e 's/\ *$//' | sed -e 's/^\ *//' | sed -e 's/\.mp3//'`

    echo -e "album:$album\tyear:$year\ttrack:$track\tartist:$artist\tname:$name"
    id3 -t "$name" -T "$track" -a "$artist" -A "$album" -y "$year" "$f" > /dev/null
  done

done
