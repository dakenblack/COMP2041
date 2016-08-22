text=`date | cut -d' ' -f2,3,4 | cut -d':' -f1,2 | sed -e 's/\([0-9]*\)\ \([a-zA-Z]*\)/\2\ \1/'`
convert -gravity south -pointsize 36 -draw "text 0,10 '$text'" "$1" temporary_file.jpg
mv temporary_file.jpg "$1"
