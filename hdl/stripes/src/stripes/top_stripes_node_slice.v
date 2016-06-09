//----------------------------------------------//
//----------------------------------------------//
// Top level Stripes: a strip of the SIP array for one filter (Tn=1)
// Instantiates each of the pipeline stages, registers
// and necessary control signals.
// Tayler Hetherington
// 2015
//----------------------------------------------//
//----------------------------------------------//


module top_stripes_node (
        clk,                    // Main clock
        reset,                  // Reset
        i_inputs,               // Inputs from eDRAM to NBin
        i_synapses,             // Inputs from SB
        i_nbout,                // Input from NBOut
        i_first_cycle,
        i_precision,
        i_mux_sel,
        i_maxpool,
        i_load,
        o_to_bus
    );

    parameter N             = 16;
    parameter Tn            = 1;
    parameter Tw            = 16;
    parameter Ti            = 16;
    
    parameter ADDR_WIDTH    = 6;
    parameter N_OPS         = 1;
    parameter BIT_IDX = 4;


    //----------- Input Ports ---------------//
    input                       clk;
    input                       reset;
    input                       i_maxpool;
    // i_inputs is a vector of Tn (16) values, 16-bits each
    input [((N*Ti) - 1):0]      i_inputs;
    input [ Tw - 1 : 0 ]        i_load;

    // i_synapses is a matrix of Tn x Tn (16x16=256) values, 16-bits each (Row-major).
    input [((N*Tn*Ti) - 1):0]   i_synapses;


    input[(N*Tn*Tw)-1:0]        i_nbout;


    input                       i_first_cycle;
    input [4:0]                 i_precision;

    input [3:0]                 i_mux_sel;

    // control signals for NFU3
    input                       i_load_coef;
    input [((2*N)-1):0]         i_coef;

    // control signals for rounder
    input [N-1:0]           i_max;
    input [N-1:0]           i_min;
    input [BIT_IDX-1:0]     i_offset;  

    //----------- Output Ports ---------------//
    output [((N*Tn) - 1):0]     o_to_bus;

    //----------- Internal Signals --------------//
    // Wires
    wire [(N*Tw*Tn)-1:0]     nfu1_2_serial_out;
    wire [(N*Tn)-1:0]        mux_out;

    
    /*
    reg                       i_max_reg;  //
    reg [((N*Tn) - 1):0]      i_inputs_reg; //
    reg [((N*TnxTn) - 1):0]   i_synapses_reg; //
    reg[(N*Tn*Tw)-1:0]        i_nbout_reg; //
    reg                       i_first_cycle_reg;  //
    reg [4:0]                 i_precision_reg;
    reg[3:0]                 i_mux_sel_reg;
    reg [((N*Tn) - 1):0]     o_to_nbout_reg; // 
    */

    //------------- Code Start -----------------//
    //assign o_to_nbout   = o_to_nbout_reg;
    //assign o_to_bus     = mux_to_nbout;
    

    //--------------------------------------------------// 
    //-------------- Main Pipeline Stages --------------//
    //--------------------------------------------------//
    /*
    always @(posedge clk) begin
        i_inputs_reg        <= i_inputs;
        i_synapses_reg      <= i_synapses;
        i_nbout_reg         <= i_nbout;
        i_first_cycle_reg   <= i_first_cycle;
        i_precision_reg     <= i_precision;
        i_mux_sel_reg       <= i_mux_sel;
        i_max_reg           <= i_max;
        o_to_nbout_reg      <= mux_to_nbout;
    end
    */

    nfu_1_2_serial_pipe_slice MAIN_PIPE_STAGE (
        clk,
        reset,
        i_first_cycle,
        i_precision,
        i_maxpool,
        i_load,
        i_inputs,
        i_synapses,
        i_nbout,
        nfu1_2_serial_out
    );
    
    //--------------------------------------------------// 
    //--------------------------------------------------// 
    //--------------------------------------------------//

endmodule

