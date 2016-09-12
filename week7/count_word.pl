#!/usr/bin/perl

use warnings;
use strict;

my $word = lc $ARGV[0];
my @arr = <STDIN>;
@arr = split(/[^a-zA-Z]+/, join(' ',@arr));

my $count = 0;
foreach my $elem (@arr) {
  chomp $elem;
  $elem = lc $elem;
  if ( $elem eq $word ) {
    $count ++;
  }
}

print "$ARGV[0] occured $count times\n";
