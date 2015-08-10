//----------------------------------------------//
//----------------------------------------------//
// NFU-1: Convolution multiplication
// Tayler Hetherington
// 2015
//----------------------------------------------//
//----------------------------------------------//

module neuron_Tn_mult (
        i_input,
        i_synapses,
        o_mult_out
    );

    parameter BIT_WIDTH = 16;
    parameter Tn = 16;

    //----------- Inputs ---------------//
    // Single 16-bit input value
    input [(BIT_WIDTH - 1):0] i_input;

    // Tn 16-bit synapses per input value
    input [((BIT_WIDTH*Tn) - 1):0] i_synapses;

    //----------- Outputs ---------------//
    // Tn 16-bit outputs
    output [((BIT_WIDTH*Tn) - 1):0] o_mult_out;

    //------------- Code Start -------------//
    genvar i;
    generate
        for(i=0; i<Tn; i=i+1) begin : mult

            int_mult MULT0 (
                i_input,
                i_synapses[ ((i+1)*BIT_WIDTH) - 1 : (i*BIT_WIDTH) ],
                o_mult_out[ ((i+1)*BIT_WIDTH) - 1 : (i*BIT_WIDTH) ]
            );

            /*
            qmult #(.Q(10), .N(16)) qm (
                i_input,
                i_synapses[ ((i+1)*BIT_WIDTH) - 1 : (i*BIT_WIDTH) ],
                o_mult_out[ ((i+1)*BIT_WIDTH) - 1 : (i*BIT_WIDTH) ]
            );
            */

        end
    endgenerate

endmodule // End module neruon_Tn_mult


//---------------------------------------------//
// Main NFU-1 module
//---------------------------------------------//
module nfu_1 (
        clk,
        i_inputs,
        i_synapses,
        o_results    
    );
    parameter BIT_WIDTH = 16;
    parameter Tn = 16;
    parameter TnxTn = 256;

    input clk;
    
    //----------- Inputs ---------------//
    // i_inputs is a vector of Tn (16) values, 16-bits each
    input [((BIT_WIDTH*Tn) - 1):0] i_inputs;
    
    
    // i_synapses is a matrix of Tn x Tn (16x16=256) values, 16-bits each (Row-major).
    input [((BIT_WIDTH*TnxTn) - 1):0] i_synapses;
    
    
    //----------- Outputs ---------------//
    output [((BIT_WIDTH*TnxTn) - 1):0] o_results;
    
    
    //------------- Code Start -----------------//
    genvar i;
    generate
        for(i=0; i<Tn; i=i+1) begin : Tnmult
            neuron_Tn_mult M (
                i_inputs[ ((i+1)*BIT_WIDTH) - 1  : (i*BIT_WIDTH) ],
                i_synapses[ ((i+1)*Tn*BIT_WIDTH) - 1 : (i*Tn*BIT_WIDTH) ],
                o_results [ ((i+1)*Tn*BIT_WIDTH) - 1 : (i*Tn*BIT_WIDTH) ]
            );
        end
    endgenerate
 
endmodule // End module nfu_1


//---------------------------------------------//
// Main NFU-1 module
//---------------------------------------------//
module nfu_1_B (
        clk,
        i_inputs,
        i_synapses,
        o_results    
    );

    parameter BIT_WIDTH = 16;
    parameter Tn = 16;
    parameter TnxTn = 256;

    input clk;
    
    //----------- Inputs ---------------//
    // i_inputs is a vector of Tn (16) values, 16-bits each
    input [((BIT_WIDTH*TnxTn) - 1):0] i_inputs;
    
    
    // i_synapses is a matrix of Tn x Tn (16x16=256) values, 16-bits each (Row-major).
    input [((BIT_WIDTH*TnxTn) - 1):0] i_synapses;
    
    
    //----------- Outputs ---------------//
    output [((BIT_WIDTH*TnxTn) - 1):0] o_results;
    
    
    //------------- Code Start -----------------//
    genvar i;
    generate
        for(i=0; i<TnxTn; i=i+1) begin : TnxTnmult
            /*
            int_mult MULT0 (
                i_inputs[ ((i+1)*BIT_WIDTH) - 1 : (i*BIT_WIDTH) ],
                i_synapses[ ((i+1)*BIT_WIDTH) - 1 : (i*BIT_WIDTH) ],
                o_results[ ((i+1)*BIT_WIDTH) - 1 : (i*BIT_WIDTH) ]
            );
            */
            
            qmult #(.Q(10), .N(16)) qm (
                i_inputs[ ((i+1)*BIT_WIDTH) - 1 : (i*BIT_WIDTH) ],
                i_synapses[ ((i+1)*BIT_WIDTH) - 1 : (i*BIT_WIDTH) ],
                o_results[ ((i+1)*BIT_WIDTH) - 1 : (i*BIT_WIDTH) ]
            );
            
        end
    endgenerate
 
endmodule // End module nfu_1

