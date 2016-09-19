#!/usr/bin/perl

use strict;
use warnings;

my $tuple = 0;
my %hash;
if ($ARGV[0] eq "-d") {
  shift @ARGV;
  $tuple = 1;
}

for my $course (@ARGV) {
  printCourse($course);
}

#@param $code course code
sub printCourse {
  my ($code) = @_;
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
#@param $course course code
sub printLecture {
  my ($teaching, $text, $course) = @_;
  if (! $tuple) {
    print "$course: $teaching $1\n";
  } else {
    my %hash;
    for my $el (split /\(.*?\), ?/,$text) {
      $el =~ s/\(.*?\)//;
      my @arr = split /[ \-:]+/, $el;
      @arr = grep !/00/, @arr;
      my @days;
      my @hours;
      for my $ele (@arr) {
          $ele =~ s/(\w+)[, ]*/$1/;
          if ($ele =~ /[^\d]+/) {
            push @days, "$ele";
          } else {
            push @hours, "$ele";
          }
      }

      for my $day (@days) {
        for my $hour ($hours[0] .. ($hours[1] - 1)) {
          if(! exists $hash{"$day"}{"$hour"}){
            $hash{"$day"}{"$hour"} = "";
            print "$teaching $course $day $hour\n"
          }
        }
      }
    }
  }
}
