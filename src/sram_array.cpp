
#include "sram_array.h"

sram_array::sram_array(unsigned line_size, unsigned num_lines,
                            unsigned num_read_write_ports, unsigned num_read_ports,
                            unsigned num_write_ports, unsigned num_cycle_per_access){
    
    m_line_size = line_size;
    m_n_lines = num_lines;
    m_n_rw_ports = num_read_write_ports;
    m_n_r_ports = num_read_ports;
    m_n_w_ports = num_write_ports;
    m_cycles_per_access = num_cycle_per_access;
    
    m_lines = new sram_line[m_n_lines];
    
    
}

sram_array::~sram_array(){
    if (m_lines)
        delete m_lines;
}