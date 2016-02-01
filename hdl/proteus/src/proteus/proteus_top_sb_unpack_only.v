//----------------------------------------------//
//----------------------------------------------//
// Top level pipeline. 
// Instantiates each of the pipeline stages, registers
// and necessary control signals.
// Tayler Hetherington
// 2015
//----------------------------------------------//
//----------------------------------------------//


module proteus_top_pipeline_vMAX (
        clk,                    // Main clock
        i_inputs,               // Inputs from NBin
        i_synapses,             // Inputs from SB
        i_nbout_to_nfu2,        // Partial sum loaded from NBout into internal NFU-2 register
        i_load_nbout,           // Mux select for storing nbout or NFU-2 result in internal reg. 
        i_sigmoid_coef,         // Coefficient values to store in sigmoid RAM
        i_load_sigmoid_coef,    // Control signal to store sigmoid coefficients
        i_nbout_nfu2_nfu3,      // Control signal to store partial nfu-2 or nfu-3 results to NBout
        i_op,                   // Average or MAX op select line (avg = 0, max = 1)

        i_load_sb,
        i_s_sb,
        i_n_sb,
        i_se_sb,
        i_ze_sb,

        o_nbout_packer_to_mem   // Output from NBout packer to memory?
    );

    parameter N             = 16;
    parameter Tn            = 16;
    parameter TnxTn         = Tn*Tn;
    parameter SHIFT_BITS    = 5;  // 5 = log2(2*N)
    parameter BIT_IDX       = 4; 
    parameter N_OPS         = 1;

    //----------- Input Ports ---------------//
    input                               clk;

    // i_inputs is a vector of Tn (16) values, 16-bits each
    input [((N*Tn) - 1):0]              i_inputs;


    // i_synapses is a matrix of Tn x Tn (16x16=256) values, 16-bits each (Row-major).
    input [((N*TnxTn) - 1):0]           i_synapses;

    input                               i_nbout_nfu2_nfu3;
    input                               i_load_nbout;
    input [(N*Tn) - 1 : 0]              i_nbout_to_nfu2;

    input [((2*N)-1):0]                 i_sigmoid_coef; // 16-bit Ai and Bi = 32-bits
    input                               i_load_sigmoid_coef;
    input [N_OPS-1:0]                   i_op;


    // Proteus specific
    input [1:0]                         i_load_sb;
    input [SHIFT_BITS-1:0]              i_s_sb;
    input [SHIFT_BITS-2:0]              i_n_sb;
    input [N-1:0]                       i_se_sb;
    input [N-1:0]                       i_ze_sb;

    //----------- Output Ports ---------------//
    output [((N*Tn) - 1):0]             o_nbout_packer_to_mem;

    //----------- Internal Signals --------------//
    
    wire [ (N*TnxTn) - 1 : 0 ]          sb_unpk_out;

    wire [ (N*Tn) - 1 : 0 ]             nbout_pk_out;
    
    
    // Wires
    wire [((N*TnxTn) - 1):0]            nfu1_out;
    wire [ (N*Tn) - 1 : 0 ]             nfu2_out;
    wire [ (N*Tn) - 1 : 0 ]             nfu3_out;

    wire [(N*Tn) - 1 : 0]               to_nfu2_nfu3_reg;

    // Registers
    // NBin register for current inputs
    reg [ (N*Tn) - 1 : 0 ]              nb_in_reg;

    // SB register for current synapses
    reg [((N*TnxTn) - 1):0]             sb_reg;
    
    // Main pipeline registers
    reg [((N*TnxTn) - 1):0]             nfu1_nfu2_pipe_reg;
    reg [ (N*Tn) - 1 : 0 ]              nfu2_nfu3_pipe_reg;
   
    reg [ (N*Tn) - 1 : 0 ]              nfu3_out_reg;
    
    //------------- Code Start -----------------//

    // Depending on current state, either write NFU-2 partial sum 
    // or NFU-3 final results to NBout
    
    // This should be going to NBout (unpacked) and then have a separate module for doing
    // the packing after NBout. However, NBout isn't modelled, so just do the packing here
    // to account for the extra hardware. 
    genvar i;
    generate
        for(i=0; i<TnxTn; i=i+1) begin : sb_unpack_gen
            sb_unpacker_v2 sb_unpk_v2 (
                .clk(clk),
                .i_in(i_synapses[(i+1)*N - 1 : i*N] ),
                .i_load(i_load_sb),
                .i_s(i_s_sb),
                .i_n(i_n_sb),
                .i_se(i_se_sb),
                .i_ze(i_ze_sb),
                .o_out(sb_unpk_out[(i+1)*N - 1: i*N])
            );           
        end
    endgenerate

    assign o_nbout_packer_to_mem = (i_nbout_nfu2_nfu3) ? nfu2_out : nfu3_out;

    // Either load NBout (with partial sum) into the nfu2_nfu3_pipe 
    // reg or store the result of nfu2_out.    
    assign to_nfu2_nfu3_reg = (i_load_nbout) ? i_nbout_to_nfu2 : nfu2_out;

    //--------------------------------------------------// 
    //-------------- Main Pipeline Stages --------------//
    //--------------------------------------------------//
    // NFU-1 (3 internal pipeline stages)
    nfu_1_pipe N1 ( 
        clk, 
        i_inputs, 
        sb_unpk_out, 
        nfu1_out
    );

    // NFU-2 (2 internal pipeline stages)
    nfu_2_pipe_vMAX N2(
        clk, 
        nfu1_nfu2_pipe_reg, 
        nfu2_nfu3_pipe_reg, 
        i_op,
        nfu2_out
    );

    // NFU-3
    nfu_3 N3 (
        clk, 
        nfu2_nfu3_pipe_reg, 
        i_sigmoid_coef, 
        i_load_sigmoid_coef, 
        nfu3_out
    );

    //--------------------------------------------------// 

    always @(posedge clk) begin
        nfu2_nfu3_pipe_reg <= to_nfu2_nfu3_reg;
        nfu1_nfu2_pipe_reg <= nfu1_out;
    end

    //--------------------------------------------------// 
    //--------------------------------------------------// 
    //--------------------------------------------------//

endmodule // End module top_pipeline


