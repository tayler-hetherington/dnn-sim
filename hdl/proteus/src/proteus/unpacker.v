//----------------------------------------------//
//----------------------------------------------//
// Patrick Judd
// 2015-09-02
// This module unpacks reduced precision data that was packed into
// BIT_WIDTH rows and outputs them at BIT_WIDTH bits
//----------------------------------------------//
//----------------------------------------------//
module unpacker (
        clk,
        i_in,
        i_load,
        i_s,
        o_out
    );

    parameter BIT_WIDTH = 16;
    parameter SHIFT_BITS = 5;// 5 = log2(2*BIT_WIDTH) 

    input                   clk;
    input [BIT_WIDTH-1:0]   i_in;
    input [1:0]             i_load; // load the MS or LS row in the unpacking register
    input [SHIFT_BITS-1:0]  i_s;    // shift width
    output [BIT_WIDTH-1:0]  o_out;

    
    wire [2*BIT_WIDTH-1:0]   s_o;
    reg [2*BIT_WIDTH-1:0]    r;      // unpacking register

    always@(posedge clk) begin
        if (i_load[1])
            r[2*BIT_WIDTH-1:BIT_WIDTH] <= i_in;
        if (i_load[0]) 
            r[BIT_WIDTH-1:0] <= i_in;
    end
    //shifter #(.CTRL(SHIFT_BITS)) bs(.in(r), .shift(i_s), .out(o_out) );
    shifter #(.CTRL(SHIFT_BITS)) bs(.in(r), .shift(i_s), .out(s_o) );

    assign o_out = s_o[BIT_WIDTH-1:0];

endmodule
