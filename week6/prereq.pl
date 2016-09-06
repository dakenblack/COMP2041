#!/usr/bin/perl
use warnings;

my @result;

for my $degree (("postgraduate", "undergraduate")) {
  $url = "http://www.handbook.unsw.edu.au/$degree/courses/2015/$ARGV[0].html";
  open F, "wget -q -O- $url|" or die;
  while (my $line = <F>) {
    if ( "$line" =~ /(<p>[Pp]re-?[Rr]equisite[^<]*<\/p>)/) {
      my $tmp = $1;
      while ($tmp =~ /([A-Z]{4}[0-9]{4})/gi) {
        push @result, uc $1 ;
      }
    }
  }
}

for my $elem ( sort @result ) {
  print "$elem\n";
}
