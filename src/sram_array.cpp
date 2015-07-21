////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
// Tayler Hetherington
// 2015
// sram_array.cpp
// SRAM array structures
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////

#include "sram_array.h"

sram_array::sram_array(sram_type type, unsigned line_size, unsigned num_lines, unsigned bit_width,
                       unsigned num_read_write_ports, unsigned num_cycle_per_access, pipe_reg *p_reg) {
    
    m_sram_type = type;

    m_line_size = line_size;
    m_n_lines = num_lines;
    m_bit_width = bit_width;
    m_n_rw_ports = num_read_write_ports;
    m_cycles_per_access = num_cycle_per_access;
    
    m_pipe_reg = p_reg;
    
    m_n_reads = 0;
    m_n_writes = 0;
    
    // Setup read/write ports
    m_ports = new sram_port[m_n_rw_ports];
    for(unsigned i=0; i<m_n_rw_ports; ++i) {
        m_ports[i].m_is_busy = false;
        m_ports[i].m_is_read = false;
        m_ports[i].m_cur_access_cycle = 0;
    }
    
    // Setup lines
    m_lines = new sram_line[m_n_lines];
    for(unsigned i=0; i<m_n_lines; ++i) {
//        m_lines[i].m_valid = false;
        // FIXME:
        m_lines[i].m_valid = true;
    }
    
    
}

sram_array::~sram_array() {
    if (m_ports)
        delete m_ports;
    
    if (m_lines)
        delete m_lines;
}

void sram_array::cycle() {
    bool all_ports_busy = true;

    for(unsigned i=0; i<m_n_rw_ports; ++i){
        if(m_ports[i].m_is_busy){
            std::cout << "SRAM port " << i << " is busy, increment access" << std::endl;
            m_ports[i].m_cur_access_cycle++;
            if(m_ports[i].m_cur_access_cycle >= m_cycles_per_access) {
                std::cout << "SRAM port ";
                if(m_ports[i].m_is_read){
                    std::cout << "READ";
                }else{
                    std::cout << "WRITE";
                }
                std::cout << " complete" << std::endl;
                m_ports[i].m_is_busy = false;
                if(m_ports[i].m_op){
                    m_ports[i].m_op->set_sram_op_complete(m_sram_type); // Read completed
                    m_ports[i].m_op = NULL;
                }
            }
        }else{
            all_ports_busy = false;
        }
    }
    
    if(!all_ports_busy && !m_pipe_reg->empty()){ // Check if input port has a read or write pending
        pipe_op *op = m_pipe_reg->front();
        if(op->is_read()){
            read(op);
        }else{
            write(op);
        }
    }
}

// Reads a line from the SRAM array
bool sram_array::read(pipe_op* op){

    std::cout << "Read sent" << std::endl;
    // Check line is valid
    if(!check_addr(op->get_sram_addr(m_sram_type)))
        return false;
    
    unsigned index = (op->get_sram_addr(m_sram_type) / (m_bit_width/2) ) % m_n_lines;
    
    if(!m_lines[index].m_valid)
        return false;
    
    // Find first available port to read from
    for(unsigned i=0; i<m_n_rw_ports; ++i) {
        if(!m_ports[i].m_is_busy){ // If not already handling another request
            m_ports[i].m_is_busy = true;
            m_ports[i].m_is_read = true;
            m_ports[i].m_cur_access_cycle = 0;
            
            m_ports[i].m_op = op;
            m_ports[i].m_op->set_sram_op_pending(m_sram_type); // Read not completed yet

            m_n_reads++;
            break;
        }
    }
    
    return true;
}

// Reads a line from the SRAM array
bool sram_array::read(unsigned address, unsigned size){
    
    std::cout << "Write sent" << std::endl;
    // Check line is valid
    if(!check_addr(address))
        return false;
    
    // assuming that all addresses streams will be sequential
    unsigned index = (address / (m_bit_width/2) ) % m_n_lines;
    
    if(!m_lines[index].m_valid)
        return false;
    
    // Find first available port to read from
    for(unsigned i=0; i<m_n_rw_ports; ++i) {
        if(!m_ports[i].m_is_busy){ // If not already handling another request
            m_ports[i].m_is_busy = true;
            m_ports[i].m_is_read = true;
            m_ports[i].m_cur_access_cycle = 0;
            
            m_ports[i].m_op = NULL;

            
            m_n_reads++;
            break;
        }
    }
    
    return true;
}

// Reads to a line in the SRAM array
bool sram_array::write(unsigned address, unsigned size){
    std::cout << "Write sent" << std::endl;
    // Check line is valid
    if(!check_addr(address))
        return false;
    
    unsigned index = (address / (m_bit_width/2) ) % m_n_lines;
    
    // Find first available port to read from
    for(unsigned i=0; i<m_n_rw_ports; ++i) {
        if(!m_ports[i].m_is_busy){ // If not already handling another request
            m_ports[i].m_is_busy = true;
            m_ports[i].m_is_read = false;
            m_ports[i].m_cur_access_cycle = 0;
            
            m_ports[i].m_op = NULL;
            m_n_writes++;
            m_lines[index].m_valid = true;
            break;
        }
    }
    return true;
}

bool sram_array::write(pipe_op *op){
    std::cout << "Write sent" << std::endl;    
    // Check line is valid
    if(!check_addr(op->get_sram_addr(m_sram_type)))
        return false;
    
    unsigned index = (op->get_sram_addr(m_sram_type) / (m_bit_width/2) ) % m_n_lines;
    
    if(!m_lines[index].m_valid)
        return false;
    
    // Find first available port to read from
    for(unsigned i=0; i<m_n_rw_ports; ++i) {
        if(!m_ports[i].m_is_busy){ // If not already handling another request
            m_ports[i].m_is_busy = true;
            m_ports[i].m_is_read = false;
            m_ports[i].m_cur_access_cycle = 0;
            
            m_ports[i].m_op = op;
            m_ports[i].m_op->set_sram_op_pending(m_sram_type); // Operation not completed yet
            
            m_n_writes++;
            break;
        }
    }
    
    return true;

}

bool sram_array::is_sram_busy(){
    for(unsigned i=0; i<m_n_rw_ports; ++i) {
        if(!m_ports[i].m_is_busy) return false;
    }

    return true;
}


bool sram_array::check_addr(unsigned address) {
    // Check address alignment
    if(address % (m_bit_width/2))
        return false;
    
    return true;
}
