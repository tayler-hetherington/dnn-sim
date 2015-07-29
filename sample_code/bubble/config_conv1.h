#define FILTER_FILE "../input/conv1-filters-8bit.csv"
#define data_c 3
#define data_h 11
#define data_n 1
#define kernel_size 11
#define stride 4
#define weight_n 96
#define PAD 0
#define Ti 16    // data elements per row in NBin
#define Tn 16    // data elements per row in NBout
#define Tnn 1024 // number of data elements in NBout
#define Tx stride
#define Ty stride
