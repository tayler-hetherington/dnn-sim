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

    parameter N = 16;
    parameter SHIFT_BITS = 5;// 5 = log2(2*N) 

    input                   clk;
    input [N-1:0]   i_in;
    input [1:0]             i_load; // load the MS or LS row in the unpacking register
    input [SHIFT_BITS-1:0]  i_s;    // shift width
    input [N-1:0]   i_z;    // bit mask for zero extension
    output [N-1:0]  o_out;

    wire [N-1:0]    unpkr_out;

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
