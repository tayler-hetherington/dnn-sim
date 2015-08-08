//----------------------------------------------//
//----------------------------------------------//
// Tayler Hetherington
// 2015
// File contains common hardware blocks used
// throughout the pipeline.
//----------------------------------------------//
//----------------------------------------------//

//---------- 2-to-1 MUX
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
    case (i_sel) // synopsys infer_mux full_case parallel_case
        1'b0: B = i_A0;
        1'b1: B = i_A1;
    endcase
end

endmodule // End mux_2_to_1

//--------------------------------------------

//---------- 4-to-1 MUX
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
    case (i_sel) // synopsys infer_mux full_case parallel_case
        2'b00: B = i_A0;
        2'b01: B = i_A1;
        2'b10: B = i_A2;
        2'b11: B = i_A3;        
    endcase
end

endmodule // End mux_4_to_1 


//---------- 6-to-1 MUX
module mux_6_to_1 #(parameter BIT_WIDTH=16) (
    i_sel,
    i_A0,
    i_A1,
    i_A2,
    i_A3,
    i_A4,
    i_A5,
    o_B
);

input [2:0] i_sel;
input [(BIT_WIDTH-1):0] i_A0, i_A1, i_A2, i_A3, i_A4, i_A5;

output [(BIT_WIDTH-1):0] o_B;

reg [(BIT_WIDTH-1):0] B;

assign o_B = B;

always @(i_sel or i_A0 or i_A1 or i_A2 or i_A3 or i_A4 or i_A5) begin
    case (i_sel)  // synopsys infer_mux full_case parallel_case
        3'b000: B = i_A0;
        3'b001: B = i_A1;
        3'b010: B = i_A2;
        3'b011: B = i_A3;        
        3'b100: B = i_A4;
        3'b101: B = i_A5; // Missing last two cases, should ignore
    endcase
end


endmodule // End mux_6_to_1

//----------------------------------------------
//---------- 8-to-1 MUX
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
    case (i_sel) // synopsys infer_mux full_case parallel_case
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
    case (i_sel) // synopsys infer_mux full_case parallel_case
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


//---------- 16-to-1_v2 MUX
module mux_16_to_1_v2 (
    i_sel,
    i_A,
    o_B
);

parameter BIT_WIDTH = 16;
parameter SEL_WIDTH = 4;
parameter NUM_INPUTS = 1 << SEL_WIDTH;

input [(SEL_WIDTH-1):0]     i_sel;
input [(BIT_WIDTH-1):0]     i_A;

output [(BIT_WIDTH-1):0]    o_B;

reg [(BIT_WIDTH-1):0] B;

assign o_B = B;

always @(i_sel or i_A) begin
    case (i_sel) // synopsys infer_mux full_case parallel_case
        4'b0000: B = i_A[BIT_WIDTH - 1 : 0];
        4'b0001: B = i_A[(2*BIT_WIDTH)-1:(1*BIT_WIDTH)];
        4'b0010: B = i_A[(3*BIT_WIDTH)-1:(2*BIT_WIDTH)];
        4'b0011: B = i_A[(4*BIT_WIDTH)-1:(3*BIT_WIDTH)];
        4'b0100: B = i_A[(5*BIT_WIDTH)-1:(4*BIT_WIDTH)];
        4'b0101: B = i_A[(6*BIT_WIDTH)-1:(5*BIT_WIDTH)];
        4'b0110: B = i_A[(7*BIT_WIDTH)-1:(6*BIT_WIDTH)];
        4'b0111: B = i_A[(8*BIT_WIDTH)-1:(7*BIT_WIDTH)];
        4'b1000: B = i_A[(9*BIT_WIDTH)-1:(8*BIT_WIDTH)];
        4'b1001: B = i_A[(10*BIT_WIDTH)-1:(9*BIT_WIDTH)];
        4'b1010: B = i_A[(11*BIT_WIDTH)-1:(10*BIT_WIDTH)];
        4'b1011: B = i_A[(12*BIT_WIDTH)-1:(11*BIT_WIDTH)];
        4'b1100: B = i_A[(13*BIT_WIDTH)-1:(12*BIT_WIDTH)];
        4'b1101: B = i_A[(14*BIT_WIDTH)-1:(13*BIT_WIDTH)];
        4'b1110: B = i_A[(15*BIT_WIDTH)-1:(14*BIT_WIDTH)];
        4'b1111: B = i_A[(16*BIT_WIDTH)-1:(15*BIT_WIDTH)];
    endcase
