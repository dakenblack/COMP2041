#!/bin/sh
#date of a file
#http://askubuntu.com/questions/62492/how-can-i-change-the-date-modified-created-of-a-file

text=`date | cut -d' ' -f2,3,4 | cut -d':' -f1,2 | sed -e 's/\([0-9]*\)\ \([a-zA-Z]*\)/\2\ \1/'`
mTime=`date -R -r "$1"`
convert -gravity south -pointsize 36 -draw "text 0,10 '$text'" "$1" temporary_file.jpg
mv temporary_file.jpg "$1"

touch -d "$mTime" "$1"
