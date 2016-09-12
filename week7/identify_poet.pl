#!/usr/bin/perl

my %words;
foreach my $file (@ARGV) {
  open(F,"<$file") or die "$0: can't open $file\n";
  my @arr = <F>;
  @arr = split(/[^a-zA-Z]+/, join(' ',@arr));
  @arr = grep { $_ ne '' } @arr;
  foreach my $word (@arr) {
    $words{"$file"}{"$word"};
  }
}

foreach my $file (keys %words) {
  print "$file\n";
  foreach my $word (keys %{ $words{"$file"} }) {
    print "$file $word\n";
  }
}
my %wordCount;
foreach my $file (glob "poems/*.txt") {
  my $artist = $file;
  $artist =~ s/poems\/([^\.]*).txt/\1/;
  $artist = join(' ', split(/_/,$artist));

  open(F,"<$file") or die "$0: can't open $file\n";
  my @arr = <F>;
  @arr = split(/[^a-zA-Z]+/, join(' ',@arr));
  @arr = grep { $_ ne '' } @arr;
}
