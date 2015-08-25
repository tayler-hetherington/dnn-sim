#!/usr/bin/python
# This script processes a csv of filters for one layer in Caffe
# this csv is provided by Jorge
# Todo:
#   fix buffer organization
#       can't map to sets via i since non i inputs/weights can be promoted (lookaside) to multiplier (n,i)
#       for now only use a fully shared buffer


import numpy as np
import sys
import math

import read_filters
import chunk

import look_for_replacement as re

total_reduced_rows = 0
total_rows = 0

group_size = 16

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

def map_weight(w):
    global negatives_are_dups 
    if (negatives_are_dups):
        return abs(w)
    else:
        return w



# creates a map of duplicates within a chunk
# for each key (r,i, |weights[r,n,i]|) counts the number of duplicates
def map_duplicates(weights):

    # get dimensions
    (R,Tn,Ti) = weights.shape

    dup_map = {}

    for r in range(R):
        for n in range(Tn):
            for i in range(Ti):
                w = map_weight(weights[r,n,i])

                # don't add zeroes
                if w == 0 :
                    continue

                # key for this weight and position
                key = (r, i, w)

                if (not dup_map.has_key(key)):
                   dup_map[key] = 0

                dup_map[key] += 1

    return dup_map              

# for a given entry r,n,i scan current row and the producers original row 
# returns:
#   dup_index   a list of duplicates that can be removed, doesn't include the producer
def look_for_duplicates(r, n, i, weights, ind, dup_map):
    # get dimensions 
    (R,Tn,Ti) = weights.shape

    # producers's real index and weight
    (pr,pn,pi) = ind[r,n,i]
    pw = map_weight(weights[r,n,i])

    #print "LD: ", (ind[r,n,i]), (r,n,i), " ",  weights[r,n,i]
    # where to look for
    global group_size
    look_in_n = set(range(pn/group_size*group_size,
                          pn/group_size*group_size+group_size))

    # don't consider the producer when looking for consumers
    #look_in_n.remove(pn)

    dup_index = []
    dup_key = (pr,pi,pw)

    if (not dup_map.has_key(dup_key)):
       return dup_index

    # check current row and producers original row
    for rr in (r,pr):

        remove_n = set()
        for nn in look_in_n:
            for ii in range(Ti):

                # found all the duplicates, return
                if (len(dup_index) == dup_map[dup_key] ):
                   return dup_index

                # get target's real index
                (dr,dn,di) = ind[rr,nn,ii]
                dw = map_weight(weights[rr,nn,ii])

                # found a dup if both the real r, i and weights are the same
                if (dw == pw and dr == pr and di == pi):
                   remove_n.add(nn)
                   dup_index.append((rr,nn,ii))
                   break

        look_in_n = look_in_n.difference(remove_n)

    return dup_index

# removes duplicates 
#   inputs:
#       r,n,i       producer indices in the chunk
#       weights     chunk of weights to be updated
#       ind         the original indices of each weight in weights
#       dup_list    list of (r,n,i) of duplicates to remove, 
#       out_ctr     counts the stage 1 mux outputs used for each group of n multipliers
#       in_ctr      counts the stage 2 mux outputs used for each adder tree (n)
#   returns:
#       stats       list of stats 
def remove_duplicates(r, n, i, weights, ind, dup_list, out_ctr, in_ctr):
    global ictr, octr
    ictr = 0 #input counter (stage 2 collecting mux)
    octr = 0 #output counter (stage 1 broadcasting mux)
    dup_rm = 0

    # reached output limit for this cycle
    # or can't fill in the bubble
    if ( out_ctr[n] > 0 ):

        # get dimensions 
        (R,Tn,Ti) = weights.shape

        # go through each of them and see if they will accept inputs 
        output_dup = False # are we broadcasting a duplicate?
        for dup in dup_list:
            (dr,dn,di) = dup

            # don't remove the producer
            #print "RM: ", dup, " ", (r,n,i)
            if (dup == (r,n,i)):
               continue

            # row -1 indicates a buffered entry
            if (r == -1):
                continue

            # reached input limit for this output (adder tree)
            if (in_ctr[dn] == 0):
               continue
    
            # remove (dr,dn,di)
            #print "Du: ", (r,n,i,weights[r,n,i]), (dr,dn,di,weights[dr,dn,di]) 
            weights[dr,dn,di] = zero()
            ind[dr,dn,di] = -2 # why -2, mark as removed?
            output_dup = True 
            in_ctr[dn] -= 1
            ictr += 1
            dup_rm += 1

        if (output_dup):
            out_ctr[n] -= 1
            octr += 1

    return dup_rm

