//----------------------------------------------//
//----------------------------------------------//
// Top level pipeline. 
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
        i_max,
        i_load,
        o_to_nbout
    );

    parameter N             = 16;
    parameter Tn            = 16;
    parameter TnxTn         = Tn*Tn;
    parameter Tw            = 16;
    
    parameter ADDR_WIDTH    = 6;
    parameter N_OPS         = 1;


    //----------- Input Ports ---------------//
    input                       clk;
    input                       reset;
    input                       i_max;
    // i_inputs is a vector of Tn (16) values, 16-bits each
    input [((N*Tn) - 1):0]      i_inputs;
    input [ Tw - 1 : 0 ]        i_load;

    // i_synapses is a matrix of Tn x Tn (16x16=256) values, 16-bits each (Row-major).
    input [((N*TnxTn) - 1):0]   i_synapses;


    input[(N*Tn*Tw)-1:0]        i_nbout;


    input                       i_first_cycle;
    input [4:0]                 i_precision;

    input [3:0]                 i_mux_sel;

    //----------- Output Ports ---------------//
    output [((N*Tn) - 1):0]     o_to_nbout;

    //----------- Internal Signals --------------//
    // Wires
    wire [(N*Tw*Tn)-1:0]        nfu1_2_serial_out;
    wire [(N*Tn)-1:0]        mux_to_nbout;

    
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
    //assign o_to_nbout       = o_to_nbout_reg;
    assign o_to_nbout = mux_to_nbout;
    

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

    // NFU_1_2_serial_pipe
    /*
    nfu_1_2_serial_pipe MAIN_PIPE_STAGE (
        clk,
        reset,
        i_first_cycle_reg,
        i_precision_reg,
        i_max_reg,
        i_inputs_reg,
        i_synapses_reg,
        i_nbout_reg,
        nfu1_2_serial_out
    );
    */
    nfu_1_2_serial_pipe MAIN_PIPE_STAGE (
        clk,
        reset,
        i_first_cycle,
        i_precision,
        i_max,
        i_load,
        i_inputs,
        i_synapses,
        i_nbout,
        nfu1_2_serial_out
    );
    genvar i;

    generate
        for(i=0; i<Tn; i=i+1) begin : MUX
            mux_16_to_1_v2 MUX16_1 (
            i_mux_sel,
            nfu1_2_serial_out[(i+1)*Tn*N - 1 : i*Tn*N],
            mux_to_nbout[(i+1)*N - 1 : i*N]
        );         
        end
    endgenerate
    
    //--------------------------------------------------// 
    //--------------------------------------------------// 
    //--------------------------------------------------//

endmodule

