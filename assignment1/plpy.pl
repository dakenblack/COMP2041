#!/usr/bin/perl
# by Jabez Wilson (jabez.wilson0@gmail.com)
#   * add flag to make it print everything step wise

use strict;
use warnings;

my $debug = 0;

if(scalar @ARGV != 0 and ($ARGV[0] eq "-d" or $ARGV[0] eq "--debug")) {
  $debug = 1;
  shift @ARGV;
}

my $globalIndent = 0;
my $incIndentFlag = 0;

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
    } elsif (/^(if|while)\s+\((.*)\)/) {
      # any if statement
      $op =  translateIfWhile();
    } elsif (/^\S+\s*=/) {
      $op =  translateAssignment($_);
    } elsif (/^(for|foreach)\s+(.*)/) {
      $op =  translateFor();
    } elsif (/^}/) {
      $op =  "";
      $globalIndent --;
    } else {
      $op = $_;
    }
    if(not $debug) {
      for (1 .. $globalIndent ) {
        print "\t";
      }
      print "$op\n";
      if ($incIndentFlag) {
        $globalIndent ++;
        $incIndentFlag = 0;
      }
    }
  }
}

sub translateHashbang {
  return "#!/usr/bin/python3 -u";
}

sub translateIfWhile {
  my ($line) = @_;
  /^(if|while)\s+\((.*)\)/;
  $incIndentFlag = 1;
  return "$1(" . translateExpression($2,0) . "):";
}

sub translateFor {
  my ($line) = @_;
  /^(for|foreach)\s+(\$\w+)\s+\((.*)\)/;
  $incIndentFlag = 1;
  return "for " . translateVar($2) . " in " . translateExpression($3,0) . ":";
}

sub translatePrint {
  my ($line) = @_;
  /^print\s+(.*)/;
  return "print(" . translateExpression($1,1) . ",end=\"\")";
}

sub translateAssignment {
  my ($line) = @_;
  my ($var, $expr) = split(/=/, $line, 2) ;
  $var =~ s/\s+$//;
  return translateVar($var) . " = " . translateExpression($expr,0) ;
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
  $var =~ s/[\$@]// ;
  return $var;
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
      while ($expr =~ /([\$@]\w+)/g ) {
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