# get_global_weight_idx
# inputs:
#   chunk index: (n,i) of the first weight in the chunk
#   chunk offset: r, n, i within the chunk
# returns:
#   the original index (n,i) of the weight in the Nn*Ni weight matrix
def get_global_weight_idx(chunk_n, chunk_i, r, n, i):
    ii = chunk_i + r*Ti
    gn = chunk_n + n
    gi = i + ii
    return (gn,gi)

def calc_buffer_next_reuse(buffer, key):
    (kn,ki) = (buffer[key][0],key[1])
    return chunk.n_i_to_cycle(kn,ki,Nn,Ni,Tnn,Tii,Tn,Ti)

# buffer functions
# I should make a buffer class at some point

# checks if key (w,i) is buffered
# inputs:   (w,i) buffer key
# returns:  the way it is stored in or -1 if not found
def buffer_check(w,i):
    # which set does this 
    set = i % n_sets
    w = map_weight(w)

    for way in range(n_ways):
        if (w,i) in buffer[set][way]:
            return way
    return -1

# inserts a new product into the buffer
# inputs    w   weight
#           gi  global i
#           gn  global n
#           n   local n (which 
# returns   true if buffer was updated
def buffer_insert(w,gi,gn,n):
    global glob_dups
    global removed_dups
    global forwarded_dups
    global buffer
    global glob_max_buffer_size 
    global reuse_cycle
    global total_dups_per_row
    global buffer_size

    set = gi % n_sets
    way = n % n_ways

    # will this product be reused?
    if (not (w,gi) in glob_dups):
        print "buffer_insert(%f,%d) not in glob_dups" % (w,gi)
        sys.exit()
    try:
        nidx = glob_dups[(w,gi)].index(gn) 
    except ValueError:
        return False
    if ( nidx == len(glob_dups[(w,gi)])-1 ):
        # last duplicate in list, don't save
        return False

    # get the remaining duplicates
    dups = list(glob_dups[(w,gi)][nidx+1:])
    # can the duplicates be forwarded this cycle?
    dups_this_row = 0
    for d in dups[:]:
        # duplicates issued this chunk:
        if gn/Tn == d/Tn:
            dups.remove(d)

    if ( len(dups) == 0 ):
        # all duplicates forwarded
        return False

    # if there are still duplicates in the future
    # add to buffer

    keys = buffer[set][way].keys()
    set_size = buffer_size/n_sets/n_ways;
    if (len(keys) >= set_size):
        # buffer is full
        #continue # dont evict ever
        
        # find an eviction candidate
        # policy: longest next reuse
        victim_c = -1
        victim_key = []

        for key in keys:
            (kn,ki) = (buffer[set][way][key][0],key[1])
            next_c = reuse_cycle[set][way][key]
            if next_c > victim_c:
                victim_c = next_c
                victim_key = key

        # if victim has longer reuse than the current dup, replace it
        replacement_c = chunk.n_i_to_cycle(dups[0], gi, Nn, Ni,Tnn,Tii,Tn,Ti)
        if (victim_c > replacement_c):
            #print "deleting", victim_key[0], victim_key[1]
            del buffer[set][way][victim_key]
            del reuse_cycle[set][way][victim_key]
        else:
            return False #don't add replacement to the list

    # update buffer
    buffer[set][way][(w,gi)] = dups
    reuse_cycle[set][way][(w,gi)] = calc_buffer_next_reuse(buffer[set][way], (w,gi))

    glob_max_buffer_size = max(glob_max_buffer_size, len(buffer[set][way].keys()))
    return True

def buffer_reuse(w,gn,gi):
    global buffer
    global reuse_cycle
    global removed_dups

    found_way = buffer_check(w,gi)
    set = gi % n_sets
    
    if ( found_way < 0 ):
        return False

    if (gn not in buffer[set][found_way][(w,gi)]):
        return False # this product was forwarded by a previous operation

    # remove current key
    buffer[set][found_way][(w,gi)].remove(gn)
    removed_dups += 1

    # have all the duplicates been forwarded?
    if len(buffer[set][found_way][(w,gi)]) == 0:
        # get rid of this entry in the buffer
        del buffer[set][found_way][(w,gi)]
        del reuse_cycle[set][found_way][(w,gi)]
    else:
        # update the next reuse cycle
        reuse_cycle[set][found_way][(w,gi)] = calc_buffer_next_reuse(buffer[set][found_way], (w,gi))
    return True

