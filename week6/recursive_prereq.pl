#!/usr/bin/perl
use warnings;

if( $ARGV[0] ne "-r" ) {
  my $out = `perl prereq.pl $ARGV[0]`;
  print("$out");
  exit 0;
}

my @queue;
my %results;
push @queue, $ARGV[1];
my @arr;
while ( scalar(@queue) != 0 ) {
  @arr = split("\n", `perl prereq.pl $queue[0]` );
  shift(@queue);
  for my $course ( @arr ) {
    chomp $course;
    if(not exists $results{$course}) {
      $results{$course} = "prereq";
      push @queue, $course
    }
  }
}

for my $prereq ( sort keys %results ) {
  print("$prereq\n");
}
