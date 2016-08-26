#!/usr/bin/perl
#http://stackoverflow.com/questions/13416337/what-s-the-best-way-to-shuffle-an-array-in-perl
#
use warnings;
use List::Util qw/shuffle/;
print shuffle <STDIN>;