def buffer_clear(gn,gi):
    global buffer
    global reuse_cycle
    for w in range(n_ways):
        for s in range(n_sets):
            for key in buffer[s][w].keys():
                weight,i=key
                while i/Ti == gi/Ti and len(buffer[s][w][key]) and buffer[s][w][key][0]/Tn == gn/Tn:
                    buffer[s][w][key].pop(0)
                if len(buffer[s][w][key]) > 0:
                    reuse_cycle[s][w][key] = calc_buffer_next_reuse(buffer[s][w], key)
                else:
                    del buffer[s][w][key]
                    del reuse_cycle[s][w][key]

def buffer_update_for_row(weights, weight_idx, r):
    global buffer
    global reuse_cycle
    chunk_n, chunk_i = weight_idx

    # recalculate global index
    (R,Tn,Ti) = weights.shape

    for n in range(Tn):
        for i in range(Ti):
            w = map_weight(weights[r,n,i])
            
            # forward buffered products at the beginning of a new output tile
            #if (i/Tii == 0 and n/Tn == 0):
            #    # start of new partial sum calculation
            #    for tw in range(n_ways):
            #        for ts in range(n_sets):
            #            for key in buffer[ts][tw].keys():
            #                for tn in buffer[ts][tw][key]:
            #                    if tn/Tn == n/Tn:
            #                        buffer[ts][tw][key].remove(tn)
            #                if len(buffer[ts][tw][key]) == 0:
            #                    # get rid of this entry in the buffer
            #                    #print "deleting", w, gi
            #                    del buffer[ts][tw][key]
            #                    del reuse_cycle[ts][tw][key]
            #                else:
            #                    reuse_cycle[ts][tw][key] = calc_buffer_next_reuse(buffer[ts][tw], key)
            #            

            # ignore zero weights
            if (w == 0):
                continue

            (gn,gi) = get_global_weight_idx(chunk_n, chunk_i, r, n, i)

            # is this a duplicate?
            if ( (w,gi) in glob_dups and len(glob_dups[(w,gi)]) > 1):
                #if gi == 0:
                #    print "dup: ", gn, gi, w
                # is the product already in the buffer
                found = buffer_reuse(w,gn,gi)
                if not found:
                    # product is not stored in the buffer
                    buffer_insert(w,gi,gn,n)

    (gn,gi) = get_global_weight_idx(chunk_n, chunk_i, r, 0, 0)
    buffer_clear(gn,gi)

# this function analyzes duplicates, but doesn't actually remove them from weights
def process_weights(weights, weight_idx, lookaside, lookahead, out_limit, in_limit):

    # recalculate global index
    (R,Tn,Ti) = weights.shape
    global total_rows 
    total_rows += R

    # iterate in chunk order and save duplicate values
    for r in range(R):
        buffer_update_for_row(weights, weight_idx, r)
    return

#################################################################################

# returns a list of duplicates in the current chunk
def look_for_live_dups(weights, ind, r, dup_map, dup_found):
    dup_found_iter = []
    for n in range(0,Tn):
        for i in range(0,Ti):
            # look for duplicates only if we haven't looked at it before
            w = map_weight(weights[r,n,i])
            key = (ind[r,n,i][0], ind[r,n,i][2], w)
            if ( key not in dup_found and not is_zero(weights[r,n,i]) ):

                # dup_index is list of duplicates for (r,n,i) 
                dup_index = look_for_duplicates(r, n, i, weights, ind, dup_map)
                dup_found.add(key)
                if ( len(dup_index) > 0 ):
                    dup_found_iter.append(dup_index)

    return dup_found_iter

# removes the duplicates in dup_found_iter in order, if possible
def remove_dups(weights, ind, r, dup_found_iter, in_ctr, out_ctr, group_out_ctr):
    for dup_list in dup_found_iter:
        # for each set of duplicates
        # first dup that can be issued (in the current row) will be issued, rest will be removed
        for index in dup_list:

            # this is the producer
            (rr,nn,ii) = index 

            # only output if the index is on the current row
            # producer needs to allocate before consumers are removed
            # this doesn't make sense, all duplicates are being calculated this cycle
            #if (r != rr):
            #   continue   

            # make sure it has not exceeded group's output limit
            if ( group_out_ctr[nn/group_size] == 0 ):
               continue

            # remove all other duplicates if possible
            dup_rm_i = remove_duplicates(rr, nn, ii, weights, ind, dup_list, out_ctr, in_ctr)
            global dup_rm
            dup_rm += dup_rm_i

            # exit when a remove succeeded
            if (dup_rm_i):
               group_out_ctr[nn/group_size] -= 1
               break

