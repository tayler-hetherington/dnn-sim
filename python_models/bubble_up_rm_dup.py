#!/usr/bin/python
# This script processes a csv of filters for one layer in Caffe
# this csv is provided by Jorge

import numpy as np
import sys
import math

import read_filters
import chunk

import look_for_replacement as re

total_reduced_rows = 0
total_rows = 0

def interact():
    import code
    code.InteractiveConsole(locals=globals()).interact()

def debug():
    import pdb
    pdb.set_trace()

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

def map_weight(w):
    global negatives_are_dups 
    if (negatives_are_dups):
        return abs(w)
    else:
        return w

def map_duplicates(weights, absolute=False):

    # get dimensions
    (R,Tn,Ti) = weights.shape

    dup_map = {}

    for r in range(R):
        for n in range(Tn):
            for i in range(Ti):

               # don't add zeroes
               if (not weights[r,n,i]):
                   continue

               # key for this weight and position
               key = (r,i,weights[r,n,i])

               if (absolute):
                   key = (r,i,abs(weights[r,n,i]))

               if (not dup_map.has_key(key)):
                   dup_map[key] = 0

               dup_map[key] += 1

    return dup_map              

# for a given entry r,n,i scan current row and the original row
# 
def look_for_duplicates(r, n, i, weights, ind, dup_map, lookahead, absolute=False):


    # get dimensions 
    (R,Tn,Ti) = weights.shape

    # provider's real index and weight
    (pr,pn,pi) = ind[r,n,i]
    pw = weights[r,n,i]
    if (absolute):
        pw = abs(pw)

    #print "LD: ", (ind[r,n,i]), (r,n,i), " ",  weights[r,n,i]
    # where to look for
    look_in_n = set(range(0,Tn))
    look_in_n.remove(pn)

    dup_index = []
    dup_key = (pr,pi,pw)

    if (not dup_map.has_key(dup_key)):
       return dup_index

    for rr in (r,pr):

        remove_n = set()
        for nn in look_in_n:

            for ii in range(Ti):

                # found all the duplicates, return
                if (len(dup_index) == dup_map[dup_key] - 1):
                   return dup_index

                # get target's real index
                (dr,dn,di) = ind[rr,nn,ii]
                dw = weights[rr,nn,ii]
                if (absolute):
                    dw = abs(dw)

                # found a dup if both the real r, i and weights are the same
                if (dw == pw and dr == pr and di == pi):
                   remove_n.add(nn)
                   dup_index.append((rr,nn,ii))
                   break

        look_in_n = look_in_n.difference(remove_n)

    return dup_index


def remove_duplicates(r, n, i, weights, ind, dup_index,
                      out_ctr, in_ctr, lookaside, lookahead, base_n):

    dup_rm = 0
    dup_bubble = 0
    dup_bubble_pop = 0
    ictr = 0
    octr = 0

    stat = [dup_rm, dup_bubble, dup_bubble_pop, ictr, octr]

    # reached output limit for this cycle
    # or can't fill in the bubble
    if (not out_ctr[n]):
       return (weights, ind, out_ctr, in_ctr, stat)

    if (is_zero( weights[r,n,i] )):
       return (weights, ind, out_ctr, in_ctr, stat)

    # get dimensions 
    (R,Tn,Ti) = weights.shape

    # go through each of them and see if they will accept inputs 
    output_dup = False
    for dup in dup_index:
        (dr,dn,di) = dup

        # make sure we are not trying to remove the source
        #print "RM: ", dup, " ", (r,n,i)
        if (dup == (r,n,i)):
           continue

        # reached input limit
        if (in_ctr[dn] == 0):
           continue

        #print "Du: ", (r,n,i,weights[r,n,i]), (dr,dn,di,weights[dr,dn,di]) 
        weights[dr,dn,di] = zero()
        ind[dr,dn,di] = -2
        output_dup = True
        in_ctr[dn] -= 1
        ictr += 1
        dup_rm += 1

    if (output_dup):
        out_ctr[n] -= 1
        octr += 1

    stat = [dup_rm, dup_bubble, dup_bubble_pop, ictr, octr]

    return (weights, ind, out_ctr, in_ctr, stat)


def get_global_weight_idx(chunk_n, chunk_i, r, n, i):
    global Ti
    ii = chunk_i + r*Ti
    gn = chunk_n + n
    gi = i + ii
    return (gn,gi)

