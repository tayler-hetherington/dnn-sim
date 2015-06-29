/*
 * pipe_operation.cpp
 *
 *  Created on: Jun 29, 2015
 *      Author: tayler
 */

#include "pipe_operation.h"


pipe_op::pipe_op(unsigned nb_in_addr, unsigned nb_in_size,
            unsigned sb_addr, unsigned sb_size,
            unsigned nb_out_addr, unsigned nb_out_size){

    m_sram_op[NBin].addr = nb_in_addr;
    m_sram_op[NBin].size = nb_in_size;
    m_sram_op[NBout].addr = nb_out_addr;
    m_sram_op[NBout].size = nb_out_size;
    m_sram_op[SB].addr = sb_addr;
    m_sram_op[SB].size = sb_size;

    for(unsigned i=0; i<NUM_SRAM_TYPE; ++i){
        sram_op_complete[i] = false;
    }

}

pipe_op::~pipe_op(){


}

void pipe_op::set_sram_op_pending(sram_type type){
    sram_op_complete[type] = false;
}
void pipe_op::set_sram_op_complete(sram_type type){
    sram_op_complete[type] = true;
}

unsigned pipe_op::get_sram_addr(sram_type type){
    return m_sram_op[type].addr;
}

unsigned pipe_op::get_sram_size(sram_type type){
    return m_sram_op[type].size;
}