# removed duplicates and zeros from a chunk of weights
def process_chunk(weights, weight_idx, lookaside, lookahead, out_limit, in_limit):

    chunk_n, chunk_i = weight_idx

    zero_rows = 0;

    # recalculate global index
    (R,Tn,Ti) = weights.shape

    # store the original indices of each weight in weights
    ind = np.indices((R,Tn,Ti)).swapaxes(0,3).swapaxes(0,2).swapaxes(0,1)

    # this generates a count of the duplicates for each key within the chunk
    dup_map = map_duplicates(weights)

    dup_bubble = 0 # ignore
    dup_bubble_pop = 0 # ignore

    global out_b
    global group_size
    global glob_dups

    # for each row
    #   while changes
    #       remove duplicates
    #       fill zeros
    for r in range(0,R):

        # check for all zeros
        if ( is_zero( weights[r,:,:] ) ):
            # print r # print all lines that are all zeroes
            zero_rows += 1
            continue

        # counter for the limits
        in_ctr = [in_limit] * Tn # input limit per filter (m), max inputs to adder tree
        out_ctr = [out_limit] * Ti # number of products that can be broadcast for an input i
        group_out_ctr = [out_b] * (Tn / group_size) # number of products that can be broadcast for an input i
        ictr = 0 # number of products reused
        octr = 0 # number of products broadcast
        changed = True
        dup_found = set() # track the duplicates found so we don't double count them

        # fill bubbles
        # how are stats maintained across iterations?
        # are we potentially double promoting beyond the lookahead window?
        while changed:
            changed = False

            # look for buffered duplicates broadcasting to this row

            # list of list of duplicate indicies
            # [[ (r,n,i) ]]
            dup_found_iter = look_for_live_dups(weights, ind, r, dup_map, dup_found)
            # add duplicate products already stored in the buffer

            # for testing
            # buffer[0][0][(map_weight(weights[0,0,0]),0)] = [0]
            for dup_set in dup_found_iter[:]:
                (cr,cn,ci) = dup_set[0]
                w = weights[cr,cn,ci]
            
                (orig_r, orig_n, orig_i) = ind[cr,cn,ci]
                (gn,gi) = get_global_weight_idx(chunk_n, chunk_i, orig_r, orig_n, orig_i)
                way =  buffer_check(w,gi)

                # add buffered duplicates to list as (-1,way,set) 
                if ( way >= 0 ):
                    s = gi % n_sets
                    dup_set.insert( 0, (-1,cn,ci) ) #FIXME: cn,ci are placeholders, we need to do something different for the buffer config

                # remove singletons 
                if (len(dup_set) == 1):
                    dup_found_iter.remove(dup_set) 
            
            # now we have a list of list of duplicates in the current row and buffer
            # if a duplicate is in the buffer then it is stored as (-1,n,i)
            
            # choose a producer for each set of duplicates and put it at the front of the set

            # simple heuristic to choose producer
            #   1. choose buffered product
            #   2. choose the first live dup
            #   this will happen natural since buffered products are added to the front of the list

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
            remove_dups(weights, ind, r, dup_found_iter, in_ctr, out_ctr, group_out_ctr)

            # this may create a zero row, but we can't skip it since we've used this cycle to do all this stuff

            # remove all the zeros in the row
            for n in range(0,Tn):
                for i in range(0,Ti):
    
                    # fill in the bubble
                    if ( is_zero( weights[r,n,i] )):
                        orig_zero =  ( (r,n,i) == ind[r,n,i] ).all()
                        # found a zero to fill, look for replacement
                        zero_removed = re.look_for_replacement( r, n, i, weights, ind, lookaside, lookahead)
                        global zero_rm
                        if orig_zero:
                            zero_rm += zero_removed
                        changed = changed or zero_removed
   
        # end of change loop

        # now we know which products will be calculated this cycle

        # for all buffered dups that were not forwarded, remove them from the buffer list

        # update the buffer with new products produced in this cycle (row)
        buffer_update_for_row(weights, weight_idx, r)

    # end of row loop

    global total_reduced_rows 
    total_reduced_rows += R - zero_rows
    global total_rows 
    total_rows += R