def process_weights(weights, weight_idx, lookaside, lookahead, out_limit, in_limit):
    chunk_n, chunk_i = weight_idx
    #print "chunk:", chunk_n, chunk_i
    zero_rows = 0;


    # recalculate global index

    (R,Tn,Ti) = weights.shape
    ind = np.indices((R,Tn,Ti)).swapaxes(0,3).swapaxes(0,2).swapaxes(0,1)
    dup_map = map_duplicates(weights, True)

    out_per_row = [0] * (Ti+1)
    in_per_row = [0] * (Tn+1)
    out_res_per_row = [0] * (Ti+1)
    in_res_per_row = [0] * (Tn+1)

    zero_rm = 0 # number of zeros removed
    dup_rm = 0 # number of dups removed
    dup_bubble = 0 # ignore
    dup_bubble_pop = 0 # ignore

    # iterate in chunk order and save duplicate values
    global glob_dups
    global removed_dups
    global forwarded_dups
    global buffer
    global glob_max_buffer_size 
    for r in range(R):
        for n in range(Tn):
            for i in range(Ti):
                w = map_weight(weights[r,n,i])
                if (w == 0):
                    continue

                (gn,gi) = get_global_weight_idx(chunk_n, chunk_i, r, n, i)
                # is this a duplicate?
                if ( (w,gi) in glob_dups and len(glob_dups[(w,gi)]) > 1):

                    # is the product already in the buffer
                    if (w,gi) in buffer:
                        if (gn not in buffer[(w,gi)]):
                            continue # this product was forwarded by a previous operation

                        # remove current key
                        buffer[(w,gi)].remove(gn)
                        removed_dups += 1
                        # print "removed",w,gn,gi
                        # have all the duplicates been forwarded?
                        if len(buffer[(w,gi)]) == 0:
                            # get rid of this entry in the buffer
                            del buffer[(w,gi)]
                    else:
                        # product is not stored in the buffer

                        # will this product be reused?
                        nidx = glob_dups[(w,gi)].index(gn) 
                        if ( nidx == len(glob_dups[(w,gi)])-1 ):
                            # last duplicate in list, don't save
                            continue

                        # get the remaining duplicates
                        dups = list(glob_dups[(w,gi)][nidx+1:])
                            
                        # can the duplicates be forwarded this cycle?
                        for d in dups:
                            if gn/Tn == d/Tn:
                                dups.remove(d)
                                forwarded_dups += 1
                                removed_dups += 1

                        if ( len(dups) == 0 ):
                            # all duplicates forwarded
                            continue

                        # add to buffer
                        global buffer_size

                        keys = buffer.keys()
                        if (len(keys) >= buffer_size):
                            # buffer is full
                            continue # dont evict ever
                            
                            # find an eviction candidate
                            # policy: longest next reuse
                            victim_c = -1
                            victim_key = []
                            for key in keys:
                                (kn,ki) = (buffer[key][0],key[1])
                                next_c = chunk.n_i_to_cycle(kn,ki,Nn,Ni)
                                if next_c > victim_c:
                                    victim_c = next_c
                                    victim_key = key
#                            print "n =",gn, "evicting", buffer[victim_key]

                            # if victim has longer reuse than the current dup, replace it
                            replacement_c = chunk.n_i_to_cycle(dups[0], gi, Nn, Ni)
                            if (victim_c > replacement_c):
                                del buffer[victim_key]
                            else:
                                continue #don't add replacement to the list

                        buffer[(w,gi)] = dups
                        glob_max_buffer_size = max(glob_max_buffer_size, len(buffer.keys()))

                                
                        
                
    return

#################################################################################

