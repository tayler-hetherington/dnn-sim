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



dnn_sim::dnn_sim(unsigned num_stages, unsigned max_queue_size){

    // Currently hardcoded for 3 stages
    m_n_stages = num_stages;
    assert(m_n_stages == 3);

    m_pipe_stages = new pipe_stage *[m_n_stages];

    // Create pipeline stage registers ( (num_stages-1) + 2)
    m_pipe_regs = new pipe_reg[m_n_stages + 1];

    m_pipe_stages[NFU1] = new nfu_1(&m_pipe_regs[0], &m_pipe_regs[1], max_queue_size);
    m_pipe_stages[NFU2] = new nfu_2(&m_pipe_regs[1], &m_pipe_regs[2], max_queue_size);
    m_pipe_stages[NFU3] = new nfu_3(&m_pipe_regs[2], &m_pipe_regs[3], max_queue_size);

}

dnn_sim::~dnn_sim(){
    for(unsigned i=0; i<m_n_stages; ++i){
        if(m_pipe_stages[i])
            delete m_pipe_stages[i];
    }
    delete[] m_pipe_stages;

    if(m_pipe_regs)
        delete[] m_pipe_regs;
}
