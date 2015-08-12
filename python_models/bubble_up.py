#!/usr/bin/python
# This script processes a csv of filters for one layer in Caffe
# this csv is provided by Jorge

import numpy as np
import sys
import math

import read_filters
import chunk
import look_for_replacement as re

##### Globals #################################################################
total_reduced_rows = 0
total_rows = 0

def printn (str):
    sys.stdout.write(str)

def print_weights(w):
    for r in range(0,w.shape[0]):
        printn( "%2d|" % r )
        for n in range (0,w.shape[1]):
            for i in range(0,w.shape[2]):
                printn( "%s" % w[r,n,i] )
            printn ("|")
        printn ("\n")

def print_filter(w,n):
    for r in range(0,w.shape[0]):
        printn( "%2d|" % r )
        for i in range(0,w.shape[2]):
            printn( "%s" % w[r,n,i] )
        printn ("|")
        printn ("\n")

def print_row(w,r):
    for n in range (0,w.shape[1]):
        for i in range(0,w.shape[2]):
            printn( "%s" % w[r,n,i] )
        printn ("|")
    printn ("\n")

def is_zero(w):
    return not w.any()

def zero():
    return 0

# for character arrays
# def is_zero(w):
    # for i in np.nditer(w):
        # if (i != '0' and i != 'E'):
            # return 0
    # return 1

# def zero():
    # return '0'




def process_weights(weights, lookaside, lookahead):

    # gather stats about data
    # ones = np.count_nonzero(weights.count('1'))
    # print "ones  = ", ones
    # zeros = np.count_nonzero(weights.count('0')) 
    # print "zeros = ", zeros
    # percent = (ones + 0.0)/(ones+zeros)
    # print "percent ones = ", percent
    # rows = ( (ones + 0.0)/(ones+zeros) * 64 )
    # print "rows of ones = ", rows

    # for n in range(0,Tn):
        # col = weights[:,n,:]
        # ones = np.count_nonzero(col.count('1'))
        # zeros = np.count_nonzero(col.count('0')) 
        # rows = ( (ones + 0.0)/(ones+zeros) * 64 )
        # print n, "rows of ones = ", rows

    # print_weights(weights)
    # print_filter(weights,n)

    zero_rows = 0;

    (R,Tn,Ti) = weights.shape
    ind = np.indices((R,Tn,Ti)).swapaxes(0,3).swapaxes(0,2).swapaxes(0,1)

    # iterate to the end to detect zero row 
    for r in range(0,R):
    #    print "C:", weights[r,n,:]
    #    print "N:", weights[r+1,n,:]
        rmax = min(r + lookahead , R-1 )

        # print r, "##############################"
        # for tr in range(r, rmax + 1):
            # print_row(weights,tr)

        # check for all zeros
        if (is_zero( weights[r,:,:] ) ):
            # print r # print all lines that are all zeroes
            zero_rows += 1
            continue

        # fill bubbles
        for n in range(0,Tn):
            for i in range(0,Ti):

                if (is_zero( weights[r,n,i] )):
                    # found a zero to fill, look for replacement
                    weights, ind, _ = re.look_for_replacement(r,n,i,weights,ind,
                                                 lookaside,lookahead)
                    
        # print "--------------------------------"
        # for tr in range(r, rmax + 1):
            # print_row(weights,tr)

    # print_filter(weights,n)
    # print_weights(weights)

    # print "row reduction = ", R-zero_rows , "/", R
    global total_reduced_rows 
    total_reduced_rows += R - zero_rows
    global total_rows 
    total_rows += R

    # wa = weights.any(axis=(1,2)) # print out false if a row is all zero
    wa = [weights[i,:,:].any() for i in range(weights.shape[0])] # changed for 1.6.1 compatilibility

    ind = ind[wa,:,:]
    weights = weights[wa,:,:]

    return (R-zero_rows,ind,weights)

######### MAIN ################################################################

def main():
    script, filename, lookaside, lookahead = sys.argv
    lookaside = int(lookaside)
    lookahead = int(lookahead)

    # print "read filter file"
    # w is an Nn x Ni ndarray of weights
    w = read_filters.read_filters(filename)

    # print "break into chunks"
    # chunks is a list of Nrows * Tn * Ti weights
    (chunks, chunk_idxs) = chunk.chunk(w)

    # print "processing each chunk"
    for c in chunks:
        process_weights(c, lookaside, lookahead)

    # print "cycles = ", float(total_reduced_rows)/total_rows
    cols = (filename, lookaside, lookahead, total_reduced_rows, total_rows)
    for c in cols:
        print str(c) +",",

if __name__ == "__main__":
    main()

