#!/bin/perl

@list = (0,1,2,3,4);

for $i (@list) {
  `wget "http://www.cse.unsw.edu.au/~cs2041/assignments/plpy/examples/1/answer$i.pl"`
}
