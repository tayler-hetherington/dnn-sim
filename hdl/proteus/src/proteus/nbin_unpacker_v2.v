//----------------------------------------------//
//----------------------------------------------//
// Patrick Judd
// 2015-09-02
// This module is a wrapper for the unpacker
// which includes sign extension for the inputs
//----------------------------------------------//
//----------------------------------------------//
module nbin_unpacker_v2 (
        clk,
        i_in,
        i_load,
        i_s,
        i_n,
        i_se,
        i_ze,
        o_out
    );

    parameter N = 16;
    parameter SHIFT_BITS = 5;// 5 = log2(2*N) 

    input                   clk;
    input [N-1:0]           i_in;
    input [1:0]             i_load; // load the MS or LS row in the unpacking register
    input [SHIFT_BITS-1:0]  i_s;    // shift width
    input [SHIFT_BITS-2:0]  i_n;    // reduced precision bit width
    input [N-1:0]           i_se;    // bit mask for sign extension
    input [N-1:0]           i_ze;    // bit mask for zero extension for fractional bits
    output [N-1:0]          o_out;

    wire [N-1:0]            unpkr_out;
    wire                    sign_bit;
    reg [N-1:0]             se_out;

    unpacker unpkr(
            .clk(clk),
            .i_in(i_in),
            .i_load(i_load),
            .i_s(i_s),
            .o_out(unpkr_out)
        );

    assign sign_bit = unpkr_out[i_n-1];

    genvar j;
    generate
        for (j=0; j<N; j=j+1) begin : gen_se
            always @(*) begin
                if (i_se[j]) begin
                    se_out[j] = sign_bit;
                end
                else begin
                    se_out[j] = unpkr_out[j];
                end
            end
        end
    endgenerate

    // zero extend for fractional bits
    assign o_out = se_out & i_ze;

endmodule
