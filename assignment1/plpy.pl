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
  return "print(" . translateExpression($1,1) . ",end=\"\")";
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
  return "$var = " . translateExpression($expr,0) ;
}

sub translateExpression {
  my ($expr,$isString) = @_;
  $expr =~ s/\s*;\s*$//;
  if($expr =~ /^("[^"]*")$/) {
    #print "HERE\n";
    # string constant
    return translateString($1);
  } elsif ($expr =~ /^(\d+)$/) {
    # numerical constant or unquoted string
    return "$1";
  } else {
    #unimplemented clause for operators
    #convert all variables to their appropriate variable names
    if(not $isString) {
      while ($expr =~ /(\$\w+)/g ) {
        $expr = join( translateVar($1) , split(/\Q$1/, $expr, 2) );
      }
    } else {
      my $temp = "";
      for my $subExpr (split /,/ , $expr) {
        while($subExpr =~ /(\$\w+)/g){
          $subExpr = join( translateVar($1) , split(/\Q$1/, $subExpr, 2) );
        }
        $temp = $temp . "str(" . $subExpr . ") + ";
      }
      $temp =~ s/\+\s*$//;
      $expr = $temp;
    }

    return "$expr";
  }
}
