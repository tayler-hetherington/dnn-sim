//----------------------------------------------//
//----------------------------------------------//
// NFU-1: Convolution multiplication
// Tayler Hetherington
// 2015
//----------------------------------------------//
//----------------------------------------------//

module neuron_Tn_mult (
        clk,
        i_input,
        i_synapses,
        o_mult_out
    );

    parameter N = 16;
    parameter Tn = 16;

    //----------- Inputs ---------------//
    input                   clk;

    // Single 16-bit input value
    input [N*Tn - 1:0]  i_input;

    // Tn 16-bit synapses per input value
    input [N*Tn - 1:0]  i_synapses;

    //----------- Outputs ---------------//
    // Tn 16-bit outputs
    output [N*Tn - 1:0] o_mult_out;

    //------------- Code Start -------------//
    //assign o_mult_out = i_input*i_synapses;
/*
            mult_piped MULT_PIPE1 (
                clk,
                i_input[ (1)*N - 1 : (0*N) ],
                i_synapses[ ((1)*N) - 1 : (0*N) ],
                o_mult_out[ ((1)*N) - 1 : (0*N) ]
            );

            mult_piped MULT_PIPE2 (
                clk,
                i_input[ (1+1)*N - 1 : (1*N) ],
                i_synapses[ ((1+1)*N) - 1 : (1*N) ],
                o_mult_out[ ((1+1)*N) - 1 : (1*N) ]
            );
*/

    genvar j;
    generate
        for(j=0; j<Tn; j=j+1) begin : mult
            // Pipelined multiplier with 2 internal pipe
            // registers => 3 pipeline stages
            mult_piped MULT_PIPE (
                clk,
                i_input   [ (j+1)*N - 1 : (j*N) ],
                i_synapses[ (j+1)*N - 1 : (j*N) ],
                o_mult_out[ (j+1)*N - 1 : (j*N) ]
            );
        end
    endgenerate
endmodule // End module neruon_Tn_mult


//---------------------------------------------//
// Main NFU-1 module
//---------------------------------------------//
module nfu_1_pipe (
        clk,
        i_inputs,
        i_synapses,
        o_results    
    );

    parameter N = 16;
    parameter Tn = 16;

    input clk;
    
    //----------- Inputs ---------------//
    // i_inputs is a vector of Tn (16) values, 16-bits each
    input [((N*Tn) - 1):0] i_inputs;
    
    // i_synapses is a matrix of Tn x Tn (16x16=256) values, 16-bits each (Row-major).
    input [((N*Tn*Tn) - 1):0] i_synapses;
    
    //----------- Outputs ---------------//
    output [((N*Tn*Tn) - 1):0] o_results;
    
    reg [N*Tn - 1:0] i_reg [1:0];
    reg [N*Tn*Tn - 1:0] s_reg [1:0];
    always @(posedge clk) begin
        i_reg[0] <= i_inputs;
        i_reg[1] <= i_reg[0];
        s_reg[0] <= i_synapses;
        s_reg[1] <= s_reg[0];
    end
    


    //------------- Code Start -----------------//
    genvar i;
    generate
        for(i=0; i<Tn; i=i+1) begin : Tnmult
            neuron_Tn_mult #(.N(N), .Tn(Tn)) M (
                clk,
                //i_inputs,
                i_reg[1],
                s_reg[1][ (i+1)*Tn*N - 1 : (i*Tn*N) ],
                //i_synapses[ (i+1)*Tn*N - 1 : (i*Tn*N) ],
                o_results [ (i+1)*Tn*N - 1 : (i*Tn*N) ]
            );
        end
    endgenerate
 
endmodule // End module nfu_1

module nfu_1_pipe_broken (
        clk,
        i_inputs,
        i_synapses,
        o_results    
    );

    parameter N = 16;
    parameter Tn = 16;

    input clk;
    
    //----------- Inputs ---------------//
    // i_inputs is a vector of Tn (16) values, 16-bits each
    input [((N*Tn) - 1):0] i_inputs;
    
    // i_synapses is a matrix of Tn x Tn (16x16=256) values, 16-bits each (Row-major).
    input [((N*Tn*Tn) - 1):0] i_synapses;
    
    //----------- Outputs ---------------//
    output [((N*Tn*Tn) - 1):0] o_results;
    
    //------------- Code Start -----------------//
    genvar i;
    generate
        for(i=0; i<Tn; i=i+1) begin : Tnmult
            neuron_Tn_mult #(.N(N), .Tn(Tn)) M (
                clk,
                i_inputs,
                i_synapses[ (i+1)*Tn*N - 1 : (i*Tn*N) ],
                o_results [ (i+1)*Tn*N - 1 : (i*Tn*N) ]
            );
        end
    endgenerate
 
endmodule // End module nfu_1

