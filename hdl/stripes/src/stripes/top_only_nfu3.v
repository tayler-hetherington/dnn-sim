

module top_only_nfu3 (
        clk,
        i_nfu2_out,
        i_sigmoid_coef,
        i_load_sigmoid_coef,
        o_to_nbout
    );

    parameter N             = 16;
    parameter Tn            = 16;

    //----------- Input Ports ---------------//
    input                       clk;

    // i_inputs is a vector of Tn (16) values, 16-bits each
    input [((N*Tn) - 1):0]      i_nfu2_out;


    // i_synapses is a matrix of Tn x Tn (16x16=256) values, 16-bits each (Row-major).

    input [((2*N)-1):0]         i_sigmoid_coef;         // 16-bit Ai and Bi = 32-bits
    input                       i_load_sigmoid_coef;
        
    //----------- Output Ports ---------------//
    output [((N*Tn) - 1):0]     o_to_nbout;

    // NFU-3 (baseline already has 3 pipe stages)
    nfu_3 n3(
        clk, 
        i_nfu2_out, 
        i_sigmoid_coef, 
        i_load_sigmoid_coef, 
        o_to_nbout
    );

endmodule


