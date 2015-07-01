#ifndef __DNN_CONFIG_H__
#define __DNN_CONFIG_H__

#include "common.h"
#include "option_parser.h"

class dnn_config {
    
public:
    dnn_config(){};
    ~dnn_config(){};
    
    void reg_options(option_parser_t opp);
    
    // SB
    unsigned sb_line_length;
    unsigned sb_num_lines;
    unsigned sb_access_cycles;

    // NBin
    unsigned nbin_line_length;
    unsigned nbin_num_lines;
    unsigned nbin_access_cycles;
    
    // NBout
    unsigned nbout_line_length;
    unsigned nbout_num_lines;
    unsigned nbout_access_cycles;
    
    // NFU-1
    unsigned num_nfu1_pipeline_stages;

    // NFU-2
    unsigned num_nfu2_pipeline_stages;
    
    // NFU-3    
    unsigned num_nfu3_pipeline_stages;
    
    // Bit-width
    unsigned bit_width;


};

#endif