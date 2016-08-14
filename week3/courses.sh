#!/bin/sh

under=`wget -q -O- "http://www.handbook.unsw.edu.au/vbook2016/brCoursesByAtoZ.jsp?StudyLevel=Undergraduate&descr=ALL" \
  | egrep -i "<TD class=\"evenTableCell\"><A href=\"http://www.handbook.unsw.edu.au/undergraduate/courses/2016/([A-Z]{4}[0-9]{4}).html\">([ A-Za-z0-9]*)</A></TD>" \
  | sed -e 's/\s*<TD class=\"evenTableCell\"><A href=\"http:\/\/www\.handbook\.unsw\.edu\.au\/undergraduate\/courses\/2016\/\([A-Z]\{4\}[0-9]\{4\}\)\.html\">\([ A-Za-z0-9]*\)<\/A><\/TD>/\1\ \2/' \
  | egrep "$1" `

post=`wget -q -O- "http://www.handbook.unsw.edu.au/vbook2016/brCoursesByAtoZ.jsp?StudyLevel=Postgraduate&descr=ALL" \
  | egrep -i "<TD class=\"evenTableCell\"><A href=\"http://www.handbook.unsw.edu.au/postgraduate/courses/2016/([A-Z]{4}[0-9]{4}).html\">([ A-Za-z0-9]*)</A></TD>" \
  | sed -e 's/\s*<TD class=\"evenTableCell\"><A href=\"http:\/\/www\.handbook\.unsw\.edu\.au\/postgraduate\/courses\/2016\/\([A-Z]\{4\}[0-9]\{4\}\)\.html\">\([ A-Za-z0-9]*\)<\/A><\/TD>/\1\ \2/' \
  | egrep "$1" `

echo "$under"
echo "$post"
