#!/usr/bin/perl
use warnings;
my $pods = 0;
my $count = 0;
my @arr = [];
while(<STDIN>) {
  chomp;
  @arr = split(/ /,$_,2);
  if ( $arr[1] eq  $ARGV[0] ) {
    $pods = $pods + 1;
    $count = $count + $arr[0];
  }
}
print "$ARGV[0] observations: $pods pods, $count individuals\n";
