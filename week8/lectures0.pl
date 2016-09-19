#!/usr/bin/perl

use strict;
use warnings;

for my $course (@ARGV) {
  printCourse($course);
}

#@param $code course code
sub printCourse {
  my ($code) = @_;
  my %hash;
  open F, "wget -q -O- \"http://timetable.unsw.edu.au/2016/" . "$code" . ".html\" |" or die;
  my $lecFound = 0;
  my $count = 0;
  my $teaching = "";
  while(<F>) {
    chomp;
    s/^\s+//;
    if($lecFound) {
      $count ++;
      if($count == 6) {
        $count = 0;
        $lecFound = 0;
        printLecture($teaching,$_, $code);
      }
    } else {
      if(/<td class="data"><a href="#([A-Z]\d)-\d{4}">Lecture<\/a><\/td>/){
        if (! exists $hash{$1}{"$_"}) {
          $lecFound = 1;
          $teaching = "$1";
          $hash{$1}{"$_"} = "";
        }
      }
    }
  }
}

#@param $teaching teaching period
#@param $text html text
sub printLecture {
  my ($teaching, $text, $course) = @_;
  $text =~ s/<td class="data">(.*?)<\/td>//;
  print "$course: $teaching $1\n" if (! ($1 eq "") )
}
