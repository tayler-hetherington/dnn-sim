#!/usr/bin/python
import sys
import code
import re
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.ticker as mtick

from os.path import basename

def interact():
    import code
    code.InteractiveConsole(locals=globals()).interact()

def debug():
    import ipdb
    ipdb.set_trace()

np.set_printoptions(precision=4)

def plot_2d(data, title, xlabel, ylabel):
    fig = plt.figure()
    plt.title(title)
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    plt.autoscale(enable=True, axis=u'both', tight=False)
    ax = fig.add_subplot(1,1,1)
    fmt = '%.0f%%' # Format you want the ticks, e.g. '40%'
    yticks = mtick.FormatStrFormatter(fmt)
    ax.yaxis.set_major_formatter(yticks)

    for las in range(1,data.shape[1]):
        d = ( data[:,las] * 100 ).tolist()
        x = range(0,len(d))
        y = d
        ax.plot(x,y, label='%d' % las)
        plt.legend(title='lookahead distance')

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

###############################################################################

args = list(sys.argv)
script = args.pop(0)
global precision
precision = args.pop(0)
files = args

if ('csv' in precision):
    print "usage: %s <label> <list of csv files>" % script
    sys.exit()

net_names = [re.sub('_\dbit.csv','',(basename(w))) for w in files]

# get max lookahead and lookaside
max_lookaside = 0
max_lookahead = 0
file = open(files[0])
lines = file.readlines()
for line in lines:
    try:
        input_file, lookaside, lookahead, rows, total, end = line.split(',')
        lookaside = int(lookaside)
        lookahead = int(lookahead)

        max_lookaside = max(max_lookaside,lookaside)
        max_lookahead = max(max_lookahead,lookahead)
    except ValueError:
        next

# ndarray (lookaside,lookahead,network)
redux = np.zeros((max_lookaside+1,max_lookahead+1,len(files)))

# read each input file
for f in range(0,len(files)):
    file = open(files[f])
    lines = file.readlines()
    total_row_redux=0
    total_row=0

    # get total rows and reduced rows for whole network
    total_row_redux = np.zeros((max_lookaside+1,max_lookahead+1))
    total_row = np.zeros(total_row_redux.shape)

    for line in lines:
        try:
            input_file, lookaside, lookahead, rows, total, end = line.split(',')
            total_row_redux[lookaside,lookahead] += int(rows)
            total_row[lookaside,lookahead] += int(total)
        except ValueError:
            next


    total_row[:,0]          = total_row[:,1] # total rows should always be the same total_row_redux[:,0]    = total_row[:,0] # no redux with no lookahead

    redux[:,:,f] = np.divide(total_row_redux, total_row)
    print net_names[f]
    print redux[:,:,f]

avg = redux.mean(2)
print "Avg"
print avg



#for f in range(0,len(files)):
#    plot_2d(redux[:,:,f], 'Lookaside distance scaling %s' % net_names[f], 'Lookaside distance', 'Runtime')
if (0):
    save_file = 'las_scaling_%s' % precision
    plot_2d(avg, 'Average Lookaside distance scaling (%s)' % precision, 'Lookaside distance', 'Computation')
    plt.savefig(save_file + '.eps', format='eps', dpi=1000)
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
    plt.savefig(save_file + '.eps', format='eps', dpi=1000)
    cost_comp = np.concatenate( 
            (   d_mat[:,1:].reshape(-1,1),
                w_mat[:,1:].reshape(-1,1),
                cost[:,1:].reshape(-1,1), 
                avg[:,1:].reshape(-1,1)
            ), axis=1 )
    np.savetxt(save_file + '.csv', cost_comp, delimiter=",", fmt="%.4f")

# show per network performance for best config
if (1):
    group_names = ('Small','Best','Large')
    small =     redux[0,1,:]
    best =      redux[4,3,:]
    large =     redux[15,5,:]

    comp_net = np.concatenate( (small.reshape(-1,1),best.reshape(-1,1),large.reshape(-1,1)), axis=1)
    print data

    plot_bar(comp_net, "Computations per network (%s)" % precision, "networks", "computation", net_names, group_names)

    save_file = 'comp_per_net_%s' % precision
    plt.savefig(save_file + '.eps', format='eps', dpi=1000)
    np.savetxt(save_file + '.csv', comp_net, delimiter=",", fmt="%.4f")

# draw and wait for keyboard
plt.draw()
plt.pause(1)
raw_input('hit any key to continue')
plt.close('all')
