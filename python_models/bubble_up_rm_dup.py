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
def look_for_duplicates(r, n, i, weights, ind, dup_map, lookahead):
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
    look_in_n.remove(pn)

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
                if (len(dup_index) == dup_map[dup_key] - 1):
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
    dup_rm = 0  # duplicates removed
    dup_bubble = 0  # not used
    dup_bubble_pop = 0  # not used
    ictr = 0 #input counter (stage 2 collecting mux)
    octr = 0 #output counter (stage 1 broadcasting mux)

    # reached output limit for this cycle
    # or can't fill in the bubble
    if ( out_ctr[n] > 0 and not is_zero( weights[r,n,i] )):

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

    stat = [dup_rm, dup_bubble, dup_bubble_pop, ictr, octr]
    return stat

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

# this function analyzes duplicates, but doesn't actually remove them from weights
def process_weights(weights, weight_idx, lookaside, lookahead, out_limit, in_limit):
    chunk_n, chunk_i = weight_idx
    #print "chunk:", chunk_n, chunk_i
    zero_rows = 0;

    # recalculate global index
    (R,Tn,Ti) = weights.shape
    global total_rows 
    total_rows += R
    ind = np.indices((R,Tn,Ti)).swapaxes(0,3).swapaxes(0,2).swapaxes(0,1)

    
    dup_map = map_duplicates(weights)

    out_per_row =       [0] * (Ti+1)
    in_per_row =        [0] * (Tn+1)
    out_res_per_row =   [0] * (Ti+1)
    in_res_per_row =    [0] * (Tn+1)

    zero_rm = 0 # number of zeros removed
    dup_rm = 0 # number of dups removed
    dup_bubble = 0 # ignore
    dup_bubble_pop = 0 # ignore

    global glob_dups
    global removed_dups
    global forwarded_dups
    global buffer
    global glob_max_buffer_size 
    global next_c_dict

    # iterate in chunk order and save duplicate values
    for r in range(R):
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
                #                    del next_c_dict[ts][tw][key]
                #                else:
                #                    next_c_dict[ts][tw][key] = calc_buffer_next_reuse(buffer[ts][tw], key)
                #            

                if (w == 0):
                    continue

                # which set does this 
                set = i % n_sets
                way = n % n_ways

                assert len(buffer[set][way].keys()) == len(next_c_dict[set][way].keys())

                (gn,gi) = get_global_weight_idx(chunk_n, chunk_i, r, n, i)

                # is this a duplicate?
                if ( (w,gi) in glob_dups and len(glob_dups[(w,gi)]) > 1):
                    #if gi == 0:
                    #    print "dup: ", gn, gi, w
                    # is the product already in the buffer
                    found_way = -1
                    for tw in range(n_ways):
                        if (w,gi) in buffer[set][tw]:
                            found_way = tw

                    if found_way >= 0:
                        if (gn not in buffer[set][found_way][(w,gi)]):
                            continue # this product was forwarded by a previous operation
                        
                        if gn != buffer[set][found_way][(w,gi)][0]:
                            print "gn = %d but list[0] = %d" % (gn , buffer[set][found_way][(w,gi)][0])

                        # remove current key
                        buffer[set][found_way][(w,gi)].remove(gn)
                        removed_dups += 1
                        # print "removed",w,gn,gi
                        # have all the duplicates been forwarded?
                        if len(buffer[set][found_way][(w,gi)]) == 0:
                            # get rid of this entry in the buffer
                            #print "deleting", w, gi
                            del buffer[set][found_way][(w,gi)]
                            del next_c_dict[set][found_way][(w,gi)]
                        else:
                            next_c_dict[set][found_way][(w,gi)] = calc_buffer_next_reuse(buffer[set][found_way], (w,gi))
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
                        dups_copy = list(dups)
                        dups_this_row = 0
                        for d in dups_copy:
                            # duplicates issued this cycle:
                            if gn/Tn == d/Tn:
                                forwarded_dups += 1
                                removed_dups += 1
                                dups_this_row += 1
                                # remove from global dups list 
                                glob_dups[(w,gi)].remove(d)
                                dups.remove(d)
                                #print 'forward', w, gi, d 
                                weights[r, d % Tn ,i] = 0
                                #print 'forward', w, gi, gn, '->', d

                        global total_dups_per_row
                        total_dups_per_row += dups_this_row
                        if ( len(dups) == 0 ):
                            # all duplicates forwarded
                            continue

                        #continue # no buffering
                        # if there are still duplicates in the future
                        # add to buffer
                        global buffer_size

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
                                next_c = next_c_dict[set][way][key]
                                if next_c > victim_c:
                                    victim_c = next_c
                                    victim_key = key
#                            print "n =",gn, "evicting", buffer[victim_key]

                            # if victim has longer reuse than the current dup, replace it
                            replacement_c = chunk.n_i_to_cycle(dups[0], gi, Nn, Ni,Tnn,Tii,Tn,Ti)
                            if (victim_c > replacement_c):
                                #print "deleting", victim_key[0], victim_key[1]
                                del buffer[set][way][victim_key]
                                del next_c_dict[set][way][my_hash(victim_key)]
                            else:
                                continue #don't add replacement to the list

                        # add buffer entry
                        #print "adding", w, gi
                        #dups.pop(0)
                        buffer[set][way][(w,gi)] = dups
                        #if gi == 0:
                        #    print "adding dups to buffer", dups 
                        next_c_dict[set][way][my_hash((w,gi))] = calc_buffer_next_reuse(buffer[set][way], (w,gi))
                        glob_max_buffer_size = max(glob_max_buffer_size, len(buffer[set][way].keys()))
    return

