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
use List::Util qw(sum);
use POSIX qw(ceil);

sub print_weights;

my @weights; # [r][n][i]
my @oneCounts; #[n][i]
my $row=0;
# read file or STDIN
while(<>){
    chomp;
    # if not a blank line (end of chunk)
    if ( ! /^\s*$/ ){
#        print "$_\n";
        my @tileN = split /\|/;
        die if @tileN != 16;
        for (my $n=0; $n<@tileN; $n++){
            my @bits = split //, $tileN[$n];
            die if @bits != 16;
            for my $i (0..$#bits){
                $weights[$row][$n][$i] = $bits[$i];
#               print "[$row][$n][$i] = $weights[$row][$n][$i] ";
                $oneCounts[$n][$i] += $bits[$i];
            }
#            print "\n";
        }
        $row++;
    } else {
        $row = 0;
    }
}

my @avgOnes = ();
for my $n (0..15){
    my $totalOnes = sum(@{$oneCounts[$n]});
    $avgOnes[$n] = ceil($totalOnes / 16);
}

my $n=0;
print "avg ones = $avgOnes[$n]\n";
print " ones count = " . (join ',', @{$oneCounts[$n]}) . "\n";
print "\n";

print_weights(\@weights);

#print "\nfirst 16\n";
#for (my $r=0; $r<16; $r++){
#    print (join '', @{@weights[$r]->[$n]});
#    print "\n";
#}

my $zeroRowCount=0;

print "\nlookahead buffers\n";
for (my $r=0; $r<63; $r++){
    if (0){
    print (join '', @{@weights[$r]->[$n]});
    print "\n";
    print (join '', @{@weights[$r+1]->[$n]});
    print "\n";
    print "--------------------\n";
    }
    my $allZeros = 1;
    for my $i (0..15){
        $allZeros = 0 if ($weights[$r][$n][$i]);
    }
    if ($allZeros){
        $zeroRowCount++;
        next;
    }
    for my $i (0..15){
        if ($weights[$r][$n][$i] == 0){
            $weights[$r][$n][$i] = $weights[$r+1][$n][$i];
            $weights[$r+1][$n][$i] = 0;
        }
    }
    if (0){
    print (join '', @{@weights[$r]->[$n]});
    print "\n";
    print (join '', @{@weights[$r+1]->[$n]});
    print "\n";
    print "####################\n";
    }

}

for (my $r=0; $r<64; $r++){
    print (join '', @{@weights[$r]->[$n]});
    print "\n";
}
print "zero row count = $zeroRowCount\n";
exit;
###############################################################################

sub print_weights {
    my $weights = $_;
    for (my $r=0; $r<64; $r++){
        for (my $i=0; $i<16; $i++){
            print $weights[$r][$n][$i];
        }
        print "\n";
    }
}
