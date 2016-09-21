#!/usr/bin/perl
# by Jabez Wilson (jabez.wilson0@gmail.com)
#
# NOTE: every if must have a paired else
# PITFALLS:
#   * strings with more than one variable eg "$foo $bar" will not work
# TODO
#   * add flag to make it print everything step wise
#   * remove the variable table and change the way strings are converted to always call str() on that variable


use strict;
use warnings;

#hash table containgin defined variables and their types
#i : int
#s : string
#f : float
# if a variable is used without being defined, it will return unchanged
# i.e "$foo" => " + str(foo) + " if foo is defined as anything but str
# probably not needed
my %variables;

#pointer to variable name, used from parent function to child function
my $varName;

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
  if ($str =~ /\$(\w+)/ ) {
    if(exists $variables{"$1"}) {
      if($variables{"$1"} eq "i") {
        $str = join( "\"+ str($1) +\"", split(/\$$1/, $str, 2) );
      } else {
        $str = join( "\"+ $1 +\"", split(/\$$1/, $str, 2) );
      }
    }
  }

  return "$str";
}

sub translateAssignment {
  my ($line) = @_;
  my ($var, $expr) = split(/=/, $line, 2) ;
  $var =~ s/\$// ;
  $var =~ s/\s+$//;
  $varName = $var;
  return "$var = " . translateExpression($expr) ;
}

sub translateExpression {
  my ($expr) = @_;
  $_ = $expr;
  if(/("[^"]*")/) {
    # string constant
    $variables{"$varName"} = "s";
    return translateString($1);
  } elsif (/(\d+)/) {
    # numerical constant or unquoted string
    $variables{"$varName"} = "i";
    return "$1";
  } else {
    #unimplemented clause for operators
    return "$expr";
  }
}
