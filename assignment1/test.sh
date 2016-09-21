#!/bin/bash
# @arg input file
# assumes plpy.pl is in the current directory

orig=`perl $1`
code=`cat "$1" | perl plpy.pl`
new=`python -c "$code"`
dif=`diff <(echo "$orig") <(echo "$new")`
divider="<=======================================>"
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
