#define FILTER_FILE "../input/conv2-filters-8bit.csv"
#define data_c 48
#define data_h 1
#define data_n 1
#define kernel_size 5
#define stride 1
#define weight_n 256
#define PAD 2
#define Ti 16    // data elements per row in NBin
#define Tn 16    // data elements per row in NBout
#define Tnn 1024 // number of data elements in NBout
#define Tii 1024 // number of data elements in NBin
#define Tx stride
#define Ty stride
