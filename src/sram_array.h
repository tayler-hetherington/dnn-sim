////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
// Tayler Hetherington
// 2015
// sram_array.h
// SRAM array structures
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////

#ifndef __SRAM_ARRAY_H__
#define __SRAM_ARRAY_H__

#include "common.h"
#include "pipe_operation.h"

typedef struct _sram_line_ {
    bool m_valid;
}sram_line;

typedef struct _sram_port_ {
    bool m_is_busy;
    bool m_is_read;
    unsigned m_cur_access_cycle;

    pipe_op *m_op;
}sram_port;


class sram_array {
    
public:
    sram_array(sram_type type, unsigned line_size, unsigned num_lines, unsigned bit_width,
               unsigned num_read_write_ports, unsigned num_cycle_per_access, pipe_reg *p_requests,  pipe_reg *p_reg);
    
    ~sram_array();
    
    void cycle();
    bool is_sram_busy();
    bool read(pipe_op *op);
    bool write(pipe_op *op);
    
    bool read(unsigned address, unsigned size);
    bool write(unsigned address, unsigned size);
    
private:

    ///////////////////
    // Member functions
    ///////////////////
    bool check_addr(unsigned address);

    ///////////////////
    // Member variables
    ///////////////////
    pipe_reg *m_pipe_reg; // Stores op for NBin/SB read and NBout write.
    pipe_reg *m_requests;
 
    sram_type m_sram_type;

    sram_line *m_lines;
    
    unsigned m_line_size;
    unsigned m_n_lines;
    unsigned m_bit_width;
    unsigned m_n_rw_ports;
    unsigned m_cycles_per_access;
    
    // Ports
    sram_port *m_ports;
    
    // Stats
    unsigned long m_n_reads;
    unsigned long m_n_writes;

};


#endif