# generate list of all duplicates in filter
# use tiling to append n's in execution order
# inputs:
#   w           Nn x Ni matrix of weights
# returns:
#   glob_dups   a dictionary that maps (weight,i)->[list of duplicate n's]
def build_dups(w):
    cycle=0
    for nnn in range(0, Nn, Tnn):
        for iii in range(0, Ni, Tii):
            for nn in range(nnn, min(nnn+Tnn,Nn), Tn):
                for ii in range(iii, min(iii+Tii,Ni), Ti):
                    for n in range(nn, min(nn+Tn,Nn), 1):
                        for i in range(ii, min(ii+Ti,Ni), 1):
                            weight = map_weight(w[n,i])
                            if (weight == 0):
                                continue
                            if ( not (weight,i) in glob_dups ):
                                glob_dups[(weight,i)] = []
                            glob_dups[(weight,i)].append(n)
                            #glob_dups[(weight,i)].append((n,cycle))
                    cycle += 1
    # delete singletons
    for k in glob_dups.keys():
        (kw,ki) = k
        n_list = glob_dups[k]
        if (len(n_list) == 1):
            del glob_dups[k]
            continue
    return glob_dups

######### MAIN ################################################################

args = sys.argv
script      = args.pop(0)
filename    = args.pop(0)
lookaside   = int(args.pop(0))
lookahead   = int(args.pop(0))
out_limit   = int(args.pop(0))
in_limit    = int(args.pop(0))
group_size  = int(args.pop(0))
out_b       = int(args.pop(0))
buffer_size = int(args.pop(0))
n_sets      = int(args.pop(0))
n_ways      = int(args.pop(0))
Tii         = int(args.pop(0))
negatives_are_dups = True

Ti=16
Tn=16
Tnn=1024

#print "read filter file"
# w is an Nn x Ni ndarray of weights
w = read_filters.read_filters(filename)

#Nn = 32
#Ni = 2048
#w = np.zeros((Nn,Ni))
#w = np.arange(Nn*Ni).reshape((Nn,Ni))
#w[0,0] = 1
#w[1,0] = w[0,0]
#w[16,0] = w[0,0]
#print w

(Nn, Ni) = w.shape

num_zeros = np.sum( w == 0 )

#print w.shape

glob_weights = w
glob_dups = {}
glob_max_buffer_size = 0

total_dups = 0 # total number of duplicates not including the original 
removed_dups = 0
forwarded_dups = 0
total_dups_per_row = 0
zero_rm = 0
dup_rm = 0
ictr = 0
octr = 0

# buffer[set][way][(w,i)]->[list of duplicates]
buffer =        [[{} for i in range(n_ways)] for j in range(n_sets)]
reuse_cycle =   [[{} for i in range(n_ways)] for j in range(n_sets)]

glob_dups = build_dups(w)

# get total # duplicates
for key in glob_dups:
    total_dups += len(glob_dups[key])-1 # don't count the first duplicate (producer)

total_dup_lists = len(glob_dups)
avg_dup_list_len = np.float64(total_dups)/total_dup_lists

# chunks is a list of Nrows * Tn * Ti weight ndarrays
(chunks, chunk_idxs) = chunk.chunk(w,Nn,Ni,Tnn,Tii,Tn,Ti)

#print "processing each chunk"
np.set_printoptions(threshold=np.inf)
for (c, c_idx) in zip(chunks, chunk_idxs):
#    process_weights(c, c_idx, lookaside, lookahead, out_limit, in_limit)
    process_chunk(c, c_idx, lookaside, lookahead, out_limit, in_limit)

avg_dups_per_row = np.float64(total_dups_per_row)/(total_rows*Ti)

# Print stats

# NOTE zero_rm  includes zeros created by removed dups

#cols = (filename, avg_dup_list_len, avg_dups_per_row, total_rows)
cols = (filename, lookaside, lookahead, out_limit, in_limit, group_size, out_b, zero_rm, dup_rm, total_dups, total_reduced_rows, total_rows)
#cols = (filename, lookaside, lookahead, out_limit, in_limit, removed_dups, total_dups)
#cols = (filename, lookaside, lookahead, out_limit, in_limit, forwarded_dups, removed_dups, total_dups, glob_max_buffer_size)
for c in cols:
    if (type(c) is float):
        print "%.2f," % c, 
    elif (type(c) is int):
        print "%d," % c, 
    else:
        print "%s," % c, 



