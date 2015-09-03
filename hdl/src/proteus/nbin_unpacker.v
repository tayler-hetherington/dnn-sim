//----------------------------------------------//
//----------------------------------------------//
// Patrick Judd
// 2015-09-02
// This module is a wrapper for the unpacker
// which includes sign extension for the inputs
//----------------------------------------------//
//----------------------------------------------//
module nbin_unpacker (
        clk,
        i_in,
        i_load,
        i_s,
        i_n,
        i_se,
        o_out
    );

    parameter BIT_WIDTH = 16;
    parameter SHIFT_BITS = 5;// 5 = log2(2*BIT_WIDTH) 

    input                   clk;
    input [BIT_WIDTH-1:0]   i_in;
    input [1:0]             i_load; // load the MS or LS row in the unpacking register
    input [SHIFT_BITS-1:0]  i_s;    // shift width
    input [SHIFT_BITS-2:0]  i_n;    // reduced precision bit width
    input [BIT_WIDTH-1:0]   i_se;    // bit mask for sign extension
    output reg [BIT_WIDTH-1:0]  o_out;

    wire [BIT_WIDTH-1:0]    unpkr_out;
    wire sign_bit;

    unpacker unpkr(
            .clk(clk),
            .i_in(i_in),
            .i_load(i_load),
            .i_s(i_s),
            .o_out(unpkr_out)
        );

    // zero extension
    assign sign_bit = unpkr_out[i_n-1];

    genvar j;
    generate
        for (j=0; j<BIT_WIDTH; j=j+1) begin : gen_se
            always @(*) begin
                if (i_se[j]) begin
                    o_out[j] = i_se[j];
                end
                else begin
                    o_out[j] = unpkr_out[j];
                end
            end
        end
    endgenerate

endmodule
