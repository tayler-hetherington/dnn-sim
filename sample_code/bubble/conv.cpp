#include <stdio.h>
#include <algorithm>

#include "config_conv2.h"

typedef float T;

#include "read_filters.cpp"

#define BUBBLEUP 0
#define PRINT_BITMAP 1
#define PRINT_STATS 0
#define DEBUG 0

// Caffe parameters to DianNao Kernel parameters 
int Nxin = data_h;
int Nyin = data_h;
int Kx = kernel_size;
int Ky = kernel_size;
int sx = stride;
int sy = stride;

int Ni = data_c; // also weight_c
int Nn = weight_n;

int No = Nn;

// apron for convolution corner conditions
int Ax = Nxin+2*PAD;
int Ay = Nyin+2*PAD;

int Nxout = (Ax - Kx)/sx + 1;
int Nyout = (Ay - Ky)/sy + 1;

// input
//      l   linear index
//  returns
//      &kx kernel index x
//      &ky kernel index y
//      &ki kernel index i
void get_3d_idx(int l, int & ky, int & kx, int & ki){
    ky = l / (Ni * Kx);
    l -= ky * Ni * Kx;
    kx = l / Ni;
    l -= kx * Ni;
    ki = l;
}

int main(int argc, char** argv){

    int synapseSize = Kx*Ky*Nn*Ni;
    int neuronSize = Ax*Ay*Ni;
    int neuronOutSize = Nyout*Nxout*No;

    if (PRINT_STATS){
        printf("Nxo = %d\n", Nxout);
        printf("Nyo = %d\n", Nyout);
        printf("synapse size = %d\n", synapseSize);
        printf("neuron size = %d\n", neuronSize);
        printf("neuronOut size = %d\n", neuronOutSize);
        printf("datasize = %d Bytes\n", sizeof(T));
    }

    T * sum = new T[Tnn];
    T * synapse = new T[synapseSize];
    T * neuron = new T[neuronSize];
    T * neuron_out = new T[neuronOutSize];

    int bufferCols[Tn][Ti];

    for (int i=0; i<synapseSize; i++){
        synapse[i] = i;
    }
    for (int i=0; i<neuronSize; i++){
        neuron[i] = i % 123;
    }

    int read = read_filters(FILTER_FILE, synapse, synapseSize);
    if (DEBUG) printf("read %d/%d filters\n", read, synapseSize);

    int count = 0;
    int cycle = 0;
    int zeroCount = 0;
    int zeroCollision = 0; // when a zero is replaced by another zero
    int zeroRows = 0; // when a whole row is 0

    int yout = 0;
    for (int yy = 0; yy <= Ax-Ky; yy += Ty) { // tile x
        //printf("yy=%d\n", yy);
        int xout = 0;
        for (int xx = 0; xx <= Ay-Kx; xx += Tx) { // tile y
            //printf("xx=%d\n", xx);
            for (int nnn = 0; nnn < Nn; nnn += Tnn) { // tile n for L1 cache
                //printf("nnn=%d\n", nnn);

                for (int y = yy; y < yy + Ty; y += sy) { // slide window in y
                    //printf("y=%d\n", y);
                    for (int x = xx; x < xx + Tx; x += sx) { // slide window in x
                        //printf("x=%d\n", x);

                        
                        // calculate outputs for one window with one Tnn of weights

                        // initialize sum
                        for (int nn = nnn; (nn < nnn + Tnn) && (nn < Nn); nn += Tn) { // tile for output buffer
                            for (int n = nn; n < nn + Tn; n++) {
                                sum[n] = 0;
                            }
                        }

                        for (int ll = 0; ll < Ky*Kx*Ni; ll += Tii){ // tiled for input buffer, ll = input chunk index
                            //printf("ll=%d\n",ll);

                            for (int nn = nnn; (nn < nnn + Tnn) && (nn < Nn); nn += Tn) { // tile for output buffer
                                //printf("nn=%d\n", nn);

                                int rowCounter = 0;
                                int chunkCount = 0;

                                // linearized index for kx, ky, ii

                                for (int i=0; i<Ti; i++){
                                    for (int n=0; n<Tn; n++){
                                        bufferCols[n][i] = 0;
                                    }
                                }
                                int endOfChunk = std::min( ll+Tii, Ky*Kx*Ni);
                                for (int l = ll; l < endOfChunk ; l += Ti) {
                                    int ky, kx, ii;
                                    get_3d_idx(l, ky, kx, ii); 

                                    // These loops happen in parallel in one pipe_op:
                                    if (DEBUG) {
                                        printf("%6d: sum[%2d] += synapse[%2d][%2d][%2d][%2d] * neuron[%2d][%2d][%2d]\n", 
                                                cycle++, nn,             ky,  kx,  nn,  ii,           ky+y,kx+x,ii);
                                    }
                                    bool last = l == endOfChunk - Ti;
                                    if (last){
                                        if (DEBUG) printf("last row\n");
                                    }
                                    rowCounter++; 
                                    bool zero_row = true; // the whole row of synapses is zero
                                    for (int n = nn; (n < nn + Tn) && (n < Nn); n++){
                                        for (int i = ii; (i < ii + Ti) && (i < Ni); i++){
                                            int sIdx = ( (ky*Kx +  kx) * Nn + n ) * Ni + i;
                                            if (synapse[sIdx] != 0) zero_row = false;
                                        }
                                    }
                                    if (zero_row){
                                        zeroRows++;
                                        continue;
                                    }

                                    for (int n = nn; (n < nn + Tn) && (n < Nn); n++){
                                        for (int i = ii; (i < ii + Ti) && (i < Ni); i++){

                                            //sum[n] += synapse[ky][kx][n][i] * neuron[ky + y][kx + x][i];
                                            int sIdx = ( (ky*Kx +  kx) * Nn + n ) * Ni + i;
                                            int nIdx = ( (ky+y) * Ax + (kx+x) ) * Ni + i;

                                            int tempNeuron = neuron[nIdx];
                                            
                                            if (synapse[sIdx] == 0)
                                            {
                                                if (PRINT_BITMAP) printf("0");
                                                zeroCount++;

                                                // look for non zero weights 
                                                if ( BUBBLEUP && ! last ) {
                                                    //next row
                                                    int ln = l + Ti;
                                                    int bky, bkx, bi;
                                                    get_3d_idx(ln, bky, bkx, bi);

                                                    //printf("bubble up synapse[%d][%d][%d][%d] and neuron[%d][%d][%d]\n", bky, bkx, n, bi, bky+y, bkx+x, bi);
                                                    int bsIdx = ( (bky*Kx +  bkx) * Nn + n ) * Ni + bi;
                                                    int bnIdx = ( (bky+y) * Ax + (bkx+x) ) * Ni + bi;
                                                    if (synapse[bsIdx] == 0){
                                                        zeroCollision++;
                                                    }
                                                    synapse[sIdx] = synapse[bsIdx];
                                                    synapse[bsIdx] = 0;
                                                    tempNeuron = neuron[bnIdx];
                                                }
                                            } else {
                                                if (PRINT_BITMAP) printf("1");
                                                bufferCols[n-nn][i-ii]++;
                                                zero_row = false;
                                            }
                                            //printf("synapse %d = %f\n", sIdx, synapse[sIdx]);

                                            sum[n] += synapse[sIdx] * tempNeuron;
//                                            printf("sum[%d] += synapse[%d][%d][%d][%d] * neuron[%d][%d][%d] = %f * %f \n", n, ky, kx, n, i, ky+y, kx+x, i, synapse[sIdx], neuron[nIdx]);

                                            count++;

                                        }
                                        if (PRINT_BITMAP) printf("|"); // seperator for different filter tiles
                                    }
                                    if (PRINT_BITMAP) printf("\n"); // end of line for SB row
                                    //zeroRows += zero_row;
                                }// for l
                                if (PRINT_BITMAP) printf("\n"); // print blank line between input chunks
                                    return 0;
                                if (PRINT_STATS){
                                    printf("total ones per column:\n");
                                    int max = 0;
                                    int min = 100000;
                                    for (int i=0; i<Ti; i++){
                                        for (int n=0; n<Tn; n++){
                                            printf("%d ", bufferCols[n][i]);
                                            if (bufferCols[n][i] > max) max = bufferCols[n][i];
                                            if (bufferCols[n][i] < min) min = bufferCols[n][i];
                                        }
                                    }
                                    printf("max = %d min = %d",max,min);
                                    printf("\n");
                                }

                            } // for nn

                        } // for ll

                        // store results in output buffer to DRAM
                        for (int nn = nnn; (nn < nnn + Tnn) && (nn < Nn); nn += Tn) { // tile for output buffer
                            for (int n = nn; (n < nn + Tn) && (n < Nn); n++){
                                //neuron_out[yout][xout][n] = sum[n];
                                int idx = (yout * Nxout + xout) * No + n;
                                neuron_out[idx] = sum[n];
                                //printf ("idx = %d\n", idx);
                            }
                        }
                    } 
                    xout++; 
                } 
                yout++;
            }
        }
    }
    if (PRINT_STATS){
        printf("multiplications:  %d\n", count);
        printf("zero weights:     %d\n", zeroCount);
        printf("zero collisions:  %d\n", zeroCollision);
        printf("zero rows:        %d\n", zeroRows);
    }
    if (DEBUG){
        for (int x = 0; x < Nxout; x++){
            for (int y = 0; y < Nyout; y++){
                for (int n = 0; n < No; n++){
                    int idx = (y * Nxout + x) * No + n;
                    printf("out %d:%f\n", idx, neuron_out[idx]);
                }
            }
        }
    }
    

    return 0;
}
