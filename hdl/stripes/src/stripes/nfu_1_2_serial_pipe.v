//----------------------------------------------//
//----------------------------------------------//
// NFU-1-2: Serial inner product
// Patrick Judd
// 2016
//----------------------------------------------//
//----------------------------------------------//

//---------------------------------------------//
// 256 serial inner product trees calculating
// inner products of 16 neuron vectors from 16 windows
// crosses with the corresponding 16 synapse vectors 
// from 16 filters
//---------------------------------------------//


// DC and Synplify should be able to synthesize multidimensional ports
// If not you can use these macros to pack the multidimensional signals to
// a 1-D port
//`define PACK_ARRAY(PK_WIDTH,PK_LEN,PK_SRC,PK_DEST)    genvar pk_idx; generate for (pk_idx=0; pk_idx<(PK_LEN); pk_idx=pk_idx+1) begin; assign PK_DEST[((PK_WIDTH)*pk_idx+((PK_WIDTH)-1)):((PK_WIDTH)*pk_idx)] = PK_SRC[pk_idx][((PK_WIDTH)-1):0]; end; endgenerate
//`define UNPACK_ARRAY(PK_WIDTH,PK_LEN,PK_DEST,PK_SRC)  genvar unpk_idx; generate for (unpk_idx=0; unpk_idx<(PK_LEN); unpk_idx=unpk_idx+1) begin; assign PK_DEST[unpk_idx][((PK_WIDTH)-1):0] = PK_SRC[((PK_WIDTH)*unpk_idx+(PK_WIDTH-1)):((PK_WIDTH)*unpk_idx)]; end; endgenerate

//module example (
//  input  [63:0] pack_4_16_in,
//  output [31:0] pack_16_2_out
//);
//
//wire [3:0] in [0:15];
//`UNPACK_ARRAY(4,16,in,pack_4_16_in)
//
//wire [15:0] out [0:1];
//`PACK_ARRAY(16,2,in,pack_16_2_out)

module adder_array (
        i_vals,
        o_res
    );

    parameter W = 8;
    parameter N = 16;

    input   [(2*W*N) - 1 : 0] i_vals;
    output  [(W*(N+1)) - 1 : 0]   o_res;

    // Create W adders and add each pair of values from i_vals and store in o_res
    // (e.g., [0]+[1], [2]+[3] ... [W-2]+[W-1] )
    genvar j;
    generate
        for(j=0; j<W; j=j+1) begin : adder_array
            m_addr #(N) ADD_ARRAY (
                    i_vals  [ ((2*j)+1)*N - 1 : (2*j)*N       ],
                    i_vals  [ ((2*j)+2)*N - 1 : ((2*j)+1)*N   ],
                    o_res   [ (j+1)*(N+1) - 1     : j*(N+1)   ]
            );
        end
    endgenerate
endmodule

//module add_sub_array (
        //i_sub,
        //i_vals,
        //o_res
    //);

    //parameter W = 8;
    //parameter N = 16;

    //input   [W - 1 : 0] i_sub;
    //input   [(2*W*N) - 1 : 0] i_vals;
    //output  [(W*(N+1)) - 1 : 0]   o_res;

    //// Create W adders and add each pair of values from i_vals and store in o_res
    //// (e.g., [0]+[1], [2]+[3] ... [W-2]+[W-1] )
    //genvar j;
    //generate
        //for(j=0; j<W; j=j+1) begin : adder_array
            //m_add_sub #(W,N) ADD_ARRAY (
                    //i_sub   [j],
                    //i_vals  [ ((2*j)+1)*N - 1 : (2*j)*N       ],
                    //i_vals  [ ((2*j)+2)*N - 1 : ((2*j)+1)*N   ],
                    //o_res   [ (j+1)*(N+1) - 1     : j*(N+1)           ]
            //);
        //end
    //endgenerate
//endmodule

