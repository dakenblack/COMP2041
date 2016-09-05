#!/usr/bin/perl
use warnings;

my %mapPods;
my %mapCount;
while(<STDIN>) {
  chomp;
  @arr = split(/ +/,$_,2);

  $arr[1] = lc $arr[1];
  $arr[1] =~ s/ +$//;
  $arr[1] =~ s/s$//;
  $arr[1] =~ s/ ( +)/ /g;

  $mapPods{"$arr[1]"} = 0 if ! exists $mapPods{"$arr[1]"};
  $mapCount{"$arr[1]"} = 0 if ! exists $mapCount{"$arr[1]"};
  $mapPods{"$arr[1]"} = $mapPods{"$arr[1]"} + 1;
  $mapCount{"$arr[1]"} = $mapCount{"$arr[1]"} + $arr[0];
}

for my $it (sort keys %mapPods) {
  print "$it observations: $mapPods{$it} pods, $mapCount{$it} individuals\n";
}
