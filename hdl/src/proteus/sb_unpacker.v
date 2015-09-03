//----------------------------------------------//
//----------------------------------------------//
// Patrick Judd
// 2015-09-02
// This module is a wrapper for the unpacker
// which includes zero extension for the weights
// since weights are strictly between 0 and 1
//----------------------------------------------//
//----------------------------------------------//
module sb_unpacker (
        clk,
        i_in,
        i_load,
        i_s,
        i_z,
        o_out
    );

    parameter BIT_WIDTH = 16;
    parameter SHIFT_BITS = 5;// 5 = log2(2*BIT_WIDTH) 

    input                   clk;
    input [BIT_WIDTH-1:0]   i_in;
    input [1:0]             i_load; // load the MS or LS row in the unpacking register
    input [SHIFT_BITS-1:0]  i_s;    // shift width
    input [BIT_WIDTH-1:0]   i_z;    // bit mask for zero extension
    output [BIT_WIDTH-1:0]  o_out;

    wire [BIT_WIDTH-1:0]    unpkr_out;

unpacker unpkr(
        .clk(clk),
        .i_in(i_in),
        .i_load(i_load),
        .i_s(i_s),
        .o_out(unpkr_out)
    );

// zero extension
assign o_out = unpkr_out & i_z;

endmodule
