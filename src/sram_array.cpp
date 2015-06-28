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

sram_array::sram_array(unsigned line_size, unsigned num_lines, unsigned bit_width,
                       unsigned num_read_write_ports, unsigned num_cycle_per_access) {
    
    m_line_size = line_size;
    m_n_lines = num_lines;
    m_bit_width = bit_width;
    m_n_rw_ports = num_read_write_ports;
    m_cycles_per_access = num_cycle_per_access;
    
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
        m_lines[i].m_valid = false;
    }
    
    
}

sram_array::~sram_array() {
    if (m_ports)
        delete m_ports;
    
    if (m_lines)
        delete m_lines;
}

void sram_array::cycle() {
    for(unsigned i=0; i<m_n_rw_ports; ++i){
        if(m_ports[i].m_is_busy){
            m_ports[i].m_cur_access_cycle++;
            if(m_ports[i].m_cur_access_cycle > m_cycles_per_access) {
                m_ports[i].m_is_busy = false;
            }
        }
    }
}

// Reads a line from the SRAM array
bool sram_array::read(unsigned address, unsigned size){

    // Check line is valid
    if(!check_addr(address))
        return false;
    
    unsigned index = (address / (m_bit_width/2) ) % m_n_lines;
    
    if(!m_lines[index].m_valid)
        return false;
    
    // Find first available port to read from
    for(unsigned i=0; i<m_n_rw_ports; ++i) {
        if(!m_ports[i].m_is_busy){ // If not already handling another request
            m_ports[i].m_is_busy = true;
            m_ports[i].m_is_read = true;
            m_ports[i].m_cur_access_cycle = 0;
            
            m_n_reads++;
            break;
        }
    }
    
    return true;
    
}

// Reads to a line in the SRAM array
bool sram_array::write(unsigned address, unsigned size){
    
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
            
            m_n_writes++;
            m_lines[index].m_valid = true;
            break;
        }
    }
    
    
    return true;
}

bool sram_array::check_addr(unsigned address) {
    // Check address alignment
    if(address % (m_bit_width/2))
        return false;
    
    return true;
}