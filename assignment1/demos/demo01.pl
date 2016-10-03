#!/usr/bin/perl

$arg = $ARGV[0];
$second = $ARGV[1];

if($arg eq "bye") {
  print "good bye\n";
} elsif ($arg eq "hello"){
  print "Hello there..\n";
} else {
  print "I'm sorry I don't understand\n";
}

if($second < 0) {
  print "your second argument is negative\n";
}

$square = $second ** 2;
$double = $second * 2;
$half = $second / 2;

print "the square is $square\n";
print "the double is $double\n";
print "the half is $half\n";
