#!/bin/perl

@list = (5,6);

for $i (@list) {
  `wget "http://www.cse.unsw.edu.au/~cs2041/assignments/plpy/examples/2/answer$i.pl"`
}
`wget "http://www.cse.unsw.edu.au/~cs2041/assignments/plpy/examples/2/iota.pl"`
