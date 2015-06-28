////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
// Tayler Hetherington
// 2015
// SRAM array structures
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
#ifndef __SRAM_ARRAY_H__
#define __SRAM_ARRAY_H__

typedef struct _sram_line_{
    unsigned m_valid;
}sram_line;

class sram_array {
    
public:
    sram_array(unsigned line_size, unsigned num_lines,
               unsigned num_read_write_ports, unsigned num_read_ports,
               unsigned num_write_ports, unsigned num_cycle_per_access);
    
    ~sram_array();
    
    void read(unsigned address, unsigned size);
    void write(unsigned address, unsigned size);
    
private:

    sram_line *m_lines;
    
    unsigned m_line_size;
    unsigned m_n_lines;
    unsigned m_n_rw_ports;
    unsigned m_n_r_ports;
    unsigned m_n_w_ports;
    unsigned m_cycles_per_access;
    
    bool m_is_busy;
    unsigned m_cur_access_cycle;
    
    // Stats
    unsigned long m_n_reads;
    unsigned long m_n_writes;
    
};


#endif