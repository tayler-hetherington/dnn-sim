//----------------------------------------------//
//----------------------------------------------//
// NFU-1: Convolution multiplication
// Tayler Hetherington
// 2015
//----------------------------------------------//
//----------------------------------------------//

module neuron_Tn_mult (
        clk,
        i_input,
        i_synapses,
        o_mult_out
    );

    parameter N = 16;
    parameter Tn = 16;

    //----------- Inputs ---------------//
    input clk;

    // Single 16-bit input value
    input [(N - 1):0] i_input;

    // Tn 16-bit synapses per input value
    input [((N*Tn) - 1):0] i_synapses;

    //----------- Outputs ---------------//
    // Tn 16-bit outputs
    output [((N*Tn) - 1):0] o_mult_out;

    //------------- Code Start -------------//
    genvar i;
    generate
        for(i=0; i<Tn; i=i+1) begin : mult
            // Pipelined multiplier with 2 internal pipe
            // registers => 3 pipeline stages
            mult_piped MULT_PIPE (
                clk,
                i_input,
                i_synapses[ ((i+1)*N) - 1 : (i*N) ],
                o_mult_out[ ((i+1)*N) - 1 : (i*N) ]
            );
        end
    endgenerate

endmodule // End module neruon_Tn_mult


//---------------------------------------------//
// Main NFU-1 module
//---------------------------------------------//
module nfu_1_pipe (
        clk,
        i_inputs,
        i_synapses,
        o_results    
    );
    parameter N = 16;
    parameter Tn = 16;
    parameter TnxTn = 256;

    input clk;
    
    //----------- Inputs ---------------//
    // i_inputs is a vector of Tn (16) values, 16-bits each
    input [((N*Tn) - 1):0] i_inputs;
    
    // i_synapses is a matrix of Tn x Tn (16x16=256) values, 16-bits each (Row-major).
    input [((N*TnxTn) - 1):0] i_synapses;
    
    //----------- Outputs ---------------//
    output [((N*TnxTn) - 1):0] o_results;
    
    //------------- Code Start -----------------//
    genvar i;
    generate
        for(i=0; i<Tn; i=i+1) begin : Tnmult
            neuron_Tn_mult M (
                clk,
                i_inputs[ ((i+1)*N) - 1  : (i*N) ],
                i_synapses[ ((i+1)*Tn*N) - 1 : (i*Tn*N) ],
                o_results [ ((i+1)*Tn*N) - 1 : (i*Tn*N) ]
            );
        end
    endgenerate
 
endmodule // End module nfu_1


