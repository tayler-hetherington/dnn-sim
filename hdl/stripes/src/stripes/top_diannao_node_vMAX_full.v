//----------------------------------------------//
//----------------------------------------------//
// Top level pipeline for stripes, includes only nfu_1_2_serial_pipe 
// Instantiates each of the pipeline stages, registers
// and necessary control signals.
// Tayler Hetherington
// 2015
//----------------------------------------------//
//----------------------------------------------//


module top_diannao_node_vMAX (
        clk,                    // Main clock
        reset,                  // Reset
        i_inputs,               // Inputs from eDRAM to NBin
        i_synapses,             // Inputs from SB
        i_nbout,                // Input from NBOut
        i_sigmoid_coef,         // Coefficient values to store in sigmoid RAM
        i_load_sigmoid_coef,    // Control signal to store sigmoid coefficients
        i_op,                   // Average or MAX op select line (avg = 0, max - 1)
        


        i_first_cycle,
        i_precision,
        o_to_nbout
    );

    parameter N             = 16;
    parameter Tn            = 16;
    parameter TnxTn         = Tn*Tn;
    parameter Tw            = 16;
    
    parameter ADDR_WIDTH    = 6;
    parameter N_OPS         = 1;


    //----------- Input Ports ---------------//
    input                       clk;
    input                       reset;

    // i_inputs is a vector of Tn (16) values, 16-bits each
    input [((N*Tn) - 1):0]      i_inputs;


    // i_synapses is a matrix of Tn x Tn (16x16=256) values, 16-bits each (Row-major).
    input [((N*TnxTn) - 1):0]   i_synapses;


    input[(N*Tn*Tw)-1:0]        i_nbout;


    input [((2*N)-1):0]         i_sigmoid_coef;         // 16-bit Ai and Bi = 32-bits
    input                       i_load_sigmoid_coef;
    input [N_OPS-1:0]           i_op;                   // Average or MAX op select line (avg = 0, max - 1)
        

    input                       i_first_cycle;
    input [4:0]                 i_precision;

    //----------- Output Ports ---------------//
    output [((N*Tn) - 1):0]     o_to_nbout;

    //----------- Internal Signals --------------//
    // Wires
    wire [(N*Tw*Tn)-1:0]        nfu1_2_serial_out;
    wire [(N*Tw*Tn)-1:0         mux_to_nbout;


    
    
    //------------- Code Start -----------------//
    assign o_to_nbout       = mux_to_nbout;
    

    //--------------------------------------------------// 
    //-------------- Main Pipeline Stages --------------//
    //--------------------------------------------------// 
    

    // NFU_1_2_serial_pipe
    nfu_1_2_serial_pipe (
        clk,
        reset,
        i_first_cycle,
        i_precision,
        i_inputs,
        i_synapses,
        i_nbout,
        nfu1_2_serial_out
    );
    
    
    mux_16_to_1_v2 MUX16_1 (
        i_mux_sel,
        nfu1_2_serial_out,
        mux_to_nbout;
    );
    
    //--------------------------------------------------// 
    //--------------------------------------------------// 
    //--------------------------------------------------//

endmodule

