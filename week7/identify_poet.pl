#!/usr/bin/perl

my $debug = 0;
if ($ARGV[0] eq "-d"){
  $debug = 1;
  shift @ARGV;
}
my %words;
foreach my $file (@ARGV) {
  open(F,"<$file") or die "$0: can't open $file\n";
  my @arr = <F>;
  @arr = split(/[^a-zA-Z]+/, join(' ',@arr));
  @arr = grep { $_ ne '' } @arr;
  foreach my $word (@arr) {
    chomp $word;
    $word = lc $word;
    if(exists $words{"$file"}{"$word"}){
      $words{"$file"}{"$word"} ++;
    } else {
      $words{"$file"}{"$word"} = 1;
    }
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

foreach $file (sort keys %words) {
  my %prob;
  foreach $artist (keys %log_prob) {
    $prob{"$artist"} = 0;
    foreach $word (keys %{ $words{"$file"} }) {
      $prob{"$artist"} += ( $log_prob{"$artist"}{"$word"} * $words{"$file"}{"$word"});
    }
  }

  my $chosen = '';
  foreach my $artist (keys %prob) {
    if($debug == 1) {
      printf "%s: log_probability of %.1f for %s\n", $file, $prob{"$artist"}, $artist ;
    }
    if($chosen eq '') {
      $chosen = $artist;
      next;
    }
    if($prob{"$artist"} > $prob{"$chosen"}) {
      $chosen = $artist;
    }
  }
  printf "%s most resembles the work of %s (log-probability=%.1f)\n", $file, $chosen, $prob{"$chosen"};
}