// adder tree that reduces Tn N-bit integers to one N-bit integer
module Tn_adder_tree_pipe (
        clk,
        i_nfu1,         // multiplication data
        //i_nbout,        // Partial SUM from NBOut
        o_results
    );

    parameter N = 16;
    parameter Tn = 16;

    //----------- Input Ports ---------------//
    input                           clk;
	 //input [Tn-1:0][N-1:0]           i_nfu1;   // Tn x Tn inputs
    input [(Tn*N)-1:0]              i_nfu1;   // Tn x Tn inputs
    //input [N-1:0]                   i_nbout;     // Tn partial sums
    
    //----------- Output Ports ---------------//
    output [(N+4)-1:0]                  o_results;
    
    //----------- Internal Signals ---------------//

    // Adder tree connection wires
    wire [ (Tn*(N+1)/2)-1 : 0 ]        level_0_out;    // 8 buses
    wire [ (Tn*(N+2)/4)-1 : 0 ]        level_1_out;    // 4 busses
    wire [ (Tn*(N+3)/8)-1 : 0 ]        level_2_out;    // 2 busses
    wire [ (Tn*(N+4)/16)-1 : 0 ]       level_3_out;    // 1 bus
    
    wire [ (N-1) : 0 ]              partial_sum_out; // 1 bus from partial sum add
    
    reg [ (Tn*(N+2)/4)-1 : 0 ]         level_1_reg;    // 4 busses pipe reg

    //------------------------------------------//
    //------------- Code Start -----------------//
    //------------------------------------------//
   
    // Internal pipe register (2 pipe stages)
    always @(posedge clk) begin
        level_1_reg <= level_1_out;
    end


    // Construct the adder tree
    adder_array #(.W(8), .N(16)) L0 (     i_nfu1, level_0_out);
    adder_array #(.W(4), .N(17)) L1 (level_0_out, level_1_out); // Separated here with pipeline reg
    adder_array #(.W(2), .N(18)) L2 (level_1_reg, level_2_out); // ---
    adder_array #(.W(1), .N(19)) L3 (level_2_out, level_3_out);
    
    // Level 4: 
    //     DianNao paper only mentions 16 x 15 adders in the tree. But since adders are only
    //     2 input, we have Tn (16) values per neuron to add (15 adders) plus the partial sum (16 adders)
    //m_addr L4 (
        //level_3_out,
        //i_nbout,
        //partial_sum_out
    //);
    
    // Output
    //assign o_results = partial_sum_out;
    assign o_results = level_3_out;
    
endmodule 


