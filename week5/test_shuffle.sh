#!/usr/bin/sh
for f in "shuffle.pl" "echon.pl" ; do
  if ! [ -f "$f" ] ; then
    echo " missing File: $f"
    exit 1
  fi
done
req_output=`echo -e "hello\nhello\nhello\nhello\nhello"`
echo -e "with input:\nhello\nhello\nhello\nhello\nhello"
output=`echo -e "hello\nhello\nhello\nhello\nhello" | ./shuffle.pl`

if [ "$output" = "$req_output" ] ; then
  echo "Hurrah"
else
  echo "Boohoo"
fi
