#!/usr/bin/perl

$num = $ARGV[0];
if($num < 24 and $num > 14) {
  print "check 1\n";
} elsif ($num >= 24 || $num < 0) {
  print "check 2\n";
}

if($num < 24 && $num > 14) {
  print "check 3\n";
} elsif ($num >= 24 or $num < 0) {
  print "check 4\n";
}

if ($num <=> 13) {
  print "derp\n";
}

if ($num == 22) {
  exit;
}
