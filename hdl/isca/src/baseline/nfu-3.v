//----------------------------------------------//
//----------------------------------------------//
// NFU-3: Sigmoid operation
// Tayler Hetherington
// 2015
//----------------------------------------------//
//----------------------------------------------//


//---------------------------------------------//
// Main NFU-3 module
//---------------------------------------------//
module nfu_3 (
        clk,    
        i_nfu2_out,
        i_coef,
        i_load_coef,
        o_nfu3_out
    );

    parameter BIT_WIDTH = 16;
    parameter Tn = 16;
    
    input                               clk;
    input                               i_load_coef;
    input [((2*BIT_WIDTH)-1):0]         i_coef;
    
    input [ (Tn*BIT_WIDTH) - 1 : 0 ]    i_nfu2_out;
    output [ (Tn*BIT_WIDTH) - 1 : 0 ]   o_nfu3_out;
    
    genvar i;
    generate
        for(i=0; i<Tn; i=i+1) begin : SIG_GEN
            sigmoid_op SIG_OP (    
                clk,
                i_nfu2_out[ ((i+1)*BIT_WIDTH) - 1 : (i*BIT_WIDTH) ],
                i_coef,
                i_load_coef,
                o_nfu3_out[ ((i+1)*BIT_WIDTH) - 1 : (i*BIT_WIDTH) ]
            );
        end
    endgenerate
    
endmodule


//---------------------------------------------//
// Single sigmoid operation per value
//---------------------------------------------//
module sigmoid_op (
        clk,
        i_X,
        i_coef,
        i_load_coef,
        o_Y
    );

    parameter BIT_WIDTH = 16;

    //----------- Input Ports ---------------//
    input                       clk;
    input [(BIT_WIDTH - 1):0]   i_X;

    input [(2*BIT_WIDTH)-1:0]   i_coef;
    input                       i_load_coef;
    //----------- Output Ports ---------------//
    output [(BIT_WIDTH - 1):0]  o_Y;

    //----------- Internal Signals -----------//

    // Internal pipeline stages
    reg [(BIT_WIDTH - 1) : 0]   reg_xi_stage_0;
    reg [(BIT_WIDTH - 1) : 0]   reg_xiai_bi_stage_1 [0 : 1];

    // Segment variables for piecewise sigmoid op
    wire [(BIT_WIDTH-1) : 0]    ai_ram_out, bi_ram_out;
    wire [(BIT_WIDTH-1) : 0]    xi_ai_mult, xi_ai_bi_add;

    wire [(BIT_WIDTH-1) : 0]    xi_seg_mux_out, xi1_seg_mux_out;

    //------------- Code Start -----------------//

    //--------- Internal pipeline -----------//
    // Store i_X in pipeline register, waiting for RAM read
    // Store result of Xi*Ai and Bi in ssecond stage pipeline register
    always @(posedge clk) begin
        reg_xi_stage_0          <= i_X;
        reg_xiai_bi_stage_1[0]  <= xi_ai_mult;
        reg_xiai_bi_stage_1[1]  <= bi_ram_out;
    end


    // FIXME: Need to figure out what to do with the segment boundary muxes.
    //          Xi and Xi+1 are hardwired, but there are only 16 segments,
    //          Which means we only need 4 bits to choose Ai and Bi...
    mux_16_to_1 mux0 (
        i_X[(BIT_WIDTH-1) : ((BIT_WIDTH-1)-3)],
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000000,
        16'b0000000000000001,
        16'b0000000000000001,
        16'b0000000000000001,
        16'b0000000000000001,
        16'b0000000000000010,
        16'b0000000000000010,
        16'b0000000000000010,
        16'b0000000000000010,
        16'b0000000000000011,
        16'b0000000000000011,
        16'b0000000000000011,
        16'b0000000000000011,
        xi_seg_mux_out
    );

    mux_16_to_1 mux1 (
        i_X[(BIT_WIDTH-1) : ((BIT_WIDTH-1)-3)],
        16'b0000000000000000,
        16'b0000000000000001,
        16'b0000000000000010,
        16'b0000000000000011,
        16'b0000000000000000,
        16'b0000000000000001,
        16'b0000000000000010,
        16'b0000000000000011,
        16'b0000000000000000,
        16'b0000000000000001,
        16'b0000000000000010,
        16'b0000000000000011,
        16'b0000000000000000,
        16'b0000000000000001,
        16'b0000000000000010,
        16'b0000000000000011,
        xi1_seg_mux_out
    );

    //--------- Stage 1: Read coefficients -------------//
    // 32-bit lines (16-bits concatenated for Ai and Bi)
    // 16 segments => address = 4bits
    ram #(.DATA_WIDTH(32), .ADDR_WIDTH(4)) COEF_RAM (
        clk,
        {xi_seg_mux_out[1:0], xi1_seg_mux_out[1:0]},
        i_coef,
        i_load_coef,
        {ai_ram_out, bi_ram_out}
    );

    //----------- Stage 2: Multiplie X*ai -------------//
    m_mult mul_Xi_Ai (
        reg_xi_stage_0,
        ai_ram_out,
        xi_ai_mult
    );

    //--------- Stage 3: Add X*ai + bi -----------//
    m_addr add_XixAi_Bi (
        reg_xiai_bi_stage_1[0],
        reg_xiai_bi_stage_1[1],
        xi_ai_bi_add
    );

    //--------- Assign output -----------//
    assign o_Y = xi_ai_bi_add;

endmodule
