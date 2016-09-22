#!/bin/perl

@list = (
  "http://www.cse.unsw.edu.au/~cs2041/assignments/plpy/examples/4/devowel.arguments",
  "http://www.cse.unsw.edu.au/~cs2041/assignments/plpy/examples/4/devowel.pl",
  "http://www.cse.unsw.edu.au/~cs2041/assignments/plpy/examples/4/echonl.1.pl",
  "http://www.cse.unsw.edu.au/~cs2041/assignments/plpy/examples/4/line_count.1.input",
  "http://www.cse.unsw.edu.au/~cs2041/assignments/plpy/examples/4/line_count.1.pl",
  "http://www.cse.unsw.edu.au/~cs2041/assignments/plpy/examples/4/odd0.pl",
  "http://www.cse.unsw.edu.au/~cs2041/assignments/plpy/examples/4/size.pl",
  "http://www.cse.unsw.edu.au/~cs2041/assignments/plpy/examples/4/size.pl",
);

for $i (@list) {
  `wget "$i"`
}
