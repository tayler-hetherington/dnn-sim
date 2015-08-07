#!/usr/bin/python
# break weights up into chunks that contribute to one
# sequential partial sum in NBout

import numpy as np
import math

def chunk(weights):
    Tn = 16
    Ti = 16
    Tnn = 1024
    Tii = 1024
    Nn, Ni = weights.shape

    chunks = []
    chunk_idx = []

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
