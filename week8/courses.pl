#!/usr/bin/perl
my $code = $ARGV[0];
open F, "wget -q -O- \"http://timetable.unsw.edu.au/2016/$ARGV[0]KENS.html\" |" or die;
while(<F>) {
  chomp;
  print("$1\n") if (/<td class="data"><a href="($code[0-9]{4})\.html">\1<\/a><\/td>/) ;
}
