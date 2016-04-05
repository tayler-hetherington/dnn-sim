#!/usr/bin/python
import sys
import code
import re
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.ticker as mtick
import glob

from os.path import basename

def interact():
    import code
    code.InteractiveConsole(locals=globals()).interact()

def debug():
    import ipdb
    ipdb.set_trace()

np.set_printoptions(precision=4)

def plot_2d(data, x_axis, n_axis, title, xlabel, ylabel, legend_title):
    fig = plt.figure()
    plt.title(title)
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
#plt.autoscale(enable=True, axis=u'both', tight=False)
    ax = fig.add_subplot(1,1,1)
    fmt = '%.0f%%' # Format you want the ticks, e.g. '40%'
    yticks = mtick.FormatStrFormatter(fmt)
    ax.yaxis.set_major_formatter(yticks)
    ax.set_xticklabels(x_axis) 
    ax.set_xticks(range(len(x_axis))) # tick position wrt data idx

    for n in range(0,data.shape[1]):
        d = ( data[:,n] * 100 ).tolist()
        x = range(0,data.shape[0]) #x_axis
        y = d
        ax.plot(x,y, label='%d' % n_axis[n])
        if (data.shape[1] > 1):
            plt.legend(title=legend_title)

def plot_scatter(dx, dy, title, xlabel, ylabel):
    fig = plt.figure()
    plt.title(title)
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    plt.autoscale(enable=True, axis=u'both', tight=False)
    ax = fig.add_subplot(1,1,1)
    fmt = '%.0f%%' # Format you want the ticks, e.g. '40%'
    yticks = mtick.FormatStrFormatter(fmt)
    ax.yaxis.set_major_formatter(yticks)

    for las in range(1,dx.shape[1]):
        x = dx[:,las] 
        y = dy[:,las] * 100
        ax.plot(x,y, label='%d' % las)
        plt.legend(title='lookahead distance')

def plot_bar(data, title, xlabel, ylabel, xticks, group_names):
    fig = plt.figure()
    ax = fig.add_axes([0.1,0.175,0.7,0.75])
    plt.title(title)
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    plt.autoscale(enable=True, axis=u'both', tight=False)
    ax.set_xticklabels(xticks, rotation=30)
    ind = np.arange(data.shape[0])
    
    groups = list()

    width=0.3
    n = data.shape[1]
    color=iter(plt.cm.rainbow(np.linspace(0,1,n)))
    for d in range(0,n):
        c=next(color)
        grp = ax.bar(ind + width*d, data[:,d], width, color=c)
        groups.append(grp)

    ax.legend(groups, group_names, bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0.)

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
fmt = "jpg"
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
#    save_file = 'buffer_size_rows_%s' % precision
#    y_label = 'Removed Rows'
#    y_redux_col = 15
#    y_col = 16
    save_file = 'buffer_size_weights_%s' % precision
    y_label = 'Zero Weights'
    y_redux_col = 13
    y_col = 14
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
    title = 'Broadcast Bus Width (%s)' % precision
    y_label = 'Removed Rows'
    y_redux_col = 15
    y_col = 16
    total_row_col = 16
elif ('in_limit_scaling' in batch_name):
    x_label = 'in limit'
    x_col = 4
    n_label = 'config'
    n_col = -1
    title = 'Adder Tree Extra Inputs (%s)' % precision
    y_label = 'Removed Rows'
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
        num_cols = len(cols)
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

print "number of columns =", num_cols
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
            print y
            y_redux = np.array(y_redux)
            print y_redux
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

#for f in range(0,len(files)):
#    plot_2d(redux[:,:,f], 'Lookaside distance scaling %s' % net_names[f], 'Lookaside distance', 'Runtime')
if (1):
    plot_2d(avg, x_vals, n_vals, title, x_label, y_label, n_label)
    plt.savefig(save_file + '.' + fmt, format=fmt, dpi=100)
    np.savetxt(save_file + '.csv', avg, delimiter=",", fmt="%.4f")

#evaluate cost
if (0):
    d = np.array(range(0,6)).reshape(1,-1) # lookahead
    w = np.array(range(0,16)).reshape(-1,1) + 1 # lookaside + 1 for straight lookahead
    cost = np.dot(w,d) + 1 # replacement candidates + the originial input
    d_mat = np.tile(d,(16,1))
    w_mat = np.tile(w,(1,6))
    print 'cost'
    print cost
    print 'avg'
    print avg
    save_file = 'cost_%s' % precision
    plot_scatter(cost, avg, 'Cost Benefit analysis (%s)' % precision, 'Cost (mux inputs)', 'Computation')
    plt.savefig(save_file + '.pdf', format='pdf', dpi=1000)
    cost_comp = np.concatenate( 
            (   d_mat[:,1:].reshape(-1,1),
                w_mat[:,1:].reshape(-1,1),
                cost[:,1:].reshape(-1,1), 
                avg[:,1:].reshape(-1,1)
            ), axis=1 )
    np.savetxt(save_file + '.csv', cost_comp, delimiter=",", fmt="%.4f")

# show per network performance for best config
if (0):
    group_names = ('Small','Best','Large')
    small =     redux[0,1,:]
    best =      redux[4,3,:]
    large =     redux[15,5,:]

    comp_net = np.concatenate( (small.reshape(-1,1),best.reshape(-1,1),large.reshape(-1,1)), axis=1)
    print data

    plot_bar(comp_net, "Computations per network (%s)" % precision, "networks", "computation", net_names, group_names)

    save_file = 'comp_per_net_%s' % precision
    plt.savefig(save_file + '.pdf', format='pdf', dpi=1000)
    np.savetxt(save_file + '.csv', comp_net, delimiter=",", fmt="%.4f")

# draw and wait for keyboard
plt.draw()
plt.pause(1)
raw_input('hit any key to continue')
plt.close('all')
