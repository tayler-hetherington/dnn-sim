#!/usr/bin/python

import math
import sys
import numpy as np

def is_number(s):
    try:
        float(s)
        return True
    except ValueError:
        return False

def read_filters(filename):

    file = open(filename)
    lines = file.readlines()

    filter_list = []
    filt = []

    for line in lines:
        if (line.strip() != ""):
            if (line.find("filter") >= 0):
                if (len(filt)):
                    filter_list.append(filt)
                    filt = []
            else:
                entries = line.split(',')
                for e in entries:
                    if (is_number(e)):
                        filt.append(float(e))
        else:
            # blank line: 
            if (len(filt)):
                filter_list.append(filt)
                filt = []

    if (len(filt)):
        filter_list.append(filt)
        filt = []

    Nn = len(filter_list)
    Ni = len(filter_list[0])


    weights = np.array(filter_list)
    return weights

