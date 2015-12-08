//----------------------------------------------//
//----------------------------------------------//
// Top level pipeline. 
// Instantiates each of the pipeline stages, registers
// and necessary control signals.
// Tayler Hetherington
// 2015
//----------------------------------------------//
//----------------------------------------------//


module top_diannao_node_vMAX (
        clk,                    // Main clock
        i_inputs,               // Inputs from eDRAM to NBin
        i_synapses,             // Inputs from SB
        i_load_nbout,           // Mux select for storing nbout or NFU-2 result in internal reg. 
        i_sigmoid_coef,         // Coefficient values to store in sigmoid RAM
        i_load_sigmoid_coef,    // Control signal to store sigmoid coefficients
        i_nbout_nfu2_nfu3,      // Control signal to store partial nfu-2 or nfu-3 results to NBout
        i_op,                   // Average or MAX op select line (avg = 0, max - 1)
        i_nbout,
        o_to_edram
    );

    parameter N             = 16;
    parameter Tn            = 16;
    parameter TnxTn         = Tn*Tn;
    parameter N_OPS         = 1;

    //----------- Input Ports ---------------//
    input                       clk;

    // i_inputs is a vector of Tn (16) values, 16-bits each
    input [((N*Tn) - 1):0]      i_inputs;


    // i_synapses is a matrix of Tn x Tn (16x16=256) values, 16-bits each (Row-major).
    input [((N*TnxTn) - 1):0]   i_synapses;
    
    input [(N*Tn) - 1:0]        i_nbout;

    input                       i_nbout_nfu2_nfu3;
    input                       i_load_nbout;

    input [((2*N)-1):0]         i_sigmoid_coef;         // 16-bit Ai and Bi = 32-bits
    input                       i_load_sigmoid_coef;
    input [N_OPS-1:0]           i_op;                   // Average or MAX op select line (avg = 0, max - 1)
        
    //----------- Output Ports ---------------//
    output [((N*Tn) - 1):0]     o_to_edram;

    //----------- Internal Signals --------------//
    // Wires
    wire [((N*TnxTn) - 1):0]    nfu1_out;
    wire [ (N*Tn) - 1 : 0 ]     nfu2_out;
    wire [ (N*Tn) - 1 : 0 ]     nfu3_out;


    wire [(N*Tn) - 1 : 0]       nbin_out;
    
    wire [(N*Tn) - 1 : 0]       nbout_in;

    wire [(N*Tn) - 1 : 0]       to_nfu2_nfu3_reg;
    
    // Main pipeline registers
    reg [((N*TnxTn) - 1):0]     nfu1_nfu2_pipe_reg;
    reg [ (N*Tn) - 1 : 0 ]      nfu2_nfu3_pipe_reg;

    
    //------------- Code Start -----------------//

    // Depending on current state, either write NFU-2 partial sum 
    // or NFU-3 final results to NBout
    assign o_to_edram       = nbout_in;

    // i_nbout_nfu2_nfu3 is 0 1/64 of the time, so should be storing nfu2_out to the NBout most of the time
    assign nbout_in         = (i_nbout_nfu2_nfu3) ? nfu3_out : nfu2_out;
    
    // Either load NBout (with partial sum) into the nfu2_nfu3_pipe 
    // reg or store the result of nfu2_out.
    assign to_nfu2_nfu3_reg = (i_load_nbout) ? i_nbout : nfu2_out;

    //--------------------------------------------------// 
    //-------------- Main Pipeline Stages --------------//
    //--------------------------------------------------// 
    
    // NFU-1 (3 internal pipeline stages)
    // FIXME: Still need to verify that this is automatically pipelining 
    nfu_1_pipe N1 ( 
        clk, 
        i_inputs, 
        i_synapses, // sb_reg 
        nfu1_out
    );

    // NFU-2 (2 internal pipeline stages)
    nfu_2_pipe_vMAX N2 (
        clk, 
        nfu1_nfu2_pipe_reg, 
        nfu2_nfu3_pipe_reg, 
        i_op,
        nfu2_out
    );
    
    // NFU-3 (3 internal pipeline stages)
    nfu_3 N3 (
        clk, 
        nfu2_nfu3_pipe_reg, 
        i_sigmoid_coef, 
        i_load_sigmoid_coef, 
        nfu3_out
    );
   
    // Main pipeline regs (NFU1/NFU2 + NFU2/NFU3)
    always @(posedge clk) begin
        nfu1_nfu2_pipe_reg      <= nfu1_out;
        nfu2_nfu3_pipe_reg      <= to_nfu2_nfu3_reg;
    end

    //--------------------------------------------------// 
    //--------------------------------------------------// 
    //--------------------------------------------------//

endmodule

