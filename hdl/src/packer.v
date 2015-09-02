//----------------------------------------------//
//----------------------------------------------//
// Patrick Judd
// 2015-09-02
// This module packs full precision data coming from the pipeline
// into packed rows of reduced precision data
//----------------------------------------------//
//----------------------------------------------//
//
module packer (
        clk,
        i_in,
        i_s,
        i_load,
        i_row_sel,
        o_out
    );

    parameter BIT_WIDTH = 16;
    parameter SHIFT_BITS = 5;// 5 = log2(2*BIT_WIDTH) 

    input                   clk;
    input [BIT_WIDTH-1:0]   i_in;       // low precision data input
    input [SHIFT_BITS-1:0]  i_s;        // shift width
    input [2*BIT_WIDTH-1:0] i_load;     // select which bits to load from the shifter
    input                   i_row_sel;  // select the high(1) or low(0) row from the packing register
    output reg [BIT_WIDTH-1:0]  o_out;      // packed row 

    reg [2*BIT_WIDTH-1:0]    r;          // packing register
    wire [2*BIT_WIDTH-1:0]    r_in;      

    shifter #(SHIFT_BITS,2*BIT_WIDTH) bs( .in(i_in), .shift(i_s), .out(r_in) );

    // use seperate enables for each bit
    genvar j;
    generate
        for (j=0; j<2*BIT_WIDTH; j=j+1) begin : gen_reg_enable
            always @(posedge clk) begin
                if (i_load[j])
                    r [j]<= r_in[j];
            end
        end
    endgenerate

    always@(*) begin
        if (i_row_sel)
            o_out <= r[2*BIT_WIDTH-1:BIT_WIDTH];
        else
            o_out <= r[BIT_WIDTH:0];
    end

endmodule
