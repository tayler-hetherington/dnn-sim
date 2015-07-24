////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
// Tayler Hetherington
// 2015
// control_processor.cpp
// Control Processor 
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////

#include "control_processor.h"

// Testing
static bool is_test_complete = false;


control_processor::control_processor(dnn_config const * const cfg, datapath * dp, dram_interface * dram) {
    
    m_dnn_config = cfg;
    m_datapath = dp;
    m_dram_interface = dram;
   
    m_read_callback = new DRAMSim::Callback<control_processor, void, unsigned, uint64_t, uint64_t>(this, &control_processor::read_complete_callback);

    m_write_callback = new DRAMSim::Callback<control_processor, void, unsigned, uint64_t, uint64_t>(this, &control_processor::write_complete_callback);

    m_dram_interface->set_callbacks(m_read_callback, m_write_callback);

}

control_processor::~control_processor(){
    
}

void control_processor::cycle(){

  if(!m_inst_queue.empty()) {
    cp_inst * inst = &m_inst_queue.front();
    bool done = do_cp_inst(inst);
    if (done) {
      m_inst_queue.pop();
    }
  }

}

// FIXME: Note - DRAM memory_fetch currently pulls in the complete data in one request to fill the entire SRAMs.
//        This needs to be separated out into multiple accesses and multiple writes to the SRAMs.

// processes the current instruction according to its current state and updates the state if applicable
// input:   inst    pointer to the instruction to process
//                  note that an instruction takes multiple cycles to execute
// output:          true if all the pipe_ops have been issued
bool control_processor::do_cp_inst(cp_inst *inst){
    // FSM for each instruction
    memory_fetch *mf = NULL;
    bool pending_req = false;
    bool done = false;

    std::cout << "control_processor::do_cp_inst" << std::endl;    
    switch(inst->m_state){
        // Always start with LOAD_NBIN if both LOAD_NBIN and LOAD_SB are set
      case cp_inst::LOAD_NBIN: // Load from DRAM into the NBin SRAM
            std::cout << "Loading NBin" << std::endl;  
            if(m_dram_interface->can_accept_request()){
        
                mf = new memory_fetch(inst->nbin_address, inst->nbin_size, READ, NBin);

                // TODO: This is only going to get one part of the data. The control processor will need to
                // issue multiple DRAM read requests to populate the NBin and SB SRAMs
                // m_dram_interface->do_access(mf);
                m_dram_interface->push_request(mf->m_addr, false);
            
                if(inst->sb_read_op == cp_inst::LOAD){
                    inst->m_state = cp_inst::LOAD_SB;
                }else{
                    inst->m_state = cp_inst::DO_OP;
                }
            
                m_mem_requests.push_back(mf); // Add memory fetch to pending queue
            }
            break;
            
        case cp_inst::LOAD_SB: // Load from DRAM into the SB SRAM
            std::cout << "Loading SBin" << std::endl; 
            if(m_dram_interface->can_accept_request()){

                mf = new memory_fetch(inst->sb_address, inst->sb_size, READ, SB);
                

                // TODO: This is only going to get one part of the data. The control processor will need to
                // issue multiple DRAM read requests to populate the NBin and SB SRAMs
                // m_dram_interface->do_access(mf);
                m_dram_interface->push_request(mf->m_addr, false);

                inst->m_state = cp_inst::DO_OP;
            
                m_mem_requests.push_back(mf); // Add memory fetch to pending queue
            
            }
            break;
            
        case cp_inst::DO_OP: // All data is loaded into the SRAMs, push pipe_ops into the main dnn_sim pipeline
            
            // First wait for all loads to complete, write data to SRAMs
            if(m_mem_requests.size() > 0){
                memory_fetch *mf = m_mem_requests.front();
                
                if(mf->m_is_complete){
                    // Write the data to the SRAM
                    if(m_datapath->write_sram(mf->m_addr, mf->m_size, mf->m_sram_type)){
                        // Write went through, pop the request from the mem_req queue
                        m_mem_requests.pop_front();
                        if(m_mem_requests.size() > 0)
                            pending_req = true;
                    }else {
                        // Otherwise, all SRAM ports were busy, try again next cycle
                        return false;
                    }
                    
                }else{
                    pending_req = true;
                }
            }
            
            // Then start doing the main operation if no pending DRAM READS
            // Patrick: Can't we start processing data while the buffers are being filled?
            if(!pending_req){
                std::cout << "Start proccessing pipeline" << std::endl; 
                // This is where I would start creating "pipe_ops" to perform the convolution, cycling through the different filters loaded into SB
                
                pipe_op * op = new pipe_op( inst->nbin_address, inst->nbin_size,
                                            inst->sb_address, inst->sb_size,
                                            inst->nbout_address, inst->nbout_size );

                // Temporarily end test after DRAM reads complete and pipeline starts
                done = true;
                is_test_complete = true;
            }

            // how do we know when an instruction is done?
            // if ( ) {
            //  done = true;
            // }
            
            break;
            
        case cp_inst::STORE_NBOUT:
            // Write out NBout to DRAM
            std::cout << "STORE_NBOUT not implemented" << std::endl;
            break;
            
        default:
            std::cout << "Error: Undefined instruction state. Aborting" << std::endl;
            abort();
    }
    return done;
}


void control_processor::read_complete_callback(unsigned id, mem_addr address, uint64_t clock_cycle){
    std::cout << "DRAM Read callback for address "  <<  address << " (cycle: " << clock_cycle << ")" << std::endl;

    std::deque<memory_fetch *>::iterator it;
    for(it = m_mem_requests.begin(); it != m_mem_requests.end(); ++it){
        if(address == (*it)->m_addr){
            (*it)->m_is_complete = true;
            break;
        }
    }

}

void control_processor::write_complete_callback(unsigned id, mem_addr address, uint64_t clock_cycle){
    std::cout << "DRAM Write callback for address "  <<  address << " (cycle: " << clock_cycle << ")" << std::endl; 
}

bool control_processor::is_test_done(){
    return is_test_complete;
}

void control_processor::test(cp_inst *inst){
    m_inst_queue.push(*inst);

# if 0
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
    while(!is_test_complete){
        do_cp_inst(m_inst);
        cycle();
    }
    delete m_inst;
#endif
}





