#!/bin/sh
for f in * ; do
  if [[ "$f" =~ ".jpg" ]] ; then
    newF=`echo "$f" | sed -e "s/\.jpg/\.png/"`
	if [ -f "$newF" ] ; then
		echo "$newF already exists"	
	else
		convert "$f" "$newF"
    	rm "$f"
	fi
  fi
done
