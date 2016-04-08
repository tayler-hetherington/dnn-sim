//----------------------------------------------//
//----------------------------------------------//
// Patrick Judd
// 2016-04-08
// This module rounds the input full precision data to the reduced precision
// specified by i_min and i_max
//----------------------------------------------//
//----------------------------------------------//

module rounder 
    (
        i_in,
        i_max,
        i_min,
        i_offset,
        o_out
    );

    parameter N = 16;
    parameter BIT_IDX = 4;

    input [N-1:0]           i_in;
    input [N-1:0]           i_max;
    input [N-1:0]           i_min;
    input [BIT_IDX-1:0]     i_offset;   // offset for reducing the fractional part
    output reg [N-1:0]      o_out;

    reg is_big_pos;
    reg is_big_neg;

    //wire max_pos = 2**(i_n+i_offset)-1;
    //wire min_neg = -1 * (2**(i_n+i_offset)-1);


    always@(*) begin
        is_big_pos = i_in > i_max;
        is_big_neg = i_in < i_min;
        if (is_big_pos) begin
            o_out = i_max;
        end
        else if (is_big_neg) begin
            o_out = i_min;
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
