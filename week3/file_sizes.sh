#!/bin/sh

small=""
med=""
large=""

for f in $( ls | sort ) ; do
  num=$( wc -l < $f )
  if [ $num -lt 10 ]; then
    small="$small $f"
  elif [ $num -lt 100 ]; then
    med="$med $f"
  else
    large="$large $f"
  fi
done

echo "Small files:$small"
echo "Medium-sized files:$med"
echo "Large files:$large"
