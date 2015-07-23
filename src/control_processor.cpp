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

#include <sstream>

// Testing
static bool is_test_complete = false;


control_processor::control_processor(dnn_config const * const cfg, datapath * dp, dram_interface * dram) {

    m_dnn_config = cfg;
    m_datapath = dp;
    m_dram_interface = dram;

}

control_processor::~control_processor(){

}

void control_processor::cycle(){

  if( ! m_inst_queue.empty()) {
    cp_inst * inst = &m_inst_queue.front();
    std::cout << "Current instruction: " << *inst << std::endl;
    bool done = do_cp_inst(inst);
    if (done) {
        std::cout << "Popping Inst Queue\n";
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
    std::cout << "control_processor::do_cp_inst" << std::endl;    
    // FSM for each instruction
    memory_fetch *mf = NULL;
    bool pending_req = false;
    bool done = false;


    // All these states should be pipelined, we want to start computing once 
    // the first buffer entries are loaded
    switch(inst->m_state){
        // Always start with LOAD_NBIN if both LOAD_NBIN and LOAD_SB are set

        case cp_inst::LOAD_SB: // Load from DRAM into the SB SRAM
            std::cout << "LOAD_SB " << inst->sb_address << std::endl;
            mf = new memory_fetch(inst->sb_address, inst->sb_size, READ, SB);
            m_dram_interface->do_access(mf);

            if(inst->nbin_read_op == cp_inst::LOAD){
                inst->m_state = cp_inst::LOAD_NBIN;
            }else{
                inst->m_state = cp_inst::DO_OP;
            }

            //mf->m_is_complete = true; // HACH for TESTING
            m_mem_requests.push(mf); // Add memory fetch to pending queue

            m_sb_index = 0;

            break;

        case cp_inst::LOAD_NBIN: // Load from DRAM into the NBin SRAM
            std::cout << "LOAD_NBIN " << inst->nbin_address << std::endl;

            mf = new memory_fetch(inst->nbin_address, inst->nbin_size, READ, NBin);
            m_dram_interface->do_access(mf);

            inst->m_state = cp_inst::DO_OP;

           // mf->m_is_complete = true; // HACK for TESTING
            m_mem_requests.push(mf); // Add memory fetch to pending queue

            break;

        case cp_inst::DO_OP: // All data is loaded into the SRAMs, push pipe_ops into the main dnn_sim pipeline

            // First wait for all loads to complete, write data to SRAMs
            if(m_mem_requests.size() > 0){
                memory_fetch *mf = m_mem_requests.front();

                if(mf->m_is_complete){
                    // Write the data to the SRAM
                    if(m_datapath->write_sram(mf->m_addr, mf->m_size, mf->m_sram_type)){
                        // Write went through, pop the request from the mem_req queue
                        m_mem_requests.pop();
                    }else{
                        // Otherwise, all SRAM ports were busy, try again next cycle
                        return false;
                    }

                }else{
                    pending_req = true;
                    std::cout << "DO_OP waiting for pending request\n";
                }
            }

            // Then start doing the main operation if no pending DRAM READS
            // Patrick: Can't we start processing data while the buffers are being filled?
            if(!pending_req) {
                // This is where I would start creating "pipe_ops" to perform the convolution, cycling through the different filters loaded into SB

                int data_size = (m_dnn_config->bit_width / 8); // in bytes

                int num_output_lines = m_dnn_config->num_outputs / m_dnn_config->nbout_line_length; // 16 = 256 / 16
                int nbin_index      = m_sb_index / num_output_lines; 
                int nbout_index     = m_sb_index % num_output_lines; 

                int sb_addr     = inst->sb_address      + m_sb_index    * m_dnn_config->sb_line_length      * data_size;
                int nbin_addr   = inst->nbin_address    + nbin_index    * m_dnn_config->nbin_line_length    * data_size;
                int nbout_addr  = inst->nbout_address   + nbout_index   * m_dnn_config->nbout_line_length   * data_size;

                std::cout << "DO_OP " << nbin_addr << " , " << sb_addr << " , " << nbout_addr << std::endl;
                pipe_op * op = new pipe_op( nbin_addr, 1, sb_addr, 1, nbout_addr, 1 );

                m_datapath->insert_op(op);

                m_sb_index++;

                // should go to STORE_NBOUT first
                if (m_sb_index == m_dnn_config->sb_num_lines) {
                    done = true;
                    std::cout << "Done\n";
                }
            }

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

void control_processor::test(){

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
    }

    delete m_inst;
}

bool control_processor::read_instructions(std::istream & is){

    // TEST: hardcode one instruction and insert
    cp_inst ins;
    std::stringstream ss("| NOP || LOAD | 0 | 0 | 32768 || LOAD | 1 | 0 | 0 | 0 | 4194304 | 2048 || NOP | WRITE | 0 | 0 || MULT | ADD | RESET | NBOUT | SIGMOID | 1 | 0 |");
    ss >> ins;
    ins.m_state = cp_inst::LOAD_SB; // inital state
    m_inst_queue.push(ins);

    return true;
}
