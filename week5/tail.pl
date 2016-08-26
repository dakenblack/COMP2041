#!/usr/bin/perl
$N = 10;
@files = ();
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
    open(F,"<$f") or die "$0: can't open $f\n";
    $count = 0;
    while(<F>) {
      if ($count == $N) {
        last;
      }
      print $_;
      $count ++;
    }
    close(F);
}
