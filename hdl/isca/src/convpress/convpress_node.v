


module top_convpress_node (
        clk,
        rst,
        i_nbin_data,
        i_sb_data,
        i_nbin_addr,
        i_nbout_addr,
        i_coef,
        i_load_coef,
        i_base_addr,
        o_to_edram        
    );

    //------- Parameters
    parameter N  = 16;
    parameter Tn = 16;
    parameter ADDR_SIZE = 4;

    //------- Inputs
    input           clk;
    input           rst;

    input [Tn*N-1:0]        i_nbin_data;
    input [Tn*Tn*N-1:0]     i_sb_data;
    input [ADDR_SIZE-1:0]   i_nbin_addr;
    input [ADDR_SIZE-1:0]   i_nbout_addr;
    input [2*N-1:0]         i_coef;
    input                   i_load_coef;
    input [N-1:0]           i_base_addr;
    
    //------- Outputs
    output [Tn*N-1:0]       o_to_edram;


    //------- Internal signals
    wire [Tn*N-1:0]         nbin_out;
    wire [Tn*Tn*N-1:0]      sb_out;
    wire [Tn*Tn*N-1:0]      nbout_out;
    wire [Tn*Tn*N-1:0]      n0_out;
    wire [Tn*N-1:0]         n1_out;
    wire [Tn*N-1:0]         n2_out;

    //FIXME: Size
    wire [Tn*N-1:0]         n3_addr_out;
    wire [Tn*N-1:0]         n3_offset_out;
    reg  [Tn*N-1:0]         n3_addr_out_reg;
    reg  [Tn*N-1:0]         n3_offset_out_reg;

    //------- Pipeline Regs
    reg [Tn*N-1:0]          n1_out_reg;
    reg [Tn*N-1:0]          n2_out_reg;
    reg [Tn*N-1:0]          n3_out_addr_reg;
    reg [Tn*N-1:0]          n3_out_offset_reg;

    assign o_to_edram  = n3_out_addr_reg;


    //------- Sequential logic
    always @(posedge clk) begin
        n1_out_reg          <= n1_out;
        n2_out_reg          <= n2_out;
        n3_addr_out_reg     <= n3_addr_out;
        n3_offset_out_reg   <= n3_offset_out;
    end

    //------- M0: NBin SRAM
    m0 #(.N(N), .Tn(Tn), .ADDR_SIZE(ADDR_SIZE)) M0 (
        clk,
        i_nbin_data,
        i_sb_data,
        i_nbin_addr,
        nbin_out,
        sb_out
    );

    //------- M1: NBout SRAM
    m1 #(.N(N), .Tn(Tn), .ADDR_SIZE(ADDR_SIZE)) M1 (
        clk,
        n0_out,
        i_nbout_addr,
        nbout_out
    );

    //------ N0: Multiplier and accumulator
    n0_cluster #(.N(N), .Tn(Tn)) N0 (
        nbin_out,
        sb_out,
        nbout_out,
        n0_out    
    );

    //------ N1: Adder trees
    n1_cluster #(.N(N), .Tn(Tn)) N1 (
        clk, 
        nbout_out,
        n1_out
    );

    //------ N2: Sigmoid op
    n2_cluster #(.N(N), .Tn(Tn)) N2 (
        clk,
        n1_out_reg,
        i_coef,
        i_load_coef,
        n2_out
    );

    //------ N3: Compressor
    n3_cluster #(.N(N), .Tn(Tn)) N3 (
        clk,
        rst,
        n2_out_reg,
        i_base_addr,
        n3_addr_out,
        n3_offset_out
    );
    




endmodule
