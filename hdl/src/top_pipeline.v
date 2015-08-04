

module top_pipeline (
    clk,
    i_image,
    i_synapse,
    i_sigmoid_coef,
    i_load_sigmoid_coef,
    o_results
);

parameter BIT_WIDTH = 16;
parameter Tn = 16;
parameter TnxTn = 256;

//----------- Input Ports ---------------//
input clk;

// i_image is a vector of Tn (16) values, 16-bits each
input [((BIT_WIDTH*Tn) - 1):0] i_image;


// i_synapse is a matrix of Tn x Tn (16x16=256) values, 16-bits each (Row-major).
input [((BIT_WIDTH*TnxTn) - 1):0] i_synapse;

input [((2*BIT_WIDTH)-1):0] i_sigmoid_coef;
input i_load_sigmoid_coef;

//----------- Output Ports ---------------//
output [((BIT_WIDTH*Tn) - 1):0] o_results;


//----------- Internal Signals --------------//
wire [((BIT_WIDTH*TnxTn) - 1):0] nfu1_out;
//wire [((BIT_WIDTH*TnxTn) - 1):0] nfu2_in;
wire [ (BIT_WIDTH*Tn) - 1 : 0 ] nfu2_out;

//wire [ (BIT_WIDTH*Tn) - 1 : 0 ] nfu3_in;
wire [ (BIT_WIDTH*Tn) - 1 : 0 ] nfu3_out;


// Main pipe regs
reg [((BIT_WIDTH*TnxTn) - 1):0] nfu1_nfu2_pipe_reg;
reg [ (BIT_WIDTH*Tn) - 1 : 0 ] nfu2_nfu3_pipe_reg;

wire [ (BIT_WIDTH*Tn) - 1 : 0 ] nbout_to_nfu2;
wire nbout_en = 1'b0;


assign o_results = nfu3_out;

// NFU-1
nfu_1 n1 (clk, i_image, i_synapse, nfu1_out);

// NFU-2
nfu_2 n2(clk, nfu1_nfu2_pipe_reg, nbout_to_nfu2, nbout_en, nfu2_out);

// NFU-3
nfu_3 n3(clk, nfu2_nfu3_pipe_reg, i_sigmoid_coef, i_load_sigmoid_coef, nfu3_out);


always @(posedge clk) begin
    nfu2_nfu3_pipe_reg = nfu2_out;
    nfu1_nfu2_pipe_reg = nfu1_out;
end


endmodule






