#!/usr/bin/perl
use warnings;
use strict;

my @arr = <STDIN>;
@arr = split(/[^a-zA-Z]+/, join(' ',@arr));
my $count = scalar @arr;
print "$count words\n";
