


module top_convpress_node_d2_v2_vMAX (
        clk,
        clk2,
        rst,
        i_nbin_data,
        i_nbin_addr,
        i_offset_data,
        i_off_rd_addr,
        i_off_wr_addr,
        i_off_wen,
        i_nbin_wen,
        i_nbout_addr,
        i_nbout_wen,
        i_sb_data,
        i_load_nbout,
        i_coef,
        i_load_coef,
        i_n1_n2_to_nbout,
        i_fwdb_rd_addr,
        i_fwdb_wr_addr,
        i_fwdb_wen,
        i_op,
        o_sb_offset,
        o_data_to_edram,        
        o_idx_to_edram, 
        o_offset_to_edram
    );

    //------- Parameters
    parameter N  = 16;
    parameter Tn = 16;
    parameter ADDR_SZ = 6;
    parameter OFFSET_SZ = 4;

    parameter FWDB_ADDR_SZ = 2;
    parameter N_OPS = 1;
    //------- Inputs
    input                       clk, clk2;
    input                       rst;

    input [Tn*N-1:0]            i_nbin_data;
    input [Tn*OFFSET_SZ-1:0]    i_offset_data;
    input [Tn*Tn*N-1:0]         i_sb_data;
    input [Tn*ADDR_SZ-1:0]      i_nbin_addr, i_off_rd_addr, i_off_wr_addr;
    input [Tn-1:0]              i_nbin_wen;
    input [Tn-1:0]              i_off_wen;

    input [ADDR_SZ-1:0]         i_nbout_addr;
    input                       i_nbout_wen;

    input [Tn*FWDB_ADDR_SZ-1:0] i_fwdb_rd_addr;
    input [Tn*FWDB_ADDR_SZ-1:0] i_fwdb_wr_addr;
    input [Tn-1:0]              i_fwdb_wen;
    
    // Sigmoid op 
    input [2*N-1:0]             i_coef;
    input                       i_load_coef;

    // Control signals
    input                       i_n1_n2_to_nbout;
    input                       i_load_nbout;
    input                       i_op;

    //------- Outputs
    output [Tn*OFFSET_SZ-1:0]   o_sb_offset;
    output [Tn*N-1:0]           o_data_to_edram;
    output [Tn*OFFSET_SZ-1:0]   o_idx_to_edram;
    output [Tn*OFFSET_SZ-1:0]   o_offset_to_edram;



    //------- Internal signals
    wire [Tn*N-1:0]             nbin_out;
    
    // N0 out (multiplier)
    wire [Tn*Tn*N-1:0]          n0_out;
    
    // N1 out (adder tree)
    wire [Tn*N-1:0]             n1_out;
   
    // N2 out (sigmoid op)
    wire [Tn*N-1:0]             n2_out;
    
    // N3 out (compressor)
    wire [Tn*N-1:0]             n3_data_out;
    wire [Tn*OFFSET_SZ-1:0]     n3_idx_out;
    wire [Tn*OFFSET_SZ-1:0]     n3_offset_out;


    wire [Tn*N-1:0]             to_n1_n2_reg; // Assigned from NBout read
    wire [Tn*N-1:0]             to_nbout;
    wire [Tn*N-1:0]             nbout_out;
    wire [Tn*OFFSET_SZ-1:0]     sb_offset_out;

    wire [Tn*Tn*N-1:0]          fwdb_out;

    //------- Main pipeline regs
    reg [Tn*N-1:0]              nbin_wait_sb_reg;       // Read NBin/offset, wait for SB to be read next cycle
    reg [Tn*Tn*N-1:0]           n0_n1_pipe_reg;
    reg [Tn*N-1:0]              n1_n2_pipe_reg;


    //------- Ouput logic 
    assign o_data_to_edram      = n3_data_out;
    assign o_idx_to_edram       = n3_idx_out;
    assign o_offset_to_edram    = n3_offset_out;
    assign o_sb_offset          = sb_offset_out;


    //------- Signal assignments
    
    // Select output of n1 (adder trees partial sum) or n2 (sigmoid final val) to write to NBout
    assign to_nbout     = (i_n1_n2_to_nbout) ? (n2_out) : (n1_out);

    // Either load NBout (with partial sum) into the n1_n2_pipe reg, or store the result of n1_out
    assign to_n1_n2_reg = (i_load_nbout) ? (nbout_out) : (n1_out);


    //------- Sequential logic - Pipeline registers
    always @(posedge clk) begin
        nbin_wait_sb_reg    <= nbin_out;
        n0_n1_pipe_reg      <= n0_out;
        n1_n2_pipe_reg      <= to_n1_n2_reg;
    end

    //------- M0: NBin and Offset SRAM (RF compiler)
    m0_v2 #(.N(N), .Tn(Tn)) M0_V2 (
        clk,
        clk2,
        i_nbin_data,
        i_offset_data,
        i_nbin_wen,
        i_off_wen,
        i_nbin_addr,
        i_off_rd_addr,
        i_off_wr_addr,
        nbin_out,
        sb_offset_out
    );

    /*
    m0 #(.N(N), .Tn(Tn)) M0 (
        clk2,
        i_nbin_data,
        i_offset_data,
        i_nbin_wen,
        i_nbin_addr,
        nbin_out,
        sb_offset_out
    );
    */

    m1 #(.N(N), .Tn(Tn)) M1 (
        clk2,
        to_nbout,
        i_nbout_wen,
        i_nbout_addr,
        nbout_out
    );

    m2 #(.N(N), .Tn(Tn)) M2 (
        clk,
        n0_out,
        i_fwdb_rd_addr,
        i_fwdb_wr_addr,
        i_fwdb_wen,
        fwdb_out
    );

    //------ N0: Tn x Tn Multiplier array
    n0_cluster #(.N(N), .Tn(Tn)) N0 (
        clk,                    
        nbin_wait_sb_reg,       // Delayed by a cycle
        i_sb_data,              // Assume comes from eDRAM on the correct cycle after offset calc
        fwdb_out,               // Partial window sum data from Forward window buffers
        n0_out                  // Output to pipeline reg 
    );

    //------ N1: Adder trees + accumulator
    n1_cluster_vMAX #(.N(N), .Tn(Tn)) N1 (
        clk, 
        n0_n1_pipe_reg,         // Input from multiplier array
        n1_n2_pipe_reg,         // Partial sum stored in n1_n2 pipeline reg
        i_op,
        n1_out                  // Output to n1_n2 pipeline reg
    );

    //------ N2: Sigmoid op
    n2_cluster #(.N(N), .Tn(Tn)) N2 (
        clk,
        n1_n2_pipe_reg,         // Input from adder tree (completed full sum)
        i_coef,                 // Input coefficients (only set at startup)
        i_load_coef,            // Control signal to intialize coefficeints
        n2_out                  // Final output from N2. To NBout if complete
    );


    //------ N3: Compressor -- After NBout, before eDRAM
    n3_cluster #(.N(N), .Tn(Tn)) N3 (
        clk,
        rst,
        nbout_out,
        n3_data_out,
        n3_idx_out,
        n3_offset_out
    );
    
endmodule
