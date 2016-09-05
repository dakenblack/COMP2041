#!/usr/bin/perl
use warnings;

my @result;

for my $degree (("postgraduate", "undergraduate")) {
  $url = "http://www.handbook.unsw.edu.au/$degree/courses/2015/$ARGV[0].html";
  open F, "wget -q -O- $url|" or die;
  while ($line = <F>) {
    print "$line\n";
  }
}
