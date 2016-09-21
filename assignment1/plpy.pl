#!/usr/bin/perl
# by Jabez Wilson (jabez.wilson0@gmail.com)

use strict;
use warnings;

main();

sub main {
  while(<STDIN>){
    my $op;
    chomp;
    s/^\s+//;

    if(/^#!\/usr\/bin\/perl/){
      $op = translateHashbang();
    } elsif (/^print\s+(.*)/) {
      $op =  translatePrint();
    } else {
      $op = $_;
    }
    print "$op\n";
  }
}


sub translateHashbang {
  return "#!/usr/bin/python3 -u";
}

sub translatePrint {
  my ($line) = @_;
  /^print\s+(.*)/;
  if($1 =~ /("[^"]*")/) {
    return "print(" . translateString($1) . ",end=\"\")";
  } else {
    return $_;
  }
}

sub translateString {
  my ($str) = @_;
  return "$str";
}
