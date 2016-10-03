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
my $endBlockReached = 0;

my $after = "";
my $before = "";
my $endBlock = "";

main();

sub main {
  while(<>){
    my $op;
    while(/}/) {
      $globalIndent --;
      $endBlockReached = 1;
      if($debug) {
        print "<END OF BLOCK>\n";
      }
      s/}//;
    }

    chomp;
    s/^\s+//;
    s/[\s\n]+$//;


    if(/^#!\/usr\/bin\/perl/){
      # #!/usr/bin/perl
      $op = translateHashbang();
    } elsif (/^print\s+(.*)/) {
      # any print statement
      $op =  translatePrint();
    } elsif (/^(if|while|elsif)\s*\((.*)\)/) {
      $incIndentFlag = 1;
      # any if statement
      $op =  translateIfWhile($_);
    } elsif (/^else\s*{/) {
      # any if statement
      $incIndentFlag = 1;
      $op =  "else:";
    } elsif (/^\s*(\$\w+)\s*(=~)/) {
      $op =  handleOperators($_);
    } elsif (/^\S+\s*=/) {
      $op =  translateAssignment($_);
    } elsif (/^\s*(\$\w+)\s*(\+\+|--)/) {
      # unary operators
      $op =  handleOperators($_);
    } elsif (/^\s*(\$\w+)\s*(\+=|-=)\s*(.*?)/) {
      # unary operators
      $op =  translateExpression($_);
    } elsif (/^for\s+\(.*?;.*?;.*?\)/) {
      $incIndentFlag = 2;
      $op =  translateFor($_);
    } elsif (/^(for|foreach)\s+(.*)/) {
      $incIndentFlag = 1;
      $op =  translateForeach();
    } elsif (/^\w+;?$/) {
      $op =  translateStatement($_);
    } elsif (/^\w+\s+\$?\w+/) {
      $op =  translateFunction($_);
    } elsif (/^}/) {
      $op =  "";
    } else {
      $op = $_;
    }
    $op = "$op\n$after";
    if(not ("$before" eq "")) {
      $op = "$before\n$op";
    }
    chomp $op;
    if($endBlockReached) {
      $endBlockReached = 0;
      $op = "$op\n\t$endBlock";
    }
    $before = "";
    $after = "";
    for my $l (split(/\n/,$op)) {
      for (1 .. $globalIndent ) {
        print "\t";
      }
      print "$l\n";
      if ($incIndentFlag == 1) {
        $globalIndent ++;
        $incIndentFlag = 0;
      } elsif ($incIndentFlag != 0) {
        $incIndentFlag--;
      }
    }
  }
}

sub translateHashbang {
  return "#!/usr/bin/python3 -u\nimport sys, re";
}

sub translateIfWhile {
  my ($line) = @_;
  /^(if|while|elsif)\s+\((.*)\)/;
  if($1 eq "elsif") {
    return "elif(" . translateExpression($2,0) . "):";
  } else {
    return "$1(" . translateExpression($2,0) . "):";
  }
}

sub translateFor {
  my ($line) = @_;
  /^for\s+\((.*?);(.*?);(.*?)\)/;
  $after = "while ". translateExpression($2) . ":";
  $endBlock = translateExpression($3);

  return translateAssignment($1);
}

sub translateForeach {
  my ($line) = @_;
  /^(for|foreach)\s+(\$\w+)\s+\((.*)\)/;
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
  while ($str =~ /(\$\w+\[.*?])/ ) {
    #translate arrayindices
    $str = join( "\"+ str(" . translateVar($1) . ") +\"", split(/\Q$1/, $str, 2) );
  }
  while ($str =~ /(\$\w+)/ ) {
    $str = join( "\"+ str(" . translateVar($1) . ") +\"", split(/\Q$1/, $str, 2) );
  }

  return "$str";
}

