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
    } elsif (/^\w+;?$/) {
      $op =  translateStatement($_);
    } elsif (/^\w+\s+\$?\w+/) {
      $op =  translateFunction($_);
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
  return "#!/usr/bin/python3 -u\nimport sys";
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
  if ($var =~ /^\$#(\w+)/) {
    $var = "len(" . translateVar("\$$1") . ")"
  } elsif($var =~ /[\$@]ARGV/) {
    $var =~ s/[\$@]ARGV/sys.argv/g;
  } else {
    $var =~ s/[\$@]// ;
  }
  return $var;
}

sub translateExpression {
  my ($expr,$isString) = @_;
  $expr =~ s/\s*;\s*$//;
  if ($expr =~ /<STDIN>/) {
    $expr =~ s/<STDIN>/input()/;
    return $expr;
  }
  if($expr =~ /^[\$@]\w+$/) {
    return translateVar($expr);
  } elsif($expr =~ /^\s*(["'].*["'])\s*$/) {
    # string constant
    return translateString($1);
  } elsif ($expr =~ /^\s*(\d+)\s*$/) {
    # numerical constant or unquoted string
    return "$1";
  } elsif ($expr =~ /^\s*([a-zA-Z]\w*)\s*\((.*?)\)/i) {
    #print "<$1> <$2>\n";
    return getFunction($1,$2);
  } else {
    #unimplemented clause for operators
    #convert all variables to their appropriate variable names
    if(not $isString) {
      $expr = handleOperators($expr);
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

sub handleOperators {
  my ($expr) = @_;
  while ($expr =~ /([\$@]\w+)/g ) {
    $expr = join( translateVar($1) , split(/\Q$1/, $expr, 2) );
  }
  if ($expr =~ /(\d+)\s*\.\.\s*(\d+)/) {
    my $lim = $2 + 1;
    return "range($1,$lim)";
  } elsif ($expr =~ /(.*?)\s*\.\.\s*(.*)/) {
    return "range(" . translateVar($1) . ", " . translateVar($2) . " + 1)"
  }
  $expr =~ s/\seq\s/ == /;
  return $expr;
}

sub translateStatement {
  my ($st) = @_;
  $st =~ s/\s*;\s*$//;
  if ($st =~ /last/) {
    return "break";
  } elsif($st =~ /next/ ) {
    return "continue";
  } else {
    return $st;
  }
}

sub translateFunction {
  my ($line) = @_;
  if ($line =~ /^chomp\s*(\$?\w*)/) {
    return  translateVar($1) . ".strip()";
  } else {
    return $line
  }
}

sub getFunction {
  my ($func, $arg) = @_;
  if ($func eq "join") {
    my @args = split /\s*,\s*/, $arg;
    return translateExpression($args[0]) . ".join(" . translateExpression($args[1]) . ")"
  } else {
    return genericFunc($func,$arg);
  }
}
