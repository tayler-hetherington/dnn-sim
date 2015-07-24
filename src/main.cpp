#include "common.h"

#include "dnn_sim.h"
#include "cp_inst.h"
#include "config.h"
#include "option_parser.h"

dnn_sim *m_dnn_sim = NULL;
dnn_config *m_dnn_config = NULL;

void *main_sim_loop(void *args);
void reg_options(option_parser_t opp);

// Borrowed from GPGPU-Sim (www.gpgpu-sim.org) 2015
static int sg_argc = 3;
static const char *sg_argv[] = {"", "-config", "dnn-sim.config"};


////////////////////////////////////////////////////////////
// Main
////////////////////////////////////////////////////////////
int main(int argc, char **argv){
    std::cout << "Starting DNN-Sim" << std::endl;
    
    pthread_t m_sim_thread;
    
    // Create new configuration options
    m_dnn_config = new dnn_config();
    
    // Parse configuration file (borrowed from GPGPU-Sim 2015 (www.gpgpu-sim.org)
    option_parser_t opp = option_parser_create();
    m_dnn_config->reg_options(opp);
    option_parser_cmdline(opp, sg_argc, sg_argv);
    option_parser_print(opp, stdout);
    std::cout << std::endl;
    std::cout << std::endl;
    
    // Create main DNN-Sim object
    m_dnn_sim = new dnn_sim(m_dnn_config);

    std::cout << "Launching main simulation thread" << std::endl;
    if(pthread_create(&m_sim_thread, NULL, main_sim_loop, NULL)){
        std::cout << "Error creating main simulation thread. Aborting..." << std::endl;
        abort();
    }
    
    void *pthread_ret;
    pthread_join(m_sim_thread, &pthread_ret);
    
    m_dnn_sim->print_stats();
    
    std::cout << "Finished... Cleaning up..." << std::endl;
    delete m_dnn_sim;
    std::cout << "Complete" << std::endl;
    return 0;
}


void *main_sim_loop(void *args){
    std::cout << "In main simulation loop" << std::endl;
    
    assert(m_dnn_sim);

    
    // DEBUG: Testing inserting 4 ops
#if 0    
    pipe_op *op[4];
    for(unsigned i=0; i<4; ++i){
        op[i] = new pipe_op(0, 32, 0, 256, 0, 32);
        m_dnn_sim->insert_op(op[i]);
        m_dnn_sim->cycle();
    }
    
    for(unsigned i=0; i<20; ++i){
        m_dnn_sim->cycle();
    }
#endif

    // Test full load into SB and NBin
    cp_inst *m_inst = new cp_inst();
    
    // Set test data
    m_inst->sb_read_op = cp_inst::LOAD;
    m_inst->sb_reuse = 0;
    m_inst->sb_address = 0;
    m_inst->sb_size = 32768;
    
    
    m_inst->nbin_read_op = cp_inst::LOAD;
    m_inst->nbin_reuse = 0;
    m_inst->nbin_stride = 0;
    m_inst->nbin_stride_begin = 0;
    m_inst->nbin_stride_end = 0;
    m_inst->nbin_address = 4194304;
    m_inst->nbin_size = 2048;
    
    // TODO: Add main NFU stages and NBout config

    m_inst->m_state = cp_inst::LOAD_NBIN;
    
    // Cycle through the state machine for this test instruction
    m_dnn_sim->insert_inst(m_inst);
    while(!m_dnn_sim->is_test_done()){
          m_dnn_sim->cycle();
    }   

    delete m_inst;
    
    return NULL;
}












