////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
// Tayler Hetherington
// 2015
// dnn_sim.h
// Main DNN simulator
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////

#ifndef __DNN_SIM__
#define __DNN_SIM__

#include "common.h"
#include "config.h"
#include "dram_interface.h"
#include "control_processor.h"
#include "datapath.h"
#include "cp_inst.h"

class dnn_sim {

public:

    dnn_sim(dnn_config *config);
    
    ~dnn_sim();

    void cycle(); // Top level cycle function.
    
    bool insert_op(pipe_op *op); // Keeping this for testing
    bool insert_inst(cp_inst *inst);
    bool is_test_done();

    void print_stats();

    bool read_instructions();
    

private:

    // Configs
    dnn_config *m_config;
    
    dram_interface *m_dram_interface;
    control_processor *m_control_processor;
    datapath *m_datapath;

    // Stats
    unsigned long long m_sim_cycle;
    
};

#endif // __DNN_SIM__