end

endmodule // End mux_16_to_1




// 81:1 MUX for D=5,W=15
module mux_81_to_1 (
        i_sel,
        i_A,
        o_B
    );

    parameter BIT_WIDTH = 16;
    parameter SEL_WIDTH = 7;
    parameter NUM_INPUTS = 81;
    parameter NUM_FULL_16 = 5;
    
    input [(SEL_WIDTH-1):0]     i_sel;
    input [(NUM_INPUTS*BIT_WIDTH-1):0]     i_A;

    output [(BIT_WIDTH-1):0]    o_B;

    wire [ (NUM_FULL_16*BIT_WIDTH)-1 : 0 ] mux_16_outs;


    // 5 x 16:1 Muxes
    genvar i;
    generate
        for(i=0; i<NUM_FULL_16; i=i+1) begin : T1
            mux_16_to_1_v2 M0 (
                i_sel[ (SEL_WIDTH-3) - 1 : 0],
                i_A[ ((i+2)*16*BIT_WIDTH) - 1 : (i+1)*16*BIT_WIDTH ],
                mux_16_outs[ ((i+1)*BIT_WIDTH)-1 : i*BIT_WIDTH ] 
            );
        end
    endgenerate
   
    // 1 x 6:1 MUX
    mux_6_to_1 M1 (
        i_sel[ (SEL_WIDTH-1) : (SEL_WIDTH-3) ],
        i_A[BIT_WIDTH-1:0],
        mux_16_outs[BIT_WIDTH-1:0],
        mux_16_outs[(2*BIT_WIDTH)-1:(BIT_WIDTH)],
        mux_16_outs[(3*BIT_WIDTH)-1:(2*BIT_WIDTH)],
        mux_16_outs[(4*BIT_WIDTH)-1:(3*BIT_WIDTH)],
        mux_16_outs[(5*BIT_WIDTH)-1:(4*BIT_WIDTH)],
        o_B 
    );

endmodule



module ram (
        clk, 
        i_address,
        i_data, 
        i_we, 
        i_oe,
        o_data
    ); 

    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 8 ;
    parameter RAM_DEPTH = 1 << ADDR_WIDTH;

    //--------------Input Ports----------------------- 
    input                  clk;
    input [ADDR_WIDTH-1:0] i_address;
    input                  i_we;
    input                  i_oe; 

    //--------------Inout Ports----------------------- 
    input [DATA_WIDTH-1:0]  i_data;
    output [DATA_WIDTH-1:0]  o_data;

    //--------------Internal variables---------------- 
    reg [DATA_WIDTH-1:0] data_out ;
    reg [DATA_WIDTH-1:0] mem [0:RAM_DEPTH-1];
    reg                  oe_r;

    //--------------Code Starts Here------------------ 
    // Output
    assign o_data = (i_oe && !i_we) ? data_out : 8'bz; 

    // Write
    //always @ (posedge clk) begin
    //    if ( i_we ) begin
    //         mem[i_address] = i_o_data;
    //    end
    //end

    always @ (posedge clk) begin
        if( i_we ) begin
            mem[i_address] = i_data;
        end
        else if (i_oe) begin
            data_out = mem[i_address];
            oe_r = 1;
        end 
        else begin
            oe_r = 0;
        end
    end

endmodule
