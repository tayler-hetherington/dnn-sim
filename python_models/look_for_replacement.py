#!/usr/bin/python
# This script processes a csv of filters for one layer in Caffe
# this csv is provided by Jorge

import numpy as np
import sys
import math

import read_filters
import chunk

def is_zero(w):
    return not w.any()

def zero():
    return 0

def look_for_replacement(r, n, i, weights, ind, lookaside, lookahead):

    # get dimensions 
    (R,Tn,Ti) = weights.shape

    rmax = min(r + lookahead , R-1 )

    # lookaside
    for l in range( 0, lookaside+1 ):
        # search in this order: d = 0, -1, +1, -2, +2 ...
        d = (l+1)/2 
        if (l % 2):
            d *= -1
        ri = i + d
        ri = ri % 16 # wrap around
        # lookahead
        for rr in range( r + 1 , rmax + 1 ):
            if (not is_zero(weights[rr,n,ri])):
                # found a replacement
                weights[r,n,i] = weights[rr,n,ri]
                weights[rr,n,ri] = zero()
                ind[r,n,i] = ind[rr,n,ri]
                ind[rr,n,i] = -1
                return (weights, ind, 1)

    return (weights, ind, 0)
