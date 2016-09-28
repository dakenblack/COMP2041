#!/bin/perl

@list = (
  "http://www.cse.unsw.edu.au/~cs2041/assignments/plpy/examples/5/reverse_lines.0.pl",
  "http://www.cse.unsw.edu.au/~cs2041/assignments/plpy/examples/5/reverse_lines.1.pl",
  "http://www.cse.unsw.edu.au/~cs2041/assignments/plpy/examples/5/reverse_lines.2.pl",
  "http://www.cse.unsw.edu.au/~cs2041/assignments/plpy/examples/5/reverse_lines.3.pl",
  "http://www.cse.unsw.edu.au/~cs2041/assignments/plpy/examples/5/reverse_lines.4.pl",
  "http://www.cse.unsw.edu.au/~cs2041/assignments/plpy/examples/5/reverse_lines.5.pl",
  "http://www.cse.unsw.edu.au/~cs2041/assignments/plpy/examples/5/reverse_lines.6.pl",
);

for $i (@list) {
  `wget "$i"`
}
