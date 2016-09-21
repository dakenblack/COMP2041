#!/bin/bash
# @arg input file
# assumes plpy.pl is in the current directory

orig=`perl $1`
code=`cat "$1" | perl plpy.pl`
new=`python -c "$code" 2>&1`
dif=`diff <(echo "$orig") <(echo "$new")`


RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

if [ -z "$dif" ] ; then
  echo -e "${GREEN}<=================PASSED================>${NC}"
else
  echo -e "${RED}<=================FAILED================>${NC}"
  divider="<=======================================>"
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
fi
