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
        i_op,                   // Average or MAX op select line (avg = 0, max - 1)
        i_nbout,                // feedback input from NBout
        i_load,
        o_to_edram
    );

    parameter N             = 16;
    parameter Tn            = 1;
    parameter Ti            = 16;
    
    parameter ADDR_WIDTH    = 6;
    parameter N_OPS         = 1;


    //----------- Input Ports ---------------//
    input                       clk, clk2;

    // i_inputs is a vector of Tn (16) values, 16-bits each
    input [((N*Ti) - 1):0]      i_inputs;


    // i_synapses is a matrix of Tn x Tn (16x16=256) values, 16-bits each (Row-major).
    input [((N*Tn*Ti) - 1):0]   i_synapses;

    input                       i_nbout_nfu2_nfu3;
    input                       i_load;

    input [N_OPS-1:0]           i_op;                   // Average or MAX op select line (avg = 0, max - 1)
        
    input [((N*Tn) - 1):0]     i_nbout;
    //----------- Output Ports ---------------//
    output [((N*Tn) - 1):0]     o_to_edram;

    //----------- Internal Signals --------------//
    // Wires
    wire [((N*Tn*Ti) - 1):0]    nfu1_out;
    wire [ (N*Tn) - 1 : 0 ]     nfu2_out;
    
    // Registers
    // NBin register for current inputs
    //reg [ (N*Tn) - 1 : 0 ]      nb_in_reg;

    // SB register for current synapses
    //reg [((N*TnxTn) - 1):0]     sb_reg;
    
    // Main pipeline registers
    reg [((N*Ti*Tn) - 1):0]     nfu1_nfu2_pipe_reg;
    reg [ (N*Tn) - 1 : 0 ]      nfu2_nfu3_pipe_reg;

    
    //------------- Code Start -----------------//

    // Depending on current state, either write NFU-2 partial sum 
    // or NFU-3 final results to NBout
    //assign o_to_edram       = nfu3_out_reg;
    assign o_to_edram       = nfu2_nfu3_pipe_reg;

    //--------------------------------------------------// 
    //-------------- Main Pipeline Stages --------------//
    //--------------------------------------------------// 
    
    // NFU-1 (3 internal pipeline stages)
    // FIXME: Still need to verify that this is automatically pipelining 
    nfu_1_pipe_slice n1( 
        clk, 
        i_inputs,   // 
        i_synapses, // sb_reg 
        nfu1_out    // o_results
    );

    // NFU-2 (2 internal pipeline stages)
    nfu_2_pipe_vMAX_slice n2(
        clk, 
        nfu1_nfu2_pipe_reg, //i_nfu1_out
        nfu2_nfu3_pipe_reg, //i_nbout
        i_op,
        nfu2_out // o_nfu2_out
    );
    
    // Main pipeline regs (NFU1/NFU2 + NFU2/NFU3)
    always @(posedge clk) begin
        // Load the inputs from the SRAMs to the internal registers
        // NOTE: Removing the initial load registers... With the NBin/NBout and pipeline regs
        //       this should be able to figure out some timing stuff.
        //nb_in_reg               <= i_inputs; // Now in nbin_out
        //sb_reg                  <= i_synapses;
        
        nfu1_nfu2_pipe_reg      <= nfu1_out;
        if (i_load) 
          nfu2_nfu3_pipe_reg      <= nfu2_out;
        else
          nfu2_nfu3_pipe_reg      <= i_nbout;
       
    end

    //--------------------------------------------------// 
    //--------------------------------------------------// 
    //--------------------------------------------------//

endmodule

