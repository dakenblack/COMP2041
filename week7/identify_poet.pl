#!/usr/bin/perl

my %words;
foreach my $file (@ARGV) {
  open(F,"<$file") or die "$0: can't open $file\n";
  my @arr = <F>;
  @arr = split(/[^a-zA-Z]+/, join(' ',@arr));
  @arr = grep { $_ ne '' } @arr;
  foreach my $word (@arr) {
    $words{"$file"}{"$word"} = '';
  }
}

my %log_prob;
foreach my $file (glob "poems/*.txt") {
  my $artist = $file;
  $artist =~ s/poems\/([^\.]*).txt/\1/;
  $artist = join(' ', split(/_/,$artist));

  open(F,"<$file") or die "$0: can't open $file\n";
  my @arr = <F>;
  @arr = split(/[^a-zA-Z]+/, join(' ',@arr));
  @arr = grep { $_ ne '' } @arr;
  my $allCount = scalar @arr;

  foreach my $file (keys %words) {
    foreach my $word (keys %{ $words{"$file"} }) {

      if( exists $log_prob{"$artist"}{"$word"} ) {
        next;
      }
      my $count = 0;
      foreach my $elem (@arr) {
        chomp $elem;
        $elem = lc $elem;
        if ( $elem eq $word ) {
          $count ++;
        }
      }
      $log_prob{"$artist"}{"$word"} = log (($count + 1 ) / $allCount);
    }
  }
}

foreach $file (keys %words) {
  my %prob;
  foreach $artist (keys %log_prob) {
    $prob{"$artist"} = 0;
    foreach $word (keys %{ $words{"$file"} }) {
      $prob{"$artist"} += $log_prob{"$artist"}{"$word"};
    }
  }
  print "@{[%prob]}";

  # my $chosen = '';
  # foreach my $artist (keys %prob) {
  #   if($chosen eq '') {
  #     $chosen = $artist;
  #     next;
  #   }
  #   if($prob{"$artist"} > $prob{"$chosen"}) {
  #     $chosen = $artist;
  #   }
  # }

  # print "$chosen\n";
}
