#!/usr/bin/python
import sys
import code
import re
import glob
import numpy as np
#import matplotlib.pyplot as plt
#import matplotlib.ticker as mtick

from os.path import basename

np.set_printoptions(precision=4)

def insert_unique(l, n):
  if n not in l:
    l.append(n)
    l.sort()
    

###############################################################################

args = list(sys.argv)
script = args.pop(0)
global precision
files = args

if ( not ".csv" in files[0] ):
    files = glob.glob( files[0] + '/*.csv' )

file = open('net_names.txt')

net_names = [re.sub(".csv","",(basename(w))) for w in files]
print net_names

try:
    batch_name = files[0].split("/")[1] # results/<batch>/<script>-<config>/<net>.csv
except IndexError as e:
    print e, "files[0] =", files[0]
precision = batch_name.split('_')[-1]

x_vals = []
n_vals = []

# placeholder parameters
x_label = 'x'
x_col = 0
y_label = 'y'
y_redux_col = 1
y_col = 2
n_label = 'n'
n_col = 3
title = 'title'
input_file = ''
save_file = batch_name

#define parameters for your experiment here

if ('same_row_explore' in batch_name):
    x_label = 'in_limit'
    x_col = 4
    n_label = 'out_limit'
    n_col = 3
    title = 'Buffer Size (%s)' % precision
    y_label = 'Removed Duplicates'
    y_redux_col = 5
    y_col = 6
elif ('zero_stats' in batch_name):
    x_label = 'in_limit'
    x_col = 1
    n_label = 'out_limit'
    n_col = 2
    title = 'Buffer Size (%s)' % precision
    y_label = 'Removed Duplicates'
    y_redux_col = selected_col
    y_col = 6
elif ('dup_stats' in batch_name):
    x_label = 'none'
    x_col = -1
    n_label = 'none'
    n_col = -1
    title = 'Buffer Size (%s)' % precision
    y_label = 'Removed Duplicates'
    y_redux_col = 1
    y_col = selected_col
    total_row_col = 3
elif ('tii_scaling' in batch_name):
    x_label = 'Tii'
    x_col = 8
    n_label = 'config'
    n_col = -1
    title = 'Buffer Size (%s)' % precision
    y_label = 'Removed Duplicates'
    y_redux_col = 14
    y_col = 15
    total_row_col = 15
elif ('shared_FA' in batch_name):
    x_label = 'buffer size'
    x_col = 13
    n_label = 'config'
    n_col = -1
    title = 'Buffer Size (%s)' % precision
    y_label = 'Removed Duplicates'
    y_redux_col = 10
    y_col = 11
    total_row_col = 11
elif ('buffer_size_vs_weight_redux' in batch_name):
    x_label = 'buffer size'
    x_col = 7
    n_label = 'config'
    n_col = -1
    title = 'Buffer Size (%s)' % precision
    y_label = 'Removed Duplicates'
    y_redux_col = 15
    y_col = 16
    total_row_col = 11
elif ('reuse_stats' in batch_name):
    x_label = 'buffer size'
    x_col = -1
    n_label = 'config'
    n_col = -1
    title = 'Buffer Size (%s)' % precision
    y_label = 'Removed Duplicates'
    y_redux_col = 1
    y_col = 2
    total_row_col = 1
elif ('broadcast_bus_scaling' in batch_name):
    x_label = 'bus width'
    x_col = 6
    n_label = 'config'
    n_col = -1
    title = 'Buffer Size (%s)' % precision
    y_label = 'Removed Duplicates'
    y_redux_col = 15
    y_col = 16
    total_row_col = 16
else:
    print "Warning, using default indicies"

# read files into data_dict
# data_dict[net][x][n] = [list of layer lines]
data_dict = {}
# for each network
for f in range(0,len(files)):
    file = open(files[f])
    lines = file.readlines()
    net = net_names[f]
    data_dict[net] = {}

    # for each layer in network
    for line in lines:
        cols = line.split(',')
        if (x_col >= 0):
            x = int(cols[x_col])
        else:
            x=0
        if (n_col >= 0):
            n = int(cols[n_col])
        else:
            n=0
        if not x in data_dict[net]:
            data_dict[net][x] = {}
        if not n in data_dict[net][x]:
            data_dict[net][x][n] = []
        data_dict[net][x][n].append(line)

x_vals = data_dict[net_names[0]].keys()
x_vals.sort()
print "x vals =", x_vals
n_vals = data_dict[ net_names[0] ][ x_vals[0] ].keys()
n_vals.sort()
print "n vals =", n_vals
x_size = len(x_vals)
n_size = len(n_vals)
num_nets = len(net_names)


# convert dict to ndarray

y_rel = np.zeros( (x_size, n_size, num_nets) )
for f, net in enumerate(net_names):
    for xi, x in enumerate(x_vals):
        for ni, n in enumerate(n_vals):
            y = []
            y_redux = []
            r = []
            for layer in data_dict[net][x][n]:
                cols = layer.split(',')
                y.append(       float(  cols[y_col]         ))
                y_redux.append( float(  cols[y_redux_col]   ))
                r.append(       int(    cols[total_row_col] ))
            y = np.array(y)
            y_redux = np.array(y_redux)
            r = np.array(r)

            # row reduction
            y_rel [xi,ni,f] = y_redux.sum() / y.sum()

            # stat per row
            #y_redux [xi,ni,f] = y.sum() / r.sum() 

            # weigh by number of rows
            #y_rel [xi,ni,f] = np.sum( np.multiply(y,r) / r.sum() )
#    print net_names[f]
#    print y_rel [:,:,f]


avg = y_rel.mean(2)
print "Avg"
print avg

sys.exit()
