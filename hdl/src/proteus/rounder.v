//----------------------------------------------//
//----------------------------------------------//
// Patrick Judd
// 2015-09-02
// This module rounds the input full precision data to the reduced precision
// specified by i_n and i_offset
// No shifting needs to be done here since it can be combined with the shift
// in the packer
//----------------------------------------------//
//----------------------------------------------//

module rounder 
    (
        i_in,
        i_n,
        i_offset,
        o_out
    );

    parameter BIT_WIDTH = 16;
    parameter BIT_IDX = 4;

    input [BIT_WIDTH-1:0]   i_in;
    input [BIT_IDX-1:0]     i_n;        // reduced precision
    input [BIT_IDX-1:0]     i_offset;   // offset for reducing the fractional part
    output reg [BIT_WIDTH-1:0]  o_out;

    wire is_big_pos;
    wire is_big_neg;

    wire max_pos = 2**(i_n+i_offset)-1;
    wire min_neg = -1 * (2**(i_n+i_offset)-1);

    assign is_big_pos = i_in > max_pos;
    assign is_big_neg = i_in < min_neg;

    always@(*) begin
        if (is_big_pos) begin
            o_out = max_pos;
        end
        else if (is_big_neg) begin
            o_out = min_neg;
        end
        else if (i_offset > 0) begin
            // if we are truncating off a 1 in the MSB, round up
            o_out = i_in + 2**(i_offset-1);
        end
        else begin
            o_out = i_in;
        end
    end
endmodule
