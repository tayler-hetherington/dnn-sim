////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
// Tayler Hetherington
// 2015
// power_model.h
// Simple Power Model
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////

#ifndef __POWER_MODEL_H__
#define __POWER_MODEL_H__

#include "common.h"
#include "config.h"

typedef struct _comp_perf_counts_ {
    uint64_t cur;
    uint64_t prev;
}comp_perf_counts;

class power_model {
public:

    power_model(dnn_config const * const cfg);
    ~power_model();

    void update_perf_count(power_hw_comps hwc, uint64_t val);
    double get_comp_eng(power_hw_comps hwc);

private:
    void init_comp_eng();
    void init_perf_counts();
    uint64_t get_current_perf_count(power_hw_comps hwc);

    dnn_config const *m_cfg;
    std::vector<double> m_comp_eng; // Factors in pJ
    std::vector<comp_perf_counts> m_perf_counts;

};



#endif
