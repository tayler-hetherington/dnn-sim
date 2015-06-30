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

#include "common.h"
#include "pipe_stage.h"
#include "sram_array.h"

class dnn_sim {

public:
    dnn_sim(unsigned num_stages, unsigned max_queue_size, unsigned bit_width);
    ~dnn_sim();

    void cycle(); // Top level cycle function.
    
    bool insert_op(pipe_op *op);
    void print_stats();
    
    // DEBUG
    void insert_dummy_op(pipe_op *op);
    
private:

    bool check_nb_out_complete();
    
    // Main pipeline stages (NFU-1, NFU-2, NFU-3)
    pipe_stage **m_pipe_stages;
    pipe_reg *m_pipe_regs; // Pipeline stages + 2 (one before, one after)
    unsigned m_n_stages;
    
    // Main SRAMs (SB, NBin, NBout)
    sram_array *m_srams[NUM_SRAM_TYPE];
    
    // Stats
    unsigned long long m_sim_cycle;
    unsigned long long m_tot_op_issue;
    unsigned long long m_tot_op_complete;
    
};
