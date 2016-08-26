#!/usr/bin/perl

if( scalar(@ARGV) != 2) {
  print "Usage: ./echon.pl <number of lines> <string> at ./echon.pl line 3";
  exit 1;
}

for ( $i=0; $i < $ARGV[0]; $i++) {
  print "$ARGV[1]\n";
}
