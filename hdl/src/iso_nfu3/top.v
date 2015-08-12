//----------------------------------------------//
//----------------------------------------------//
// Top level pipeline. 
// Tayler Hetherington
// 2015
//----------------------------------------------//
//----------------------------------------------//

module top_level (
        clk,                    // Main clock
        i_inputs,               // Inputs from NFU2_out
        i_nbout_nfu2_nfu3,
        i_sigmoid_coef,         // Coefficient values to store in sigmoid RAM
        i_load_sigmoid_coef,    // Control signal to store sigmoid coefficients      
        o_outputs              // Outputs to NBout
    );

    parameter BIT_WIDTH = 16;
    parameter Tn = 16;

    //----------- Input Ports ---------------//
    input                               clk;

    // i_inputs is a vector of Tn (16) values, 16-bits each
    input [((Tn*BIT_WIDTH) - 1):0]      i_inputs;
    input i_nbout_nfu2_nfu3;

    input [((2*BIT_WIDTH)-1):0]         i_sigmoid_coef; // 16-bit Ai and Bi = 32-bits
    input                               i_load_sigmoid_coef;

    //----------- Output Ports ---------------//
    output [((Tn*BIT_WIDTH) - 1):0]     o_outputs;


    //----------- Internal Signals --------------//
    // Wires
    wire [ (BIT_WIDTH*Tn) - 1 : 0 ]     nfu3_out;

    // Registers
    // NBin register for current inputs
    reg [ (BIT_WIDTH*Tn) - 1 : 0 ]      inputs_reg;

    reg [ (BIT_WIDTH*Tn) - 1 : 0 ]      nfu3_reg;

    
    //------------- Code Start -----------------//

    // Depending on current state, either write NFU-2 partial sum 
    // or NFU-3 final results to NBout
    assign o_outputs = (i_nbout_nfu2_nfu3) ? inputs_reg : nfu3_reg; 
    
    // NFU-3
    nfu_3 n3(clk, inputs_reg, i_sigmoid_coef, i_load_sigmoid_coef, nfu3_out);
    
    
    always @(posedge clk) begin
         inputs_reg <= i_inputs;

         nfu3_reg <= nfu3_out;
    end

    //--------------------------------------------------// 
    //--------------------------------------------------// 
    //--------------------------------------------------//

endmodule // End module top_pipeline






