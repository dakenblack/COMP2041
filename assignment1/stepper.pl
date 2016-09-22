#!/bin/perl
# @arg input file
# assumes plpy.pl is in the current directory
# PITFALLS:
#   * cannot display indentations
open F, "<$ARGV[0]" or die;

while(<F>) {
  chomp;
  print "<================>\n";
  print "In : $_ \n";
  s/"/\\"/g;
  s/\$/\\\$/g;
  $op = `echo "$_" | perl plpy.pl`;
  $flag = 1;
  for $line (split (/\n/, $op)) {
    if ($flag) {
      $flag = 0;
      print "Out: ${line}\n"
    } else {
      print "   : ${line}\n"
    }
  }
  if ( $op =~ /^\s*$/) {
    print "Out: \n"
  }
  print "<=======END======>\n\n";
}