sub translateVar {
  my ($var) = @_;
  if ($var =~ /^\$#(\w+)/) {
    $var = "len(" . translateVar("\$$1") . ")"
  } elsif($var =~/(\$\w+)\[(.*?)]/) {
    if(isExpression($2)){
      $before = translateExpression($2);
      return translateVar($1) . "[". getFirstVariable($2) . "]";
    } else {
      return translateVar($1) . "[int(". translateVar($2) . ")+1]";
    }
    #indexing
  } elsif($var =~ /[\$@]ARGV/) {
    $var =~ s/[\$@]ARGV/sys.argv/g;
  } else {
    $var =~ s/[\$@]// ;
  }
  return $var;
}

sub isExpression {
  my ($expr) = @_;
  if(/(\+=|-=|\+|-)/) {
    return 1;
  } else {
    return 0;
  }
}

sub getFirstVariable {
  my ($expr) = @_;
  #print "GET FIRST <$expr>\n";
  $expr =~ /^\s*(\$\w+)/;
  return translateVar($1);
}

sub translateExpression {
  my ($expr,$isString) = @_;
  $expr =~ s/\s*;\s*$//;
  $expr =~ s/<STDIN>/input()/;
  $expr =~ s/<>/input()/;
  chomp $expr;
  $expr =~ s/^\s+//;
  $expr =~ s/[\s\n]+$//;
  #print "EXPR: <$expr>\n";
  if($expr =~ /^[\$@#]{1,2}\w+$/) {
    return translateVar($expr);
  } elsif($expr =~ /^\$\w+\[.*?\]$/) {
    return translateVar($expr);
  } elsif($expr =~ /^\s*(["'].*["'])\s*$/) {
    # string constant
    return translateString($1);
  } elsif ($expr =~ /^\s*(\d+)\s*$/) {
    # numerical constant or unquoted string
    return "$1";
  } elsif ($expr =~ /^\s*([a-zA-Z]\w*)\s*\((.*?)\)/i) {
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
  #print "<$expr> \n";
  if ($expr =~ /(\d+)\s*\.\.\s*(\d+)/) {
    # .. operator with number constants
    my $lim = $2 + 1;
    return "range($1,$lim)";
  } elsif ($expr =~ /(.*?)\s*\.\.\s*(.*)/) {
    # .. operator with variables
    return "range(" . translateVar($1) . ", " . translateVar($2) . ")";
  } elsif ($expr =~ /^(.*?)\s*(==|<|>=|<=)\s*([\$\w]+)/) {
    # comparison operators on constants and variables
    $expr =  "int(". translateExpression($1) .") $2 int(". translateVar($3) .")";
    while ($expr =~ /([\$@]\w+)/g ) {
      $expr = join( translateVar($1) , split(/\Q$1/, $expr, 2) );
    }
    return "$expr";
  } elsif ($expr =~ /^\s*(\$\w+)\s*(\+\+|--)/) {
    # unary decrement and increment operators
    if($2 eq "++") {
      return translateVar($1) . " += 1";
    } else {
      return translateVar($1) . " -= 1";
    }
  } elsif ($expr =~ /^\s*(\$\w+)\s*=~\s*s\/(.*?)\/(.*?)\/(g?)/) {
    #replace with re
    return translateVar($1) . " = re.subn(r'$2',r'$3',". translateVar($1) .")[0]"

  } elsif ($expr =~ /^([\$\w]+)\s*(%|\*\*|\/|\*)\s*([\$\w]+)/) {
    # comparison operators on variables
    $expr =  "int(". translateExpression($1) .") $2 int(". translateVar($3) .")";
    while ($expr =~ /([\$@]\w+)/g ) {
      $expr = join( translateVar($1) , split(/\Q$1/, $expr, 2) );
    }
    return "$expr";
  } elsif ($expr =~ /^\$?(.*?)\s*(=)\s*(input\(\))/) {
    # comparison operators on constants and variables
    $expr =  "True";
    $after = "$1 = sys.stdin.readline().strip()\nif not $1:\n\tbreak";
    while ($expr =~ /([\$@]\w+)/g ) {
      $expr = join( translateVar($1) , split(/\Q$1/, $expr, 2) );
    }
    return "$expr";
  }
  while ($expr =~ /([\$@]\w+)/g ) {
    $expr = join( translateVar($1) , split(/\Q$1/, $expr, 2) );
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

sub genericFunc {
  my ($func,$arg) = @_;
  return "$func($arg)";
}
