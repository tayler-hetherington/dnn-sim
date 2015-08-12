#!/usr/bin/python
# break weights up into chunks that contribute to one
# sequential partial sum in NBout

import numpy as np
import math
import sys

def n_i_to_cycle(n,i,Nn,Ni,Tnn,Tii,Tn,Ti):
    # one cycles processes Ti inputs and produces Tn outputs
    ii = i/Ti
    nn = n/Tn
    #print Tii
    # think in terms of tiles of rows
    Rnn = int( math.ceil(min(Tnn,Nn+0.0)/Tn) )
    Rii = int( math.ceil(min(Tii,Ni+0.0)/Ti) ) 

    Nri = Ni/Ti
    Nrn = Nn/Tn
    

    # now everything is in terms of Ti*Tn tiles

    # tile indicies (top left corner)
    iii = ii/Rii*Rii
    nnn = nn/Rnn*Rnn

    # height/width of this tile:
    Hii = min(Rii, Nri - iii)
    Wnn = min(Rnn, Nrn - nnn)

    # offsets within a tile
    dnn = nn-nnn
    dii = ii-iii
    
#    print "ii =",ii,"nn =",nn,"Rii =",Rii,"Rnn =",Rnn,"Nri =",Nri,"Nrn =",Nrn,"iii =",iii,"nnn =",nnn,"Hii =",Hii,"Wnn =",Wnn,"dnn =",dnn,"dii =",dii
#    print nnn,"*",Nri,"+",iii,"*",Rnn,"+",dnn,"*",Hii,"+",dii
    cycle = nnn*Nri + iii*Rnn + dnn*Hii + dii
    return cycle

def chunk(weights,Nn,Ni,Tnn,Tii,Tn,Ti):
    Nn, Ni = weights.shape

    chunks = []
    chunk_idx = []

    c=0
    for nnn in range(0, Nn, Tnn):
        for iii in range(0, Ni, Tii):

            # one pass of NBout
            for nn in range(nnn, min(nnn+Tnn,Nn), Tn):

                rows = math.ceil( float(min(Tii, Ni-iii)) / Ti )
                chunk = np.zeros((rows, Tn, Ti))

                # one pass of NBin
                for ii in range(iii, min(iii+Tii,Ni), Ti):

                    # one row
                    r = (ii-iii)/Ti
                    for n in range(nn, min(nn+Tn,Nn), 1):
                        cn = n-nn
                        for i in range(ii, min(ii+Ti,Ni), 1):
                            # sum[n] += synapse[n][i] * neuron[i]
                            ci = i-ii
                            chunk[r,cn,ci] = weights[n,i]

                chunks.append(chunk)
                chunk_idx.append((nn,iii))
    return (chunks, chunk_idx)

# test program
#Nn=256
#Ni=1200
#args = sys.argv
#script = args.pop(0)
#Tii = int(args.pop(0))
#Tnn = 16
#print "n i c"
##for n in range(0,Nn,16):
##    for i in range(0,Ni,16):
##        c = n_i_to_cycle(n,i,Nn,Ni)
##        print n/16,i/16,c
#i=1057
#n=1
#c = n_i_to_cycle(n,i,Nn,Ni)
#print n,i,c
#n=18
#c = n_i_to_cycle(n,i,Nn,Ni)
#print n,i,c

