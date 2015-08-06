//---------- 2-to-1 MUX ----------//
//infer_mux
module mux_2_to_1 (
    i_sel,
    i_A,
    o_B
);

parameter BIT_WIDTH = 16;
parameter SEL_WIDTH = 1;
parameter NUM_INPUTS = 1 << SEL_WIDTH;

input [SEL_WIDTH-1:0] i_sel;
input [(BIT_WIDTH*NUM_INPUTS) - 1 : 0] i_A;
output [(BIT_WIDTH-1):0] o_B;

reg [(BIT_WIDTH-1):0] B;

assign o_B = B;

integer i;
always @(i_sel or i_A) begin
    case (i_sel)
        1'b0: B = i_A[ BIT_WIDTH - 1 : 0 ];
        1'b1: B = i_A[ (2*BIT_WIDTH) - 1 : BIT_WIDTH ];
    endcase
end

endmodule // End mux_2_to_1

//-------------------------------------------------------//

//---------- 4-to-1 MUX ----------//
//infer_mux
module mux_4_to_1 (
    i_sel,
    i_A,
    o_B
);

parameter BIT_WIDTH = 16;
parameter SEL_WIDTH = 2;
parameter NUM_INPUTS = 1 << SEL_WIDTH;

input [SEL_WIDTH-1:0] i_sel;
input [(BIT_WIDTH*NUM_INPUTS) - 1 : 0] i_A;
output [(BIT_WIDTH-1):0] o_B;

reg [(BIT_WIDTH-1):0] B;

assign o_B = B;

integer i;
always @(i_sel or i_A) begin
    case (i_sel)
        2'b00: B = i_A[ BIT_WIDTH - 1 : 0 ];
        2'b01: B = i_A[ (2*BIT_WIDTH) - 1 : BIT_WIDTH ];
        2'b00: B = i_A[ (3*BIT_WIDTH) - 1 : 2*BIT_WIDTH ];
        2'b01: B = i_A[ (4*BIT_WIDTH) - 1 : 3*BIT_WIDTH ];
    endcase
end

endmodule // End mux_4_to_1

//---------- 16-to-1 MUX----------//
//infer_mux
module mux_16_to_1 (
    i_sel,
    i_A,
    o_B
);

parameter BIT_WIDTH = 16;
parameter NUM_INPUTS = 16;

input [3:0] i_sel;
input [(BIT_WIDTH*NUM_INPUTS) - 1 : 0] i_A;
output [(BIT_WIDTH-1):0] o_B;

reg [(BIT_WIDTH-1):0] B;

assign o_B = B;

integer i;
always @(i_sel or i_A) begin
    case (i_sel)
        4'b0000: B = i_A[ BIT_WIDTH - 1 : 0 ];
        4'b0001: B = i_A[ (2*BIT_WIDTH) - 1 : BIT_WIDTH ];
        4'b0010: B = i_A[ (3*BIT_WIDTH) - 1 : 2*BIT_WIDTH ];
        4'b0011: B = i_A[ (4*BIT_WIDTH) - 1 : 3*BIT_WIDTH ];
        4'b0100: B = i_A[ (5*BIT_WIDTH) - 1 : 4*BIT_WIDTH ];
        4'b0101: B = i_A[ (6*BIT_WIDTH) - 1 : 5*BIT_WIDTH ];
        4'b0110: B = i_A[ (7*BIT_WIDTH) - 1 : 6*BIT_WIDTH ];
        4'b0111: B = i_A[ (8*BIT_WIDTH) - 1 : 7*BIT_WIDTH ];
        4'b1000: B = i_A[ (9*BIT_WIDTH) - 1 : 8*BIT_WIDTH ];
        4'b1001: B = i_A[ (10*BIT_WIDTH) - 1 : 9*BIT_WIDTH ];
        4'b1010: B = i_A[ (11*BIT_WIDTH) - 1 : 10*BIT_WIDTH ];
        4'b1011: B = i_A[ (12*BIT_WIDTH) - 1 : 11*BIT_WIDTH ];
        4'b1100: B = i_A[ (13*BIT_WIDTH) - 1 : 12*BIT_WIDTH ];
        4'b1101: B = i_A[ (14*BIT_WIDTH) - 1 : 13*BIT_WIDTH ];
        4'b1110: B = i_A[ (15*BIT_WIDTH) - 1 : 14*BIT_WIDTH ];
        4'b1111: B = i_A[ (16*BIT_WIDTH) - 1 : 15*BIT_WIDTH ];        
    endcase
end

endmodule // End mux_16_to_1

