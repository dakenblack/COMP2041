#!/bin/bash
# @arg input file
# assumes plpy.pl is in the current directory

orig=`perl $1`
code=`cat "$1" | perl plpy.pl`
new=`python -c "$code"`
dif=`diff <(echo "$orig") <(echo "$new")`
echo "Converted Code:"
echo "$code"
echo "<============================>"
echo "Original Output: "
echo "$orig"
echo "<============================>"
echo "New Output:"
echo "$new"
echo "<============================>"
echo "Diff:"
echo "$dif"
