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
    // TODO: Make parameters configurable
    //m_dram_interface = new dram_interface(400, 32);
    m_dram_interface = new dram_interface("ini/DDR2_micron_16M_8b_x8_sg3E.ini", 
                                            "system.ini", 
                                            "./DRAMSim2/", 
                                            "dnn_sim", 
                                            16384);
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
    m_datapath->print_pipeline();
    
    // not sure about order here
    m_control_processor->cycle();
    m_dram_interface->cycle();
    m_datapath->cycle();

}

// FOR TESTING
bool dnn_sim::insert_op(pipe_op * op){
  //m_datapath->insert_op(op);
}
bool dnn_sim::insert_inst(cp_inst *inst){
    m_control_processor->test(inst);
}

bool dnn_sim::is_test_done(){
    return m_control_processor->is_test_done();
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
