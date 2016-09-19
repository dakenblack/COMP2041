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

        s/<td class="data">(.*?)<\/td>/$1/;
        if((! "$_" eq "") && (! exists $hash{$teaching}{"$_"})) {
          $hash{$teaching}{$_} = "";
          printLecture($teaching,$_, $code);
        }
      }
    } else {
      if(/<td class="data"><a href="#([A-Z]\d)-\d{4}">Lecture<\/a><\/td>/){
          $lecFound = 1;
          $teaching = "$1";
      }
    }
  }
}

#@param $teaching teaching period
#@param $text html text
sub printLecture {
  my ($teaching, $text, $course) = @_;
  print "$course: $teaching $1\n";
}