// Serial inner product pipeline
// input:   16 element vector of neurons, fed serially
//          16 element vector of synapses, 16 parallel bits
//          16 element partial sum input
// output:  16 element partial sum output
module serial_ip_pipe (
                clk,
                reset,
                i_first_cycle,
					      i_precision,
                i_neurons,
                i_synapses,
                i_nbout,
                o_nfu2_out
            );
                //i_neurons   [w]   [Ti-1:0],
                //i_synapses     [n][Ti-1:0][N-1:0],
                //i_nbout     [w][n]        [N-1:0],
                //o_nfu2_out  [w][n]        [N-1:0],
    parameter N = 16;  // Synapse bits
    parameter Ti = 16; // neuron tiling
    parameter Tn = 16; // synapse tiling
    parameter Tw = 16; // Window tiling, number of windows processed in parallel

    input clk;
    input reset;
    input i_first_cycle;
	 input [4:0] i_precision;
    input [Ti-1:0] i_neurons;
    //input [Ti-1:0][N-1:0] i_synapses;
    input [Ti*N-1:0] i_synapses;
    input [N-1:0] i_nbout;

    output [N-1:0] o_nfu2_out;

	 reg [2*N-1:0] acc_out;

	 
    //wire [Ti-1:0][N-1:0] and_out;
    wire [Ti*N-1:0] and_out;
    //wire [Tn-1:0][N-1:0] complement_out;
    wire [ (Tn*N)-1 : 0 ]           complement_out;
    wire [N+4-1:0] tree_out;

    // 1. 1 bit multiplication (and)
    genvar i;
    genvar b;
    generate
        for(i=0; i<Ti; i=i+1) begin : and_gates1
          for(b=0; b<N; b=b+1) begin : and_gates2
            //assign and_out[i][N-1:0] = i_synapses[i][N-1:0] & i_neurons[i];
            assign and_out[i*N + b] = i_synapses[i*N + b] & i_neurons[i];
          end
        end
    endgenerate

    // 2. generate 2's compliment for negative MSB
    generate
        for(i=0; i<Ti; i=i+1) begin : complement1
          //assign complement_out[i][N-1:0] = (first_cycle & i_neurons)? ~and_out[i][N-1:0] + 1 : and_out[i][N-1:0];
          //assign complement_out[(i+1)*N-1:i*N] = (first_cycle & i_neurons)? ~and_out[(i+1)*N-1:i*N] + 1 : and_out[(i+1)*N-1:i*N];
          assign complement_out[(i+1)*N-1:i*N] = (i_first_cycle & i_neurons[i])? ~and_out[(i+1)*N-1:i*N] + 16'b1 : and_out[(i+1)*N-1:i*N];
        end
    endgenerate

    // 3. adder tree
    Tn_adder_tree_pipe tree(
        clk,
        complement_out,         
        //i_nbout,        
        tree_out
    );

    // 4. accumulator
    always @(posedge clk) begin
      if (reset)
        acc_out <= {16'b0,i_nbout};
      else
        acc_out <= {{12{tree_out[19]}},tree_out} + (acc_out << 1);
    end
    
	 assign o_nfu2_out[N-1:0] = acc_out[N-1:0];

endmodule

//---------------------------------------------//
// Main NFU-2 module
//---------------------------------------------//
module nfu_1_2_serial_pipe (
        clk,
        reset,
        i_first_cycle,
		i_precision,
        i_neurons,
        i_synapses,
        i_nbout,
        o_nfu2_out
    );

    parameter N = 16;  // Synapse bits
    parameter Ti = 16; // neuron tiling
    parameter Tn = 16; // synapse tiling
    parameter Tw = 16; // Window tiling, number of windows processed in parallel

    //----------- Input Ports ---------------//
    input clk;
    input reset;
    input i_first_cycle; // control signal, indicating MSB
    input [4:0] i_precision;
    input [ ((1*Tw*Tn) - 1) : 0 ]      i_neurons; // neurons are fed in serially
    input [ ((N*Tn*Tn) - 1) : 0 ]      i_synapses;
    input [ ((N*Tw*Tn) - 1) : 0 ]      i_nbout; // feedback path
    //input [Tw-1:0][Ti-1:0]      i_neurons;
    //input [Tn-1:0][Ti-1:0][N-1:0]      i_synapses;
    //input [Tw-1:0][Tn-1:0][N-1:0]      i_nbout; // feedback path
    
    //----------- Output Ports ---------------//
    //output [Tw-1:0][Tn-1:0][N-1:0]     o_nfu2_out;
    output [(Tw*Tn*N) - 1 : 0]     o_nfu2_out;

    // Test one tile
    //serial_ip_pipe ip_tile(
      //clk,
      //reset,
      //i_first_cycle,
		//i_precision,
      //i_neurons   [Ti-1:0],
      //i_synapses  [Ti*N-1:0],
      //i_nbout     [N-1:0],
      //o_nfu2_out  [N-1:0]
    //);

    //------------- Code Start -----------------//
    // Tn*Tw serial inner prodct trees
    genvar n;
    genvar w;
    generate
        for(w=0; w<Tw; w=w+1) begin : W_TILE
          for(n=0; n<Tn; n=n+1) begin : N_TILE
            serial_ip_pipe ip_tile (
                clk,
                reset,
                i_first_cycle,
                i_precision,
                //i_neurons   [w]   [Ti-1:0],
                i_neurons   [ Ti*(w+1) - 1 : Ti*w ],
                //i_synapses     [n][Ti-1:0][N-1:0],
                i_synapses  [ Ti*N*(n+1) - 1 : Ti*N*n ],
                //i_nbout     [w][n]        [N-1:0],
                i_nbout    [ N*(w*Tn + n + 1) - 1 :  N*(w*Tn + n) ],
                //o_nfu2_out  [w][n]        [N-1:0]
                o_nfu2_out [ N*(w*Tn + n + 1) - 1 :  N*(w*Tn + n) ]
            );
          end
        end
    endgenerate
    
endmodule // End module nfu_2







