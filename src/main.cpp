#include "common.h"

#include "dnn_sim.h"
#include "config.h"
#include "option_parser.h"

dnn_sim *m_dnn_sim = NULL;
dnn_config *m_dnn_config = NULL;

void *main_sim_loop(void *args);
void reg_options(option_parser_t opp);

// Borrowed from GPGPU-Sim (www.gpgpu-sim.org) 2015
static int sg_argc = 3;
static const char *sg_argv[] = {"", "-config", "dnn-sim.config"};

int main(int argc, char **argv){
    std::cout << "Starting DNN-Sim" << std::endl;
    
    pthread_t m_sim_thread;
    
    unsigned n_pipeline_stages = 3;
    unsigned max_pipe_queue_length = 8;
    unsigned bit_width = 16;
    
    
    // Create new configuration options
    m_dnn_config = new dnn_config();
    
    // Parse configuration file (borrowed from GPGPU-Sim 2015 (www.gpgpu-sim.org)
    option_parser_t opp = option_parser_create();
    m_dnn_config->reg_options(opp);
    option_parser_cmdline(opp, sg_argc, sg_argv);
    option_parser_print(opp, stdout);
    
    // Create main DNN-Sim object
    m_dnn_sim = new dnn_sim(n_pipeline_stages,
                                     max_pipe_queue_length,
                                     bit_width);

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
    
    for(unsigned i=0; i<2; ++i){
        m_dnn_sim->cycle();
    }

    pipe_op *op = new pipe_op(0, 32, 0, 512, 0, 32);
    
    m_dnn_sim->insert_op(op);
    
    
    // DEBUG
    //m_dnn_sim->insert_dummy_op(op);
    
    for(unsigned i=0; i<10; ++i){
        m_dnn_sim->cycle();
    }
    
    return NULL;
}

void dnn_config::reg_options(option_parser_t opp){
    
    // SB
    option_parser_register(opp, "-sb_line_length", OPT_INT32, &sb_line_length,
                           "SB line length (default = 256)",
                           "256");
    
    option_parser_register(opp, "-sb_num_lines", OPT_INT32, &sb_num_lines,
                           "Number of SB lines (default = 64)",
                           "64");
    
    option_parser_register(opp, "-sb_access_cycles", OPT_INT32, &sb_access_cycles,
                           "Number of cycles to access the SB SRAM (default = 1)",
                           "1");
    
    
    // NBin
    option_parser_register(opp, "-nbin_line_length", OPT_INT32, &nbin_line_length,
                           "SB line length (default = 256)",
                           "256");
    
    option_parser_register(opp, "-nbin_num_lines", OPT_INT32, &nbin_num_lines,
                           "Number of NBin lines (default = 64)",
                           "64");
    
    option_parser_register(opp, "-nbin_access_cycles", OPT_INT32, &nbin_access_cycles,
                           "Number of cycles to access the NBin SRAM (default = 1)",
                           "1");
    
    // NBout
    option_parser_register(opp, "-nbout_line_length", OPT_INT32, &nbout_line_length,
                           "NBout line length (default = 256)",
                           "256");
    
    option_parser_register(opp, "-nbout_num_lines", OPT_INT32, &nbout_num_lines,
                           "Number of NBout lines (default = 64)",
                           "64");
    
    option_parser_register(opp, "-nbout_access_cycles", OPT_INT32, &nbout_access_cycles,
                           "Number of cycles to access the NBout SRAM (default = 1)",
                           "1");
    
    // NFU-1
    option_parser_register(opp, "-num_nfu1_pipeline_stages", OPT_INT32, &num_nfu1_pipeline_stages,
                           "Number of NFU-1 internal pipeline stages (default = 1)",
                           "1");
    // NFU-2
    option_parser_register(opp, "-num_nfu2_pipeline_stages", OPT_INT32, &num_nfu2_pipeline_stages,
                           "Number of NFU-2 internal pipeline stages (default = 1)",
                           "1");
    // NFU-3
    option_parser_register(opp, "-num_nfu3_pipeline_stages", OPT_INT32, &num_nfu3_pipeline_stages,
                           "Number of NFU-3 internal pipeline stages (default = 1)",
                           "1");
    
    // Floating point bit width precision
    option_parser_register(opp, "-bit_width", OPT_INT32, &bit_width,
                           "Floating point bit width (default = 32)",
                           "32");
    
}











