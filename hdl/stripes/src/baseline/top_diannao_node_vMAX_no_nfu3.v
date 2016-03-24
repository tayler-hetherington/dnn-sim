//----------------------------------------------//
//----------------------------------------------//
// Top level pipeline. 
// Instantiates each of the pipeline stages, registers
// and necessary control signals.
// Tayler Hetherington
// 2015
//----------------------------------------------//
//----------------------------------------------//


module top_diannao_node_vMAX_no_nfu3 (
        clk,                    // Main clock
        i_inputs,               // Inputs from eDRAM to NBin
        i_synapses,             // Inputs from SB
        i_nbout,
        i_op,
        o_to_nbout
    );

    parameter N             = 16;
    parameter Tn            = 16;
    parameter TnxTn         = Tn*Tn;
    


    //----------- Input Ports ---------------//
    input                       clk;
    input                       i_op;

    // i_inputs is a vector of Tn (16) values, 16-bits each
    input [((N*Tn) - 1):0]      i_inputs;

    input [((N*Tn) - 1):0]      i_nbout;

    // i_synapses is a matrix of Tn x Tn (16x16=256) values, 16-bits each (Row-major).
    input [((N*TnxTn) - 1):0]   i_synapses;

       
    //----------- Output Ports ---------------//
    output [((N*Tn) - 1):0]     o_to_nbout;

    //----------- Internal Signals --------------//
    // Wires
    wire [((N*TnxTn) - 1):0]    nfu1_out;
    wire [ (N*Tn) - 1 : 0 ]     nfu2_out;


    // Main pipeline registers
    reg [((N*TnxTn) - 1):0]     nfu1_nfu2_pipe_reg;

    
    //------------- Code Start -----------------//

    // Depending on current state, either write NFU-2 partial sum 
    // or NFU-3 final results to NBout

    assign o_to_nbout       = nfu2_out;


    //--------------------------------------------------// 
    //-------------- Main Pipeline Stages --------------//
    //--------------------------------------------------// 
    
    // NFU-1 (3 internal pipeline stages)
    // FIXME: Still need to verify that this is automatically pipelining 
    nfu_1_pipe n1( 
        clk, 
        i_inputs, 
        i_synapses,
        nfu1_out
    );

    // NFU-2 (2 internal pipeline stages)
    nfu_2_pipe_vMAX n2(
        clk, 
        nfu1_nfu2_pipe_reg, 
        i_nbout, 
        i_op,
        nfu2_out
    );
    
    
    // Main pipeline regs (NFU1/NFU2 + NFU2/NFU3)
    always @(posedge clk) begin
        // Load the inputs from the SRAMs to the internal registers
        nfu1_nfu2_pipe_reg      <= nfu1_out;
    end

    //--------------------------------------------------// 
    //--------------------------------------------------// 
    //--------------------------------------------------//

endmodule

