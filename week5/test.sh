#!/bin/sh
for i in `seq $2` ; do
  echo $i >> $1
done
