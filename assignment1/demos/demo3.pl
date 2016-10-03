#!/usr/bin/perl
$count = 0;
while($line = <STDIN>) {
  chomp $line;
  if($line == 0) {
    continue;
  }
  print "not zero..\n";
  if($line > 100) {
    print "too large, breaking\n";
    last;
  }
  if($line < -100) {
    print "too small, exiting\n";
    exit;
  }
  print "Just right\n";
  $count += 1;
}
print "Exiting with no errors..\n";
print "count was $count\n";
