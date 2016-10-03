#!/usr/bin/perl -w

$even = 0;
$odd = 0;
$zeros = 0;
$ones = 0;

while ($line = <STDIN>) {
  if($line == 0) {
    $zeros = $zeros + 1;
  } elsif ($line == 1) {
    $ones ++;
    $ones --;
    $ones ++;
    $ones -= 1;
    $ones += 1;
  } else {
    if($line % 2 == 0) {
      $even ++;
    } else {
      $odd += 1;
    }
  }
}
print "Num of even : $even\n";
print "Num of odd  : $odd\n";
print "num of 0s   : $zeros\n";
print "num of 1s   : $ones\n";
