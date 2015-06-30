#include "common.h"

#include "dnn_sim.h"

dnn_sim *m_dnn_sim = NULL;

void *main_sim_loop(void *args);

int main(int argc, char **argv){
    std::cout << "Starting DNN-Sim" << std::endl;
    
    pthread_t m_sim_thread;
    
    unsigned n_pipeline_stages = 3;
    unsigned max_pipe_queue_length = 8;
    unsigned bit_width = 16;
    
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
    
    for(unsigned i=0; i<4; ++i){
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