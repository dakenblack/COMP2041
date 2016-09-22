#!/bin/perl

@list = (
  "http://www.cse.unsw.edu.au/~cs2041/assignments/plpy/examples/3/cookie0.input",
  "http://www.cse.unsw.edu.au/~cs2041/assignments/plpy/examples/3/cookie0.pl",
  "http://www.cse.unsw.edu.au/~cs2041/assignments/plpy/examples/3/echo.2.pl",
  "http://www.cse.unsw.edu.au/~cs2041/assignments/plpy/examples/3/echonl.0.pl",
  "http://www.cse.unsw.edu.au/~cs2041/assignments/plpy/examples/3/five.pl",
  "http://www.cse.unsw.edu.au/~cs2041/assignments/plpy/examples/3/prime0.pl",
  "http://www.cse.unsw.edu.au/~cs2041/assignments/plpy/examples/3/tetrahedral.pl",
);

for $i (@list) {
  `wget "$i"`
}
