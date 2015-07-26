#include <stdio.h>

#include "config.h"

typedef float T;

#include "read_filters.cpp"

int main(int argc, char** argv){

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

    printf("Nxo = %d\n", Nxout);
    printf("Nyo = %d\n", Nyout);

    int synapseSize = Kx*Ky*Nn*Ni;
    int neuronSize = Ax*Ay*Ni;
    int neuronOutSize = Nyout*Nxout*No;
    
    printf("synapse size = %d\n", synapseSize);
    printf("neuron size = %d\n", neuronSize);
    printf("neuronOut size = %d\n", neuronOutSize);

    //printf("datasize = %d Bytes\n", sizeof(T));

    T * sum = new T[Nn];
    T * synapse = new T [synapseSize];
    T * neuron = new T [neuronSize];
    T * neuron_out = new T [neuronOutSize];


    for (int i=0; i<synapseSize; i++){
        synapse[i] = i;
    }
    for (int i=0; i<neuronSize; i++){
        neuron[i] = 1;
    }

    read_filters(FILTER_FILE, synapse, synapseSize);

    int count = 0;

    int yout = 0;
    for (int yy = 0; yy <= Ax-Ky; yy += Ty) { // tile x
        int xout = 0;
        for (int xx = 0; xx <= Ay-Kx; xx += Tx) { // tile y
            for (int nnn = 0; nnn < Nn; nnn += Tnn) { // tile n

                for (int y = yy; y < yy + Ty; y += sy) { // slide window in y
                    for (int x = xx; x < xx + Tx; x += sx) { // slide window in x
                        for (int nn = nnn; nn < nnn + Tnn; nn += Tn) { // tile for output buffer

                            // initialize sum
                            for (int n = nn; n < nn + Tn; n++) {
                                sum[n] = 0;
                            }
                            
                            int rowCounter = 0;
                            for (int ky = 0; ky < Ky; ky++){ // y position in window
                                for (int kx = 0; kx < Kx; kx++){ // x position in window
                                    for (int ii = 0; ii < Ni; ii += Ti){
                                        
                                        int rowIdx = (ky * Kx + kx) * Ni + ii;
                                        printf ("rowIdx=%d\n", rowIdx);
                                        

                                        // These loops happen in parallel in one pipe_op:
                                        for (int n = nn; (n < nn + Tn) && (n < Nn); n++){
                                            for (int i = ii; (i < ii + Ti) && (i < Ni); i++){
                                                // version with shared kernels

                                                //sum[n] += synapse[ky][kx][n][i] * neuron[ky + y][kx + x][i];
                                                int sIdx = ( (ky*Kx +  kx) * Nn + n ) * Ni + i;
                                                int nIdx = ( (ky+y) * Ax + (kx+x) ) * Ni +  i;
                                                sum[n] += synapse[sIdx] * neuron[nIdx];
                                                
                                                count++;

                                                // check for NaN
                                                if (isnan(synapse[sIdx])){
                                                    printf("synapse %d is NaN\n",sIdx);
                                                    return 0;
                                                }
                                                if (isnan(neuron[nIdx])){
                                                    printf("neuron %d (%d,%d,%d) is NaN\n", nIdx, kx, ky, i);
                                                    return 0;
                                                }

                                                //printf("sum=%f\n", sum[n]);           
                                                // version with private kernels
                                                //sum[n] += synapse[yout][xout][ky][kx][n][i] * neuron[ky + y][kx + x][i];
                                            }
                                        }
                                    }
                                }
                            }
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
    printf("number of multiplications: %d\n", count);
    for (int x = 0; x < Nxout; x++){
        for (int y = 0; y < Nyout; y++){
            printf("(%d,%d):", x, y);
            for (int n = 0; n < No; n++){
                int idx = (y * Nxout + x) * No + n;
                printf("%f,", neuron_out[idx]);
            }
            printf("\n");
        }
    }

    return 0;
}
