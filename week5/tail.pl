#!/usr/bin/perl
use warnings;

my $N = 10;
my @files = ();
foreach $arg (@ARGV) {
    if ($arg =~ /-[0-9]+/) {
      $arg =~ s/-//;
      $N = $arg;
    }

    else {
        push @files, $arg;
    }
}

if( scalar(@files) eq 0) {
  push @files, "-";
}

foreach $f (@files) {
    if( scalar(@files) > 1) {
      print "==> $f <==\n";
    }
    open(F,"<$f") or die "$0: can't open $f\n";
    @arr = ();
    while(<F>) {
      push @arr, $_ ;
    }
    for ($count = 0; $count < $N; $count ++) {
      my $len = scalar (@arr);
      print $arr[ $len - $N + $count ];
    }
    close(F);
}
