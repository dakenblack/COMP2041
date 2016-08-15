#!/bin/sh

post=`wget -q -O- "http://www.handbook.unsw.edu.au/vbook2016/brCoursesByAtoZ.jsp?StudyLevel=Postgraduate&descr=ALL"  \
  | grep "$1" \
  | egrep -i '^\s*<TD class="[a-z0-9]*"><A href="http://www\.handbook\.unsw\.edu\.au/postgraduate/courses/2016/([A-Z]{4}[0-9]{4})\.html">([ A-Za-z0-9-]*)</A></TD>$' \
  | sed -e 's/\s*<TD class=\"[a-zA-Z0-9]*\"><A href=\"http:\/\/www\.handbook\.unsw\.edu\.au\/postgraduate\/courses\/2016\/\([A-Z]\{4\}[0-9]\{4\}\)\.html\">\([ A-Za-z0-9-]*\)<\/A><\/TD>/\1 \2/' `

under=`wget -q -O- "http://www.handbook.unsw.edu.au/vbook2016/brCoursesByAtoZ.jsp?StudyLevel=Undergraduate&descr=ALL"  \
  | grep "$1" \
  | egrep -i '^\s*<TD class="[a-z0-9]*"><A href="http://www\.handbook\.unsw\.edu\.au/undergraduate/courses/2016/([A-Z]{4}[0-9]{4})\.html">([ A-Za-z0-9-]*)</A></TD>$' \
  | sed -e 's/\s*<TD class=\"[a-zA-Z0-9]*\"><A href=\"http:\/\/www\.handbook\.unsw\.edu\.au\/undergraduate\/courses\/2016\/\([A-Z]\{4\}[0-9]\{4\}\)\.html\">\([ A-Za-z0-9-]*\)<\/A><\/TD>/\1 \2/' `

echo -e "$under\n$post" | sort | uniq
