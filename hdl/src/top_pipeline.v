//----------------------------------------------//
//----------------------------------------------//
// Top level pipeline. 
// Instantiates each of the pipeline stages, registers
// and necessary control signals.
// Tayler Hetherington
// 2015
//----------------------------------------------//
//----------------------------------------------//

module top_pipeline (
        clk,                    // Main clock
        i_inputs,               // Inputs from NBin
        i_synapses,             // Inputs from SB
        i_nbout_to_nfu2,        // Partial sum loaded from NBout into internal NFU-2 register
        i_load_nbout,           // Mux select for storing nbout or NFU-2 result in internal reg. 
        i_sigmoid_coef,         // Coefficient values to store in sigmoid RAM
        i_load_sigmoid_coef,    // Control signal to store sigmoid coefficients
        i_nbout_nfu2_nfu3,      // Control signal to store partial nfu-2 or nfu-3 results to NBout
        o_to_nbout              // Output from pipeline to NBout
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

    input                               i_nbout_nfu2_nfu3;
    input                               i_load_nbout;
    input [(BIT_WIDTH*Tn) - 1 : 0]      i_nbout_to_nfu2;

    input [((2*BIT_WIDTH)-1):0]         i_sigmoid_coef; // 16-bit Ai and Bi = 32-bits
    input                               i_load_sigmoid_coef;

    //----------- Output Ports ---------------//
    output [((BIT_WIDTH*Tn) - 1):0]     o_to_nbout;


    //----------- Internal Signals --------------//
    // Wires
    wire [((BIT_WIDTH*TnxTn) - 1):0]    nfu1_out;
    wire [ (BIT_WIDTH*Tn) - 1 : 0 ]     nfu2_out;
    wire [ (BIT_WIDTH*Tn) - 1 : 0 ]     nfu3_out;

    // Registers
    // NBin register for current inputs
    reg [ (BIT_WIDTH*Tn) - 1 : 0 ]      nb_in_reg;

    // SB register for current synapses
    reg [((BIT_WIDTH*TnxTn) - 1):0]     sb_reg;
    
    // Main pipeline registers
    reg [((BIT_WIDTH*TnxTn) - 1):0]     nfu1_nfu2_pipe_reg;
    reg [ (BIT_WIDTH*Tn) - 1 : 0 ]      nfu2_nfu3_pipe_reg;
    
    
    //------------- Code Start -----------------//

    // Depending on current state, either write NFU-2 partial sum 
    // or NFU-3 final results to NBout
    assign o_to_nbout = (i_nbout_nfu2_nfu3) ? nfu2_out : nfu3_out;
    
    
    //--------------------------------------------------// 
    //-------------- Main Pipeline Stages --------------//
    //--------------------------------------------------// 
    // NFU-1
    nfu_1 n1 (clk, nb_in_reg, sb_reg, nfu1_out);
    
    // NFU-2
    nfu_2 n2(clk, nfu1_nfu2_pipe_reg, nfu2_nfu3_pipe_reg, nfu2_out);
    
    // NFU-3
    nfu_3 n3(clk, nfu2_nfu3_pipe_reg, i_sigmoid_coef, i_load_sigmoid_coef, nfu3_out);
    
    
    always @(posedge clk) begin
        // Load the inputs from the SRAMs to the internal registers
        nb_in_reg <= i_inputs;
        sb_reg <= i_synapses;

        // Either load NBout (with partial sum) into the nfu2_nfu3_pipe 
        // reg or store the result of nfu2_out.
        if (i_load_nbout) begin
            nfu2_nfu3_pipe_reg <= i_nbout_to_nfu2;
        end else begin
            nfu2_nfu3_pipe_reg <= nfu2_out;
        end
        
        nfu1_nfu2_pipe_reg <= nfu1_out;
    end

    //--------------------------------------------------// 
    //--------------------------------------------------// 
    //--------------------------------------------------//

endmodule // End module top_pipelin






