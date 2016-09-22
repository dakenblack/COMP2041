#!/usr/bin/perl
# @arg input file
# assumes plpy.pl is in the current directory

print "testing : $ARGV[0] ";

print "ASASAS\n";
$orig=`perl $ARGV[0]`;
$code=`perl plpy.pl $ARGV[0]`;
$new=`python -c "$code" 2>&1`;
$dif="as";
print "$dif\n";

$RED='\033[0;31m';
$GREEN='\033[0;32m';
$NC='\033[0m' ;
# No Color
if ( $dif eq "" ) {
  print "${GREEN}<==============PASSED=============>${NC}\n";
} else {
  print "${RED}<==============FAILED=============>${NC}\n";
  $divider="<=================================>";
  print "$divider\n";
  print "Converted Code:\n";
  print "\Q$code\n";
  print "$divider\n";
  print "Original Output: \n";
  print "$orig\n";
  print "$divider\n";
  print "New Output:\n";
  print "$new\n";
  print "$divider\n";
  print "Diff:\n";
  print "$dif\n";
}
