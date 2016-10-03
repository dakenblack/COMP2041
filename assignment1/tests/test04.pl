#!/usr/bin/perl -w

while ($line = <STDIN>) {
    chomp $line;
    $line =~ s/[aeiou]//g;
    print "$line\n";
}
