#!/usr/bin/perl
use warnings;
use strict;

my @arr = <STDIN>;
@arr = split(/[^a-zA-Z]+/, join(' ',@arr));
#http://www.perlmonks.org/?node_id=124970
@arr = grep { $_ ne '' } @arr;
my $count = scalar @arr;
print "$count words\n";
