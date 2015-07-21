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

#include <fstream>

// Main DNN_sim object. Creates all internal structures of the DianNao architecture
dnn_sim::dnn_sim(dnn_config *config) : m_config(config){
    
    // Create main DRAM interface
    // FIXME: Fix these values
    m_dram_interface = new dram_interface(5, 32);

    m_datapath = new datapath(m_config);

    m_control_processor = new control_processor(m_config, m_datapath, m_dram_interface);

    // Stats
    m_sim_cycle = 0;
    
    read_instructions();
}

dnn_sim::~dnn_sim(){

}

// Cycle structures in reverse order
void dnn_sim::cycle(){
    
    m_sim_cycle++;
    std::cout << std::endl << "Cycle: " << m_sim_cycle << std::endl;
    
    // not sure about order here
    m_control_processor->cycle();
    m_dram_interface->cycle();
    m_datapath->cycle();
}

// FOR TESTING
bool dnn_sim::insert_op(pipe_op * op){
  m_datapath->insert_op(op);
}

void dnn_sim::print_stats(){
    std::cout << std::endl << "=====================" << std::endl;
    std::cout << "Total sim cycles: " << m_sim_cycle << std::endl;
    std::cout << "=====================" << std::endl << std::endl;
}

bool dnn_sim::read_instructions(){
    std::ifstream ifs;
    ifs.open ("dummy");
    if (m_control_processor){
        return m_control_processor->read_instructions(ifs);
    }
    return false;
}
