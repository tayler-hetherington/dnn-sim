//----------------------------------------------//
//----------------------------------------------//
// NFU-1: Convolution multiplication
// Tayler Hetherington
// 2015
//----------------------------------------------//
//----------------------------------------------//

module neuron_Tn_mult (
    i_input,
    i_synapse,
    o_mult_out
);

parameter BIT_WIDTH = 16;
parameter Tn = 16;

//----------- Input Ports ---------------//
// Single input value
input [(BIT_WIDTH - 1):0] i_input;

// Tn synapses per input value
input [((BIT_WIDTH*Tn) - 1):0] i_synapse;

//----------- Output Ports ---------------//
// Tn outputs
output [((BIT_WIDTH*Tn) - 1):0] o_mult_out;

genvar i;
generate
    for(i=0; i<Tn; i=i+1) begin : mult
        qmult #(.Q(10), .N(16)) qm (
            i_input,
            i_synapse[ ((i+1)*BIT_WIDTH) - 1 : (i*BIT_WIDTH) ],
            o_mult_out[ ((i+1)*BIT_WIDTH) - 1 : (i*BIT_WIDTH) ]
        );
    end
endgenerate

endmodule



module nfu_1 (
    clk,
    i_image,
    i_synapse,
    o_results    
);
parameter BIT_WIDTH = 16;
parameter Tn = 16;
parameter TnxTn = 256;

input clk;

//----------- Input Ports ---------------//
// i_image is a vector of Tn (16) values, 16-bits each
input [((BIT_WIDTH*Tn) - 1):0] i_image;


// i_synapse is a matrix of Tn x Tn (16x16=256) values, 16-bits each (Row-major).
input [((BIT_WIDTH*TnxTn) - 1):0] i_synapse;


//----------- Output Ports ---------------//
output [((BIT_WIDTH*TnxTn) - 1):0] o_results;


//------------- Code Start -----------------//
genvar i;
generate
    for(i=0; i<Tn; i=i+1) begin : Tnmult
        neuron_Tn_mult M (
            i_image[ ((i+1)*BIT_WIDTH) - 1  : (i*BIT_WIDTH) ],
            i_synapse[ ((i+1)*Tn*BIT_WIDTH) - 1 : (i*Tn*BIT_WIDTH) ],
            o_results [ ((i+1)*Tn*BIT_WIDTH) - 1 : (i*Tn*BIT_WIDTH) ]
        );
    end
endgenerate


endmodule // End nfu_1