def process_chunk(weights, weight_idx, lookaside, lookahead, out_limit, in_limit):

    chunk_n, chunk_i = weight_idx
    #print "chunk:", chunk_n, chunk_i
    zero_rows = 0;

    # recalculate global index
    (R,Tn,Ti) = weights.shape
    ind = np.indices((R,Tn,Ti)).swapaxes(0,3).swapaxes(0,2).swapaxes(0,1)
    dup_map = map_duplicates(weights, True)

    out_per_row = [0] * (Ti+1)
    in_per_row = [0] * (Tn+1)
    out_res_per_row = [0] * (Ti+1)
    in_res_per_row = [0] * (Tn+1)

    zero_rm = 0 # number of zeros removed
    dup_rm = 0 # number of dups removed
    dup_bubble = 0 # ignore
    dup_bubble_pop = 0 # ignore

    for r in range(0,R-1):
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

        # counter for the limits
        in_ctr = [in_limit] * Tn # input limit per filter (m), max inputs to adder tree
        out_ctr = [out_limit] * Ti # number of products that can be broadcast for an input i
        ictr = 0 # number of products reused
        octr = 0 # number of products broadcast
        ires = 0 # ignore
        ores = 0 # ignore
        changed = True
        dup_found = set()

        # fill bubbles
        while changed:
            changed = False
            dup_found_iter = []

            # look for duplicates
            for n in range(0,Tn):
                for i in range(0,Ti):
                    # look for duplicates only if we haven't looked at it before
                    key = (ind[r,n,i][0], ind[r,n,i][2], weights[r,n,i])
                    if (key not in dup_found and not is_zero(weights[r,n,i])):

                        # dup_index is list of duplicates for (r,n,i)
                        dup_index = look_for_duplicates(r, n, i, weights, ind, dup_map, lookahead)
                        dup_found.add(key)
                        if (dup_index):
                            dup_index.append((r,n,i))
                            dup_found_iter.append(dup_index)
                            #print "A ", dup_index, "W ", weights[r,n,i]

            # prioritize removal here

            # reorder the duplicate removal order
            # do the ones with more duplicates first
            dup_found_iter.sort(key=len, reverse=True)

            # pick the filter with the least number of duplicates to
            # send first, this should reduce input dependences
            n_ctr = {}
            for dup_list in dup_found_iter:
                for element in dup_list:
                    n_ctr[element[1]] = n_ctr.get(element[1],0) + 1
            
            for tmp in dup_found_iter:
                tmp.sort(key=lambda fn: n_ctr.get(fn[1], Tn*Ti+1))

            # remove duplicates in list order
            #   checking for constraints
            for dup_list in dup_found_iter:
                # for each set of duplicates
                # first dup that can be issued (in the current row) will be issued, rest will be removed

                for index in dup_list:

                    (rr,nn,ii) = index 

                    # only output if the index is on the current row
                    if (r != rr):
                       continue   
 
                    # remove all other duplicates if possible
                    (weights, ind, out_ctr, in_ctr, stat) = remove_duplicates(rr, nn, ii,
                          weights, ind, dup_list, out_ctr, in_ctr, lookaside, lookahead, nn)
                    dup_rm += stat[0]
                    dup_bubble += stat[1]
                    dup_bubble_pop += stat[2]
                    ictr += stat[3]
                    octr += stat[4]

                    # exit when a remove succeeded
                    if (stat[0]):
                       break;


            # remove all the bubbles in the row
            for n in range(0,Tn):
                for i in range(0,Ti):
    
                    # fill in the bubble
                    if (is_zero( weights[r,n,i] )):
                        # found a zero to fill, look for replacement
                        (weights, ind, tmp) = re.look_for_replacement(
                                    r, n, i, weights, ind, lookaside, lookahead)
                        zero_rm += tmp
                        changed = changed or tmp
   
   
        # end of change loop

        #out_per_row[octr/max(1,out_limit)] += 1
        #in_per_row[ictr/max(1,in_limit)] += 1
        #out_res_per_row[ores/max(1,out_limit)] += 1
        #in_res_per_row[ires/max(1,in_limit)/Tn] += 1

        # print "--------------------------------"
        # for tr in range(r, rmax + 1):
            # print_row(weights,tr)

    # print_filter(weights,n)
    #print_weights(weights)

    # check if the last row is zero
    if (is_zero( weights[R-1,:,:] ) ):
        zero_rows += 1

    #print "row reduction = ", R-zero_rows , "/", R
    #print "Output Counter: ", out_per_row
    #print "Input Counter: ", in_per_row
    #print "Output Res: ", out_res_per_row
    #print "Input Res: ", in_res_per_row
    #print "Bubble/Dup/B+D/B+D+P: ", (zero_rm, dup_rm, dup_bubble, dup_bubble_pop)

    global total_reduced_rows 
    total_reduced_rows += R - zero_rows
    global total_rows 
    total_rows += R

    # print weights.any(axis=(1,2)) # print out false if a row is all zero
    #wa = [weights[i,:,:].any() for i in range(weights.shape[0])] # changed for 1.6.1 compatilibility

    #ind = ind[wa,:,:]
    #weights = weights[wa,:,:]

    #return (R-zero_rows,ind,weights)

######### MAIN ################################################################

script, filename, lookaside, lookahead, out_limit, in_limit, buffer_size = sys.argv
lookaside = int(lookaside)
lookahead = int(lookahead)
out_limit = int(out_limit)
in_limit = int(in_limit)
buffer_size = int(buffer_size)
negatives_are_dups = True

Ti=16
Tn=16

#print "read filter file"
# w is an Nn x Ni ndarray of weights
w = read_filters.read_filters(filename)
(Nn, Ni) = w.shape

#print w.shape

glob_weights = w
glob_dups = {}
glob_max_buffer_size = 0

total_dups = 0
removed_dups = 0
forwarded_dups = 0
buffer = {}

add = 0
for i in range(Ni):
    for n in range(Nn):
        weight = map_weight(w[n,i])
        if (weight == 0):
            continue
        if ( not (weight,i) in glob_dups ):
            glob_dups[(weight,i)] = []
        else:
            add += 1
            #print "add",weight,n,i

        glob_dups[(weight,i)].append(n)

for key in glob_dups:
#    print key, len(glob_dups[key]), glob_dups[key]
    total_dups += len(glob_dups[key])-1
#        print key, glob_dups[key]
#print "break into chunks"
# chunks is a list of Nrows * Tn * Ti weights
(chunks, chunk_idxs) = chunk.chunk(w)

#print "processing each chunk"
np.set_printoptions(threshold=np.inf)
for (c, c_idx) in zip(chunks, chunk_idxs):
    process_chunk(c, c_idx, lookaside, lookahead, out_limit, in_limit)

left=0
for key in buffer:
    (w,i)=key
    for n in buffer[key]:
        #print "left ", i, n
        left += 1

cols = (filename, lookaside, lookahead, out_limit, in_limit, total_reduced_rows, total_rows)
#cols = (filename, lookaside, lookahead, out_limit, in_limit, removed_dups, total_dups)
#cols = (filename, lookaside, lookahead, out_limit, in_limit, forwarded_dups, removed_dups, total_dups, glob_max_buffer_size)
for c in cols:
    print str(c) +",",


