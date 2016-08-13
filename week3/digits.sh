#!/bin/sh
echo "$1" | sed -e 's/[0-4]/</g' | sed -e 's/[6-9]/>/g'