#################################################################################

# removed duplicates and zeros from a chunk of weights
def process_chunk(weights, weight_idx, lookaside, lookahead, out_limit, in_limit):

    chunk_n, chunk_i = weight_idx
    #print "chunk:", chunk_n, chunk_i
    zero_rows = 0;

    # recalculate global index
    (R,Tn,Ti) = weights.shape

    # store the original indices of each weight in weights
    ind = np.indices((R,Tn,Ti)).swapaxes(0,3).swapaxes(0,2).swapaxes(0,1)

    # this generates a count of the duplicates for each key within the chunk
    dup_map = map_duplicates(weights)

    out_per_row =       [0] * (Ti+1)
    in_per_row =        [0] * (Tn+1)
    out_res_per_row =   [0] * (Ti+1)
    in_res_per_row =    [0] * (Tn+1)

    zero_rm = 0 # number of zeros removed
    dup_rm = 0 # number of dups removed
    dup_bubble = 0 # ignore
    dup_bubble_pop = 0 # ignore

    global out_b
    global group_size

    # for each row
    #   while changes
    #       remove duplicates
    #       fill zeros
    for r in range(0,R-1):
        rmax = min(r + lookahead , R-1 )

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
        ires = 0 # ignore
        ores = 0 # ignore
        changed = True
        dup_found = set()

        # fill bubbles
        # how are stats maintained across iterations?
        # are we potentially double promoting beyond the lookahead window?
        while changed:
            changed = False

            # list of list of duplicate indicies
            # [[ (r,n,i) ]]
            dup_found_iter = []
            # look for duplicates
            for n in range(0,Tn):
                for i in range(0,Ti):
                    # look for duplicates only if we haven't looked at it before
                    w = map_weight(weights[r,n,i])
                    key = (ind[r,n,i][0], ind[r,n,i][2], w)
                    if ( key not in dup_found and not is_zero(weights[r,n,i]) ):

                        # dup_index is list of duplicates for (r,n,i) (not including producer)
                        dup_index = look_for_duplicates(r, n, i, weights, ind, dup_map, lookahead)
                        dup_found.add(key)
                        if ( len(dup_index) > 0 ):
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

                    # this is the producer
                    (rr,nn,ii) = index 

                    # only output if the index is on the current row
                    if (r != rr):
                       continue   

                    # make sure it has not exceeded group's output limit
                    if ( group_out_ctr[nn/group_size] == 0 ):
                       continue
 
                    # remove all other duplicates if possible
                    stats = remove_duplicates(rr, nn, ii, weights, ind, dup_list, out_ctr, in_ctr)
                    [dup_rm_i, dup_bubble_i, dup_bubble_pop_i, ictr_i, octr_i] = stats
                    dup_rm          += dup_rm_i
                    dup_bubble      += dup_bubble_i
                    dup_bubble_pop  += dup_bubble_pop_i
                    ictr            += ictr_i
                    octr            += octr_i

                    # exit when a remove succeeded
                    if (dup_rm_i):
                       group_out_ctr[nn/group_size] -= 1
                       break

            # remove duplicates from buffer here
            # when we forward a buffered duplicate, remove the corresponding weight
            # this gets lower priority since we can do it any time within the chunk
            
            # this may create a zero row, but we can't skip it since we've used this cycle to do all this stuff




            # NOTE: we don't have to check for a row of zeros again, since at least have producers in this row
            # remove all the bubbles in the row
            for n in range(0,Tn):
                for i in range(0,Ti):
    
                    # fill in the bubble
                    if ( is_zero( weights[r,n,i] )):
                        # found a zero to fill, look for replacement
                        (weights, ind, tmp) = re.look_for_replacement( r, n, i, weights, ind, lookaside, lookahead)
                        zero_rm += tmp
                        changed = changed or tmp
            
            # add producers to buffer here
   
   
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

    return (zero_rm, dup_rm)

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

# buffer[set][way][(w,i)]->[list of duplicates]
buffer =        [[{} for i in range(n_ways)] for j in range(n_sets)]
next_c_dict =   [[{} for i in range(n_ways)] for j in range(n_sets)]

glob_dups = build_dups(w)

# get total # duplicates
for key in glob_dups:
    total_dups += len(glob_dups[key])-1 # don't count the first duplicate (producer)

total_dup_lists = len(glob_dups)
avg_dup_list_len = float(total_dups)/total_dup_lists

# chunks is a list of Nrows * Tn * Ti weight ndarrays
(chunks, chunk_idxs) = chunk.chunk(w,Nn,Ni,Tnn,Tii,Tn,Ti)

#print "processing each chunk"
np.set_printoptions(threshold=np.inf)
zero_rm = 0
dup_rm = 0
for (c, c_idx) in zip(chunks, chunk_idxs):
#    process_weights(c, c_idx, lookaside, lookahead, out_limit, in_limit)
    (z,r) = process_chunk(c, c_idx, lookaside, lookahead, out_limit, in_limit)
    zero_rm += z
    dup_rm += r

avg_dups_per_row = float(total_dups_per_row)/(total_rows*Ti)

# Print stats

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



