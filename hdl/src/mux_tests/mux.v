
//---------- 2-to-1 MUX
//infer_mux
module mux_2_to_1 #(parameter BIT_WIDTH = 16) (
    i_sel,
    i_A0,
    i_A1,
    o_B
);

input i_sel;
input [(BIT_WIDTH-1):0] i_A0, i_A1;

output [(BIT_WIDTH-1):0] o_B;

reg [(BIT_WIDTH-1):0] B;

assign o_B = B;

always @(i_sel or i_A0 or i_A1) begin
    case (i_sel)
        1'b0: B = i_A0;
        1'b1: B = i_A1;
    endcase
end

endmodule // End mux_2_to_1

//--------------------------------------------

//---------- 4-to-1 MUX
//infer_mux
module mux_4_to_1 #(parameter BIT_WIDTH=16) (
    i_sel,
    i_A0,
    i_A1,
    i_A2,
    i_A3,
    o_B
);

input [1:0] i_sel;
input [(BIT_WIDTH-1):0] i_A0, i_A1, i_A2, i_A3;

output [(BIT_WIDTH-1):0] o_B;

reg [(BIT_WIDTH-1):0] B;

assign o_B = B;

always @(i_sel or i_A0 or i_A1 or i_A2 or i_A3) begin
    case (i_sel)
        2'b00: B = i_A0;
        2'b01: B = i_A1;
        2'b10: B = i_A2;
        2'b11: B = i_A3;        
    endcase
end

endmodule // End mux_4_to_1 

//----------------------------------------------

//---------- 8-to-1 MUX
//infer_mux
module mux_8_to_1 #(parameter BIT_WIDTH=16) (
    i_sel,
    i_A0,
    i_A1,
    i_A2,
    i_A3,
    i_A4,
    i_A5,
    i_A6,
    i_A7,
   
    o_B
);

input [2:0] i_sel;
input [(BIT_WIDTH-1):0] i_A0, i_A1, i_A2, i_A3, i_A4, i_A5, i_A6, i_A7;

output [(BIT_WIDTH-1):0] o_B;

reg [(BIT_WIDTH-1):0] B;

assign o_B = B;

always @(i_sel or i_A0 or i_A1 or i_A2 or i_A3 or i_A4 or i_A5 or i_A6 or i_A7) begin
    case (i_sel)
        3'b000: B = i_A0;
        3'b001: B = i_A1;
        3'b010: B = i_A2;
        3'b011: B = i_A3;        
        3'b100: B = i_A4;
        3'b101: B = i_A5;
        3'b110: B = i_A6;
        3'b111: B = i_A7;  
    endcase
end

endmodule // End mux_8_to_1 

//---------- 16-to-1 MUX
//infer_mux
module mux_16_to_1 #(parameter BIT_WIDTH=16) (
    i_sel,
    i_A0,
    i_A1,
    i_A2,
    i_A3,
    i_A4,
    i_A5,
    i_A6,
    i_A7,
    i_A8,
    i_A9,
    i_A10,
    i_A11,
    i_A12,
    i_A13,
    i_A14,
    i_A15,
    o_B
);

input [3:0] i_sel;
input [(BIT_WIDTH-1):0] i_A0, i_A1, i_A2, i_A3, i_A4, i_A5, i_A6, i_A7, i_A8, i_A9, i_A10, i_A11, i_A12, i_A13, i_A14, i_A15;

output [(BIT_WIDTH-1):0] o_B;

reg [(BIT_WIDTH-1):0] B;

assign o_B = B;

always @(i_sel or i_A0 or i_A1 or i_A2 or i_A3 or i_A4 or i_A5 or i_A6 or i_A7 or i_A8 or i_A9 or i_A10 or i_A11 or i_A12 or i_A13 or i_A14 or i_A15) begin
    case (i_sel)
        4'b0000: B = i_A0;
        4'b0001: B = i_A1;
        4'b0010: B = i_A2;
        4'b0011: B = i_A3;
        4'b0100: B = i_A4;
        4'b0101: B = i_A5;
        4'b0110: B = i_A6;
        4'b0111: B = i_A7;
        4'b1000: B = i_A8;
        4'b1001: B = i_A9;
        4'b1010: B = i_A10;
        4'b1011: B = i_A11;
        4'b1100: B = i_A12;
        4'b1101: B = i_A13;
        4'b1110: B = i_A14;
        4'b1111: B = i_A15;        
    endcase
end

endmodule // End mux_16_to_1

