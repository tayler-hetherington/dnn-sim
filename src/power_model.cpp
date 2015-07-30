////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
// Tayler Hetherington

// 2015
// power_model.cpp
// Simple Power Model
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////

#include "power_model.h"


power_model::power_model(dnn_config const * const cfg){
    m_cfg = cfg;

    init_comp_eng();
    init_perf_counts();
}


power_model::~power_model(){

}

// Initialize component per-access energy factors
void power_model::init_comp_eng(){
    assert(m_cfg);

    m_comp_eng.resize(NUM_HW_COMPS);

    // SRAM arrays
    m_comp_eng[SB_P] = m_cfg->sb_acc_eng;
    m_comp_eng[NB_IN_P] = m_cfg->nbin_acc_eng;
    m_comp_eng[NB_OUT_P] = m_cfg->nbout_acc_eng;

    // Functional units
    m_comp_eng[INT_MULT_16_P] = m_cfg->int_mult_16_eng;
    m_comp_eng[FP_MULT_16_P] = m_cfg->fp_mult_16_eng;
    m_comp_eng[INT_ADD_16_P] = m_cfg->int_add_16_eng;
    m_comp_eng[FP_ADD_16_P] = m_cfg->fp_add_16_eng;

}

// Initialize internal component performance counters
void power_model::init_perf_counts(){
    m_perf_counts.resize(NUM_HW_COMPS);

    std::vector<comp_perf_counts>::iterator it;
    for(it = m_perf_counts.begin(); it != m_perf_counts.end(); ++it){
        it->cur = 0;
        it->prev = 0;
    }
}

void power_model::update_perf_count(power_hw_comps hwc, uint64_t val){
    m_perf_counts[hwc].prev = m_perf_counts[hwc].cur;
    m_perf_counts[hwc].cur = val;
}

// Get the component energy since the last update (perf count * per-access energy)
double power_model::get_comp_eng(power_hw_comps hwc){
    return ( (double)get_current_perf_count(hwc) * m_comp_eng[hwc] );
}

// Calculate the total number of component accesses since last update
uint64_t power_model::get_current_perf_count(power_hw_comps hwc){
    return (m_perf_counts[hwc].cur - m_perf_counts[hwc].prev);
}
