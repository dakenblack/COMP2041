#!/bin/sh

while read p ; do
  echo "$p" | sed -e 's/[0-4]/</g' | sed -e 's/[6-9]/>/g'
done
