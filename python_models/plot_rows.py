#!/usr/bin/python
import sys
import code
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.ticker as mtick
from os.path import basename

np.set_printoptions(precision=4)

args = list(sys.argv)
script = args.pop(0)
precision = args.pop(0)
files = args

if ('csv' in precision):
    print "usage: %s <label> <list of csv files>" % script
    sys.exit()

net_names = [(basename(w).replace('.csv','')) for w in files]

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

# lookaside,lookahead,network
redux = np.zeros((max_lookaside+1,max_lookahead+1,len(files)))

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

#for f in range(0,len(files)):
#    plot_2d(redux[:,:,f], 'Lookaside distance scaling %s' % net_names[f], 'Lookaside distance', 'Runtime')
plot_2d(avg, 'Average Lookaside distance scaling (%s)' % precision, 'Lookaside distance', 'Runtime')

#evaluate cost
d = np.array(range(0,6)).reshape(1,-1) # lookahead
w = np.array(range(0,16)).reshape(-1,1) + 1 # lookaside + 1 for straight lookahead
cost = np.dot(w,d) + 1 # replacement candidates + the originial input

print 'cost'
print cost
print 'avg'
print avg

plot_scatter(cost, avg, 'Cost Benefit analysis (%s)' % precision, 'Cost (mux inputs)', 'Runtime')

# draw and wait for keyboard
plt.draw()
plt.pause(1)
raw_input('hit any key to continue')
plt.close('all')
