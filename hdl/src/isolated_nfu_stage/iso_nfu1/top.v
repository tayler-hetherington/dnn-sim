//----------------------------------------------//
//----------------------------------------------//
// Top level pipeline. 
// Instantiates each of the pipeline stages, registers
// and necessary control signals.
// Tayler Hetherington
// 2015
//----------------------------------------------//
//----------------------------------------------//

module top_level_base (
        clk,                    // Main clock
        i_inputs,               // Inputs from NBin
        i_synapses,             // Inputs from SB
        o_outputs
    );

    parameter BIT_WIDTH = 16;
    parameter Tn = 16;
    parameter TnxTn = 256;

    //----------- Input Ports ---------------//
    input                               clk;

    // i_inputs is a vector of Tn (16) values, 16-bits each
    input [((BIT_WIDTH*Tn) - 1):0]      i_inputs;


    // i_synapses is a matrix of Tn x Tn (16x16=256) values, 16-bits each (Row-major).
    input [((BIT_WIDTH*TnxTn) - 1):0]   i_synapses;

    //----------- Output Ports ---------------//
    output [((BIT_WIDTH*TnxTn) - 1):0]     o_outputs;


    //----------- Internal Signals --------------//
    // Wires
    wire [((BIT_WIDTH*TnxTn) - 1):0]    nfu1_out;

    // Registers
    // NBin register for current inputs
    reg [ (BIT_WIDTH*Tn) - 1 : 0 ]      nb_in_reg;

    // SB register for current synapses
    reg [((BIT_WIDTH*TnxTn) - 1):0]     sb_reg;
    
    // Main pipeline registers
    reg [((BIT_WIDTH*TnxTn) - 1):0]     nfu1_out_reg;
    
    
    //------------- Code Start -----------------//
    assign o_outputs = nfu1_out_reg;
    
    //--------------------------------------------------// 
    //-------------- Main Pipeline Stages --------------//
    //--------------------------------------------------// 
    // NFU-1
    nfu_1 n1 (clk, nb_in_reg, sb_reg, nfu1_out);
    
    
    always @(posedge clk) begin
        // Load the inputs from the SRAMs to the internal registers
        nb_in_reg <= i_inputs;
        sb_reg <= i_synapses;

        nfu1_out_reg <= nfu1_out;
    end

    //--------------------------------------------------// 
    //--------------------------------------------------// 
    //--------------------------------------------------//

endmodule // End module top_pipeline





module top_level_zero_opt (
        clk,                    // Main clock
        i_inputs,               // Inputs from NBin
        i_sel_lines,            // Select lines for replacement muxes
        i_synapses,             // Inputs from SB
        o_outputs              // Output from pipeline to NBout
    );

    parameter BIT_WIDTH = 16;
    parameter Tn = 16;
    parameter TnxTn = 256;


    parameter D = 2;
    parameter W = 3;
    parameter SEL_WIDTH = 4;
    parameter NUM_MUX_INPUTS = (1 << SEL_WIDTH);


    //----------- Input Ports ---------------//
    input                               clk;

    // i_inputs is a vector of Tn (16) values, 16-bits each
    input [((BIT_WIDTH*Tn) - 1):0]          i_inputs;

    input [ (SEL_WIDTH*TnxTn) - 1 : 0 ]     i_sel_lines;

    // i_synapses is a matrix of Tn x Tn (16x16=256) values, 16-bits each (Row-major).
    input [((BIT_WIDTH*TnxTn) - 1):0]   i_synapses;


    //----------- Output Ports ---------------//
    output [((TnxTn*BIT_WIDTH) - 1):0]     o_outputs;


    //----------- Internal Signals --------------//
    // Wires
    wire [((BIT_WIDTH*TnxTn) - 1):0]    nfu1_out;

    // Registers
    // NBin register for current inputs
    reg [ (BIT_WIDTH*Tn) - 1 : 0 ]      nb_in_reg;

    reg [ (BIT_WIDTH*Tn*D) - 1 : 0 ]    repl_cands_reg;

    // SB register for current synapses
    reg [((BIT_WIDTH*TnxTn) - 1):0]     sb_reg;
    
    // Main pipeline registers
    reg [((BIT_WIDTH*TnxTn) - 1):0]     nfu1_out_reg;
   
    wire [ (BIT_WIDTH*TnxTn) - 1 : 0 ]  zero_opt_out;

    
    //------------- Code Start -----------------//

    assign o_outputs = nfu1_out_reg; 
    
    
    //--------------------------------------------------// 
    //-------------- Main Pipeline Stages --------------//
    //--------------------------------------------------// 

    // Zero Optimization
    // D1W0  
    /*
    nfu_1A_D1_W0 MOD1 (
        nb_in_reg,
        repl_cands_reg,
        i_sel_lines,
        zero_opt_out
    );
    */
    
    // D2W3
    nfu_1A_D2_W3 MOD2 (
        nb_in_reg,
        repl_cands_reg,
        i_sel_lines,
        zero_opt_out
    );

    /*
    // D3W4
    nfu_1A_D3_W4 MOD3 (
        nb_in_reg,
        repl_cands_reg,
        i_sel_lines,
        zero_opt_out
    );
    */

   /*
    // D5W15
    nfu_1A_D5_W15 MOD4 (
        nb_in_reg,
        repl_cands_reg,
        i_sel_lines,
        zero_opt_out
    );
    */

    // NFU-1 -- Switched nb_in_reg to zero_opt_out
    nfu_1_B n1 (clk, zero_opt_out, sb_reg, nfu1_out);

    
    
    always @(posedge clk) begin
        // Load the inputs from the SRAMs to the internal registers
        nb_in_reg <= i_inputs;
        sb_reg <= i_synapses;


        // Shift registers

        // D1W0 
        /*
        repl_cands_reg <= nb_in_reg;
        */

        // D2W3 
        repl_cands_reg[Tn*BIT_WIDTH-1:0] <= nb_in_reg;
        repl_cands_reg[(2*Tn*BIT_WIDTH)-1: 1*Tn*BIT_WIDTH] <= repl_cands_reg[Tn*BIT_WIDTH-1:0];
        

        /*
        // D3W4 
        repl_cands_reg[Tn*BIT_WIDTH-1:0] <= nb_in_reg;
        repl_cands_reg[(2*Tn*BIT_WIDTH)-1: 1*Tn*BIT_WIDTH] <= repl_cands_reg[Tn*BIT_WIDTH-1:0];
        repl_cands_reg[(3*Tn*BIT_WIDTH)-1: 2*Tn*BIT_WIDTH] <= repl_cands_reg[(2*Tn*BIT_WIDTH)-1: 1*Tn*BIT_WIDTH];
        */

        nfu1_out_reg <= nfu1_out;
        
    end

    //--------------------------------------------------// 
    //--------------------------------------------------// 
    //--------------------------------------------------//

endmodule // End module top_pipelin




