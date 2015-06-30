////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
// Tayler Hetherington
// 2015
// dnn_sim.cpp
// Main DNN simulator
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////

#include "dnn_sim.h"


// Main DNN_sim object. Creates all internal structures of the DianNao architecture
dnn_sim::dnn_sim(unsigned num_stages, unsigned max_queue_size, unsigned bit_width){

    // Currently hardcoded for 3 stages
    m_n_stages = num_stages;
    assert(m_n_stages == 3);

    m_pipe_stages = new pipe_stage *[m_n_stages];

    // Create pipeline stage registers ( (num_stages-1) + 2)
    m_pipe_regs = new pipe_reg[m_n_stages + 1];

    m_pipe_stages[NFU1] = new nfu_1(&m_pipe_regs[0], &m_pipe_regs[1], max_queue_size);
    m_pipe_stages[NFU2] = new nfu_2(&m_pipe_regs[1], &m_pipe_regs[2], max_queue_size);
    m_pipe_stages[NFU3] = new nfu_3(&m_pipe_regs[2], &m_pipe_regs[3], max_queue_size);
    
    
    // Create SRAMs (SB, NBin, NBout)
    m_srams[NBin]   = new sram_array(NBin, 32, 64, bit_width, 1, 1, &m_pipe_regs[0]);
    m_srams[NBout]  = new sram_array(NBout, 32, 64, bit_width, 1, 1, &m_pipe_regs[3]);
    m_srams[SB]     = new sram_array(SB, 512, 64, bit_width, 1, 1, &m_pipe_regs[0]);

    
    // Stats
    m_sim_cycle = 0;
    m_tot_op_issue = 0;
    m_tot_op_complete = 0;
}



dnn_sim::~dnn_sim(){
    // Clean up pipeline stages
    for(unsigned i=0; i<m_n_stages; ++i){
        if(m_pipe_stages[i])
            delete m_pipe_stages[i];
    }
    delete[] m_pipe_stages;

    if(m_pipe_regs)
        delete[] m_pipe_regs;
    
    // Clean up SRAM arrays
    for(unsigned i=0; i<NUM_SRAM_TYPE; ++i){
        delete m_srams[i];
    }
}

// Cycle structures in reverse order
void dnn_sim::cycle(){
    
    m_sim_cycle++;
    
    check_nb_out_complete();
    m_srams[NBout]->cycle();
    for(int i=(NUM_PIPE_STAGES-1); i>=0; --i){
        m_pipe_stages[i]->cycle();
    }
    m_srams[NBin]->cycle();
    m_srams[SB]->cycle();
}

bool dnn_sim::insert_op(pipe_op *op){
    
    std::cout << "Inserting Operation" << std::endl;
    
    m_tot_op_issue++;
    op->set_read();
    m_pipe_regs[0].push(op);
    
    return true;
}

// Basically the writeback stage. Check if the pipeline operation has written back to NBout successfully.
// If so, pop the operation from the pipeline. Otherwise, wait for completion.
bool dnn_sim::check_nb_out_complete(){
    pipe_op *op;
    if(!m_pipe_regs[m_n_stages].empty()){
        op = m_pipe_regs[m_n_stages].front();
        if(!op->is_read() && op->is_write_complete()){
            m_pipe_regs[m_n_stages].pop();
            m_tot_op_complete++;
        }
    }
    return true;
}


void dnn_sim::print_stats(){
    std::cout << "=====================" << std::endl;
    std::cout << "Total sim cycles: " << m_sim_cycle << std::endl;
    std::cout << "Total operations issued: " << m_tot_op_issue << std::endl;
    std::cout << "Total operations completed: " << m_tot_op_complete << std::endl;
    std::cout << "=====================" << std::endl;
}

///////////////////////////////////////////////
// DEBUG
///////////////////////////////////////////////
void dnn_sim::insert_dummy_op(pipe_op *op){
    m_pipe_stages[NFU1]->push_op(op);
}







