//----------------------------------------------//
//----------------------------------------------//
// Patrick Judd
// 2015-09-02
// This module is a wrapper for the packer and rounder
//----------------------------------------------//
//----------------------------------------------//
//
module nbout_packer (
        clk,
        i_in,
        i_s,
        i_load,
        i_row_sel,
        i_n,
        i_offset,
        o_out
    );

    parameter BIT_WIDTH = 16;
    parameter SHIFT_BITS = 5;// 5 = log2(2*BIT_WIDTH) 
    parameter BIT_IDX = 4;

    input                   clk;
    input [BIT_WIDTH-1:0]   i_in;       // low precision data input
    input [SHIFT_BITS-1:0]  i_s;        // shift width
    input [2*BIT_WIDTH-1:0] i_load;     // select which bits to load from the shifter
    input                   i_row_sel;  // select the high(1) or low(0) row from the packing register
    input [BIT_IDX-1:0]     i_n;        // reduced precision
    input [BIT_IDX-1:0]     i_offset;   // offset for reducing the fractional part
    output wire [BIT_WIDTH-1:0]  o_out;      // packed row 

    wire [BIT_WIDTH-1:0] rounder_out;

rounder rdr (
        .i_in(i_in),
        .i_n(i_n),
        .i_offset(i_offset),
        .o_out(rounder_out)
    );
packer pkr (
        .clk(clk),
        .i_in(i_in),
        .i_s(i_s),
        .i_load(i_load),
        .i_row_sel(i_row_sel),
        .o_out(o_out)
    );
endmodule
