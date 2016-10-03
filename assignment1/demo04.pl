#!/usr/bin/perl
$var = <STDIN>;
chomp $var;
$var =~ s/[01234]/</g;
$var =~ s/[6789]/>/g;
print "$var\n";

$something = <STDIN>;
chomp $something;
$var = "$var $something";
$var = $var . "THE END";
if($var =~ /[Tt]est/) {
  print "Tested: <$var>\n";
} else {
  print "Not tested..!";
}
