#ifndef __DNN_CONFIG_H__
#define __DNN_CONFIG_H__

#include "common.h"
#include "option_parser.h"

class dnn_config {
    
public:
    dnn_config(){};
    ~dnn_config(){};
    
    void reg_options(option_parser_t opp);
    
    // Bit-width
    unsigned bit_width;
    
    // Pipeline stage buffer size
    unsigned max_buffer_size;
    
    // SB
    unsigned sb_line_length;
    unsigned sb_num_lines;
    unsigned sb_access_cycles;
    unsigned sb_num_ports;

    // NBin
    unsigned nbin_line_length;
    unsigned nbin_num_lines;
    unsigned nbin_access_cycles;
    unsigned nbin_num_ports;
    
    // NBout
    unsigned nbout_line_length;
    unsigned nbout_num_lines;
    unsigned nbout_access_cycles;
    unsigned nbout_num_ports;
    
    // NFU-1
    unsigned num_nfu1_pipeline_stages;

    // NFU-2
    unsigned num_nfu2_pipeline_stages;
    
    // NFU-3    
    unsigned num_nfu3_pipeline_stages;
};

#endif