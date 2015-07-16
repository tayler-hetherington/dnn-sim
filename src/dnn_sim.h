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
#include "config.h"

class dnn_sim {

public:
    dnn_sim(dnn_config *config);
    
    ~dnn_sim();

    void cycle(); // Top level cycle function.
    
    bool insert_op(pipe_op *op);
    void print_stats();
    
    void print_pipeline();
    
    // DEBUG
    void insert_dummy_op(pipe_op *op);
    
    bool read_sram(unsigned address, unsigned size, sram_type s_type);
    bool write_sram(unsigned address, unsigned size, sram_type s_type);
    
private:

    // Configs
    dnn_config *m_config;
    
    bool check_nb_out_complete();
    
    // Main pipeline stages (NFU-1, NFU-2, NFU-3)
    pipe_stage **m_pipe_stages;
    pipe_reg *m_pipe_regs; // Pipeline stages + 2 (one before, one after)
    unsigned m_n_stages;
    
    unsigned m_max_buffer_size;
    
    // Main SRAMs (SB, NBin, NBout)
    sram_array *m_srams[NUM_SRAM_TYPE];
    
    // Stats
    unsigned long long m_sim_cycle;
    unsigned long long m_tot_op_issue;
    unsigned long long m_tot_op_complete;
    
};
