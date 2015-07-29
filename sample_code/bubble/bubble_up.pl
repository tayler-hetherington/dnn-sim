#!/usr/bin/perl
# This script processes a binary trace of SB where weights are represented as
#   0: zero weights
#   1: non zero weights
#
# format:
# starting from the first row to be processed
#
# |------Ti*Tn---------|
# |-Ti-|
# 10100|10110|...|10101| \
# 11000|11010|...|00101| |
# ....                    Input Chunk Size
# 01010|01010|...|11101| /
#
# 11110|10110|...|     <- Next Chunk Iteration
# ...
#

use strict;

my @filters;
my $row=0;
# read file or STDIN
while(<>){
    chomp;
    # if not a blank line (end of chunk)
    if ( ! /^\s*$/ ){
        print "$_\n";
        $row++;
        my @tileN = split /\|/;
        print "num tiles = " . scalar(@tileN) . "\n";
    } else {
        print "$row rows\n";
        $row = 0;
    }
}
