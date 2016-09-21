#!/usr/bin/perl
# by Jabez Wilson (jabez.wilson0@gmail.com)
#
# NOTE: every if must have a paired else
# TODO
#   * add flag to make it print everything step wise


use strict;
use warnings;

my $debug = 0;

if(scalar @ARGV != 0 and ($ARGV[0] eq "-d" or $ARGV[0] eq "--debug")) {
  $debug = 1;
  shift @ARGV;
}

main();

sub main {
  while(<>){
    my $op;
    chomp;
    s/^\s+//;
    s/[\s\n]+$//;

    if(/^#!\/usr\/bin\/perl/){
      # #!/usr/bin/perl
      $op = translateHashbang();
    } elsif (/^print\s+(.*)/) {
      # any print statement
      $op =  translatePrint();
    } elsif (/^\$\w+/) {
      $op =  translateAssignment($_);
    } else {
      $op = $_;
    }
    if(not $debug) {
      print "$op\n";
    }
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
  while ($str =~ /(\$\w+)/ ) {
    $str = join( "\"+ str(" . translateVar($1) . ") +\"", split(/\Q$1/, $str, 2) );
  }

  return "$str";
}

sub translateVar {
  my ($var) = @_;
  $var =~ s/\$// ;
  return $var;
}

sub translateAssignment {
  my ($line) = @_;
  my ($var, $expr) = split(/=/, $line, 2) ;
  $var =~ s/\$// ;
  $var =~ s/\s+$//;
  return "$var = " . translateExpression($expr) ;
}

sub translateExpression {
  my ($expr) = @_;
  $_ = $expr;
  if(/("[^"]*")/) {
    # string constant
    return translateString($1);
  } elsif (/^(\d+)$/) {
    # numerical constant or unquoted string
    return "$1";
  } else {
    #unimplemented clause for operators
    #convert all variables to their appropriate variable names
    while ($expr =~ /(\$\w+)/ ) {
      $expr = join( translateVar($1) , split(/\Q$1/, $expr, 2) );
    }
    return "$expr";
  }
}
