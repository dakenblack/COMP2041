#!/usr/bin/perl

use warnings;
use strict;

my %log_prob;
my $word = lc $ARGV[0];
foreach my $file (glob "poems/*.txt") {
  my $artist = $file;
  $artist =~ s/poems\/([^\.]*).txt/$1/;
  $artist = join(' ', split(/_/,$artist));

  open(F,"<$file") or die "$0: can't open $file\n";
  my @arr = <F>;
  @arr = split(/[^a-zA-Z]+/, join(' ',@arr));
  @arr = grep { $_ ne '' } @arr;
  my $allCount = scalar @arr;

  my $count = 0;
  foreach my $elem (@arr) {
    chomp $elem;
    $elem = lc $elem;
    if ( $elem eq $word ) {
      $count ++;
    }
  }

  $log_prob{"$artist"} = log (($count + 1 ) / $allCount);

  printf("log((%d+1)/%6d) = %8.4f %s\n", $count, $allCount, $log_prob{"$artist"}, $artist );

}
