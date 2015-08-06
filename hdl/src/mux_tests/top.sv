

module top_level (
        i_inputs,
        i_sel,
        o_outputs
    );

    parameter BIT_WIDTH = 16;
    parameter SEL_WIDTH = 6;
    parameter NUM_INPUTS = 1 << SEL_WIDTH;

    input [(BIT_WIDTH-1):0] i_inputs [0 : (NUM_INPUTS-1)];
    input [(SEL_WIDTH-1):0] i_sel;
    output [(BIT_WIDTH-1):0] o_outputs;

/*
   mux_N  #(.BIT_WIDTH(BIT_WIDTH), .SEL_WIDTH(SEL_WIDTH), .NUM_INPUTS(NUM_INPUTS)) M0 (
       i_sel,
       i_inputs,
       o_outputs
   );
*/
/*
    mux_2_to_1 M0 (
        i_sel,
        i_inputs[0],
        i_inputs[1],
        o_outputs
    );
*/
/*
    mux_4_to_1 M0 (
        i_sel,
        i_inputs[0],
        i_inputs[1],
        i_inputs[2],
        i_inputs[3],     
        o_outputs
    );
*/
/*
    mux_8_to_1 M0 (
        i_sel,
        i_inputs[0],
        i_inputs[1],
        i_inputs[2],
        i_inputs[3],    
        i_inputs[4],
        i_inputs[5],
        i_inputs[6],
        i_inputs[7],   
        o_outputs
    );
*/
/*
    mux_16_to_1 M0 (
        i_sel,
        i_inputs[0],
        i_inputs[1],
        i_inputs[2],
        i_inputs[3],    
        i_inputs[4],
        i_inputs[5],
        i_inputs[6],
        i_inputs[7],   
        i_inputs[8],
        i_inputs[9],
        i_inputs[10],
        i_inputs[11],    
        i_inputs[12],
        i_inputs[13],
        i_inputs[14],
        i_inputs[15],         
        o_outputs
    );
*/

/*
// 32-to-1
    wire [(BIT_WIDTH-1):0] o_1, o_2;
    mux_16_to_1 M0 (
        i_sel[SEL_WIDTH-1:1],
        i_inputs[0],
        i_inputs[1],
        i_inputs[2],
        i_inputs[3],    
        i_inputs[4],
        i_inputs[5],
        i_inputs[6],
        i_inputs[7],   
        i_inputs[8],
        i_inputs[9],
        i_inputs[10],
        i_inputs[11],    
        i_inputs[12],
        i_inputs[13],
        i_inputs[14],
        i_inputs[15],         
        o_1
    );
     mux_16_to_1 M2 (
        i_sel[SEL_WIDTH-1:1],
        i_inputs[16],
        i_inputs[17],
        i_inputs[18],
        i_inputs[19],    
        i_inputs[20],
        i_inputs[21],
        i_inputs[22],
        i_inputs[23],   
        i_inputs[24],
        i_inputs[25],
        i_inputs[26],
        i_inputs[27],    
        i_inputs[28],
        i_inputs[29],
        i_inputs[30],
        i_inputs[31],         
        o_2
    );
    mux_2_to_1 M3 (
        i_sel[0],
        o_1,
        o_2,
        o_outputs
    );
*/


// 64-to-1
    wire [(BIT_WIDTH-1):0] o_1, o_2, o_3, o_4;
    mux_16_to_1 M0 (
        i_sel[SEL_WIDTH-1:2],
        i_inputs[0],
        i_inputs[1],
        i_inputs[2],
        i_inputs[3],    
        i_inputs[4],
        i_inputs[5],
        i_inputs[6],
        i_inputs[7],   
        i_inputs[8],
        i_inputs[9],
        i_inputs[10],
        i_inputs[11],    
        i_inputs[12],
        i_inputs[13],
        i_inputs[14],
        i_inputs[15],         
        o_1
    );
     mux_16_to_1 M2 (
        i_sel[SEL_WIDTH-1:2],
        i_inputs[16],
        i_inputs[17],
        i_inputs[18],
        i_inputs[19],    
        i_inputs[20],
        i_inputs[21],
        i_inputs[22],
        i_inputs[23],   
        i_inputs[24],
        i_inputs[25],
        i_inputs[26],
        i_inputs[27],    
        i_inputs[28],
        i_inputs[29],
        i_inputs[30],
        i_inputs[31],         
        o_2
    );
    mux_16_to_1 M3 (
        i_sel[SEL_WIDTH-1:2],
        i_inputs[32],
        i_inputs[33],
        i_inputs[34],
        i_inputs[35],    
        i_inputs[36],
        i_inputs[37],
        i_inputs[38],
        i_inputs[39],   
        i_inputs[40],
        i_inputs[41],
        i_inputs[42],
        i_inputs[43],    
        i_inputs[44],
        i_inputs[45],
        i_inputs[46],
        i_inputs[47],         
        o_3
    );
     mux_16_to_1 M4 (
        i_sel[SEL_WIDTH-1:2],
        i_inputs[48],
        i_inputs[49],
        i_inputs[50],
        i_inputs[51],    
        i_inputs[52],
        i_inputs[53],
        i_inputs[54],
        i_inputs[55],   
        i_inputs[56],
        i_inputs[57],
        i_inputs[58],
        i_inputs[59],    
        i_inputs[60],
        i_inputs[61],
        i_inputs[62],
        i_inputs[63],         
        o_4
    );
    
    mux_4_to_1 M5 (
        i_sel[1:0],
        o_1,
        o_2,
        o_3,
        o_4,
        o_outputs
    );

   
endmodule
