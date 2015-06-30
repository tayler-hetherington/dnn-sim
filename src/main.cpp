#include "common.h"

#include "dnn_sim.h"

int main(int argc, char **argv){
    std::cout << "Starting DNN-Sim" << std::endl;
    
    dnn_sim *m_dnn_sim = new dnn_sim(3, 8);

    sleep(2);

    delete m_dnn_sim;

    return 0;
}
