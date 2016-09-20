#!/usr/bin/perl

use strict;
use warnings;

my $tuple = 0;
my $table = 0;
my %hashTable;
if ($ARGV[0] eq "-d") {
  shift @ARGV;
  $tuple = 1;
}

if ($ARGV[0] eq "-t") {
  shift @ARGV;
  $tuple = 1;
  $table = 1;
}

for my $course (@ARGV) {
  fillHash($course);
}
printHash() if ($table);

#@param $code course code
sub fillHash {
  my ($code) = @_;
  open F, "wget -q -O- \"http://timetable.unsw.edu.au/2016/" . "$code" . ".html\" |" or die;
  my $lecFound = 0;
  my $count = 0;
  my $teaching = "";
  my %hash;
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
            print "$teaching $course $day $hour\n" if (! $table);
            $hashTable{"$teaching"}{"$hour"}{"$day"} = 0 if (! exists $hashTable{"$teaching"}{"$hour"}{"$day"});
            $hashTable{"$teaching"}{"$hour"}{"$day"} ++;
          }
        }
      }
    }
  }
}

sub printHash {

  my %hourMap = (
    "9" => "09:00",
    "10" => "10:00",
    "11" => "11:00",
    "12" => "12:00",
    "13" => "13:00",
    "14" => "14:00",
    "15" => "15:00",
    "16" => "16:00",
    "17" => "17:00",
    "18" => "18:00",
    "19" => "19:00",
    "20" => "20:00"
  );

  for my $t (keys %hashTable) {
    print "$t       Mon   Tue   Wed   Thu   Fri\n";
    for my $h ( 9 .. 20 ) {
      print "$hourMap{$h}    ";
      for my $d ("Mon", "Tue", "Wed", "Thu", "Fri") {
        if (! exists $hashTable{$t}{$h}{$d} ) {
          print "   ";
        } else {
          print " $hashTable{$t}{$h}{$d} ";
        }
        print "   ";
      }
      print "\n";
    }
  }
}
