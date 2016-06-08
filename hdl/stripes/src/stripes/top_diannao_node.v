//----------------------------------------------//
//----------------------------------------------//
// Top level pipeline for the baseline 
// Instantiates each of the pipeline stages, registers
// and necessary control signals.
// Tayler Hetherington
// 2015
//----------------------------------------------//
//----------------------------------------------//


module top_diannao_node (
        clk,                    // Main clock
        clk2,                   // 2x main clock
        i_inputs,               // Inputs from eDRAM to NBin
        i_nbin_addr,            // NBin read/write addr
        i_nbin_wen,             // NBin write enable
        i_nbout_addr,           // NBin read/write addr
        i_nbout_wen,            // NBin write enable
        i_synapses,             // Inputs from SB
        i_load_nbout,           // Mux select for storing nbout or NFU-2 result in internal reg. 
        i_sigmoid_coef,         // Coefficient values to store in sigmoid RAM
        i_load_sigmoid_coef,    // Control signal to store sigmoid coefficients
        i_nbout_nfu2_nfu3,      // Control signal to store partial nfu-2 or nfu-3 results to NBout
        o_to_edram
    );

    parameter N = 16;
    parameter Tn = 16;
    parameter TnxTn = Tn*Tn;
    
    parameter ADDR_WIDTH = 6;


    //----------- Input Ports ---------------//
    input                       clk, clk2;

    // i_inputs is a vector of Tn (16) values, 16-bits each
    input [((N*Tn) - 1):0]      i_inputs;


    // i_synapses is a matrix of Tn x Tn (16x16=256) values, 16-bits each (Row-major).
    input [((N*TnxTn) - 1):0]   i_synapses;

    input                       i_nbout_nfu2_nfu3;
    input                       i_load_nbout;

    input [((2*N)-1):0]         i_sigmoid_coef;         // 16-bit Ai and Bi = 32-bits
    input                       i_load_sigmoid_coef;
    input [ADDR_WIDTH-1:0]      i_nbin_addr;            // NBin read/write addr
    input                       i_nbin_wen;             // NBin write enable
    input [ADDR_WIDTH-1:0]      i_nbout_addr;           // NBout read/write addr
    input                       i_nbout_wen;            // NBout write enable
    
        
    //----------- Output Ports ---------------//
    output [((N*Tn) - 1):0]     o_to_edram;
    wire [((N*Tn) - 1):0]       nbout_to_packer;

    //----------- Internal Signals --------------//
    // Wires
    wire [((N*TnxTn) - 1):0]    nfu1_out;
    wire [ (N*Tn) - 1 : 0 ]     nfu2_out;
    wire [ (N*Tn) - 1 : 0 ]     nfu3_out;


    wire [(N*Tn) - 1 : 0]       nbin_out;
    wire [(N*Tn) - 1 : 0]       nbout_out;
    
    wire [(N*Tn) - 1 : 0]       nbout_in;

    wire [(N*Tn) - 1 : 0]       to_nfu2_nfu3_reg;
    
    // Registers
    // NBin register for current inputs
    //reg [ (N*Tn) - 1 : 0 ]      nb_in_reg;

    // SB register for current synapses
    //reg [((N*TnxTn) - 1):0]     sb_reg;
    
    // Main pipeline registers
    reg [((N*TnxTn) - 1):0]     nfu1_nfu2_pipe_reg;
    reg [ (N*Tn) - 1 : 0 ]      nfu2_nfu3_pipe_reg;

    
    //------------- Code Start -----------------//

    // Depending on current state, either write NFU-2 partial sum 
    // or NFU-3 final results to NBout
    //assign o_to_edram       = nfu3_out_reg;
    assign o_to_edram       = nbout_out;

    // i_nbout_nfu2_nfu3 is 0 1/64 of the time, so should be storing nfu2_out to the NBout most of the time
    assign nbout_in         = (i_nbout_nfu2_nfu3) ? nfu3_out : nfu2_out;
    
    // Either load NBout (with partial sum) into the nfu2_nfu3_pipe 
    // reg or store the result of nfu2_out.
    assign to_nfu2_nfu3_reg = (i_load_nbout) ? nbout_out : nfu2_out;

    //--------------------------------------------------// 
    //-------------- Main Pipeline Stages --------------//
    //--------------------------------------------------// 
    
    // NFU-1 (3 internal pipeline stages)
    // FIXME: Still need to verify that this is automatically pipelining 
    nfu_1_pipe n1( 
        clk, 
        nbin_out, 
        i_synapses, // sb_reg 
        nfu1_out
    );

    // NFU-2 (2 internal pipeline stages)
    nfu_2_pipe n2(
        clk, 
        nfu1_nfu2_pipe_reg, 
        nfu2_nfu3_pipe_reg, 
        nfu2_out
    );
    
    // NFU-3 (baseline already has 3 pipe stages)
    nfu_3 n3(
        clk, 
        nfu2_nfu3_pipe_reg, 
        i_sigmoid_coef, 
        i_load_sigmoid_coef, 
        nfu3_out
    );
   
    // NBin
    mem_64x256b #(.N(N)) NBIN (
        clk2,
        i_inputs,
        i_nbin_wen,
        i_nbin_addr,
        nbin_out
    );

    // NBout
    mem_64x256b #(.N(N)) NBOUT (
        clk2,
        nbout_in,
        i_nbout_wen,
        i_nbout_addr,
        nbout_out
    );
    
    // Main pipeline regs (NFU1/NFU2 + NFU2/NFU3)
    always @(posedge clk) begin
        // Load the inputs from the SRAMs to the internal registers
        // NOTE: Removing the initial load registers... With the NBin/NBout and pipeline regs
        //       this should be able to figure out some timing stuff.
        //nb_in_reg               <= i_inputs; // Now in nbin_out
        //sb_reg                  <= i_synapses;
        
        nfu1_nfu2_pipe_reg      <= nfu1_out;
        nfu2_nfu3_pipe_reg      <= to_nfu2_nfu3_reg;
       
    end

    //--------------------------------------------------// 
    //--------------------------------------------------// 
    //--------------------------------------------------//

endmodule

