#!/bin/bash
# @arg input file
# assumes plpy.pl is in the current directory

suppress=0
args=0
argv=""
for i in "$@" ; do
  if [ "$args" -eq "1" ] ; then
    argv=$i
    args=2
  elif [ $i = "-s" ] ; then
    suppress=1
  elif [ $i = "-a" ] ; then
    args=1
  else
    file=$i
  fi
done\

echo -ne "testing  : $file "
if [ -n "$argv" ] ; then
  echo -ne ", with arg : $argv "
fi
orig=`perl $file -c $argv`
code=`perl plpy.pl $file`
new=`python -c "$code" $argv 2>&1`
dif=`diff <(echo "$orig") <(echo "$new")`

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

if [ -z "$dif" ] ; then
  echo -e "${GREEN}<==============PASSED=============>${NC}"
elif [ "$suppress" -eq "0" ] ; then
  echo -e "${RED}<==============FAILED=============>${NC}"
  divider="<=================================>"
  echo "$divider"
  echo "Converted Code:"
  echo "$code"
  echo "$divider"
  echo "Original Output: "
  echo "$orig"
  echo "$divider"
  echo "New Output:"
  echo "$new"
  echo "$divider"
  echo "Diff:"
  echo "$dif"
else
  echo -e "${RED}<==============FAILED=============>${NC}"
fi
