//----------------------------------------------//
//----------------------------------------------//
// Top level pipeline. 
// Instantiates each of the pipeline stages, registers
// and necessary control signals.
// Tayler Hetherington
// 2015
//----------------------------------------------//
//----------------------------------------------//


module proteus_top_pipeline (
        clk,                    // Main clock
        i_inputs,               // Inputs from NBin
        i_synapses,             // Inputs from SB
        i_nbout_to_nfu2,        // Partial sum loaded from NBout into internal NFU-2 register
        i_load_nbout,           // Mux select for storing nbout or NFU-2 result in internal reg. 
        i_sigmoid_coef,         // Coefficient values to store in sigmoid RAM
        i_load_sigmoid_coef,    // Control signal to store sigmoid coefficients
        i_nbout_nfu2_nfu3,      // Control signal to store partial nfu-2 or nfu-3 results to NBout

        i_load,
        i_s,
        i_n,
        i_se,
        i_ze,
        i_z,
        i_nbout_load,
        i_nbout_row_sel,
        i_nbout_n,
        i_nbout_offset,

        o_nbout_packer_to_mem   // Output from NBout packer to memory?
    );

    parameter BIT_WIDTH = 16;
    parameter Tn = 16;
    parameter TnxTn = 256;

    parameter SHIFT_BITS = 5;  // 5 = log2(2*BIT_WIDTH)

    parameter BIT_IDX = 4; 

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


    // Proteus specific
    input [1:0]             i_load;
    input [SHIFT_BITS-1:0]  i_s;
    input [SHIFT_BITS-2:0]  i_n;
    input [BIT_WIDTH-1:0]   i_se;
    input [BIT_WIDTH-1:0]   i_ze;

    input [BIT_WIDTH-1:0]   i_z;

    input [2*BIT_WIDTH-1:0] i_nbout_load;
    input                   i_nbout_row_sel;
    input [BIT_IDX-1 : 0 ]  i_nbout_n;
    input [BIT_IDX-1:0]     i_nbout_offset;

    //----------- Output Ports ---------------//
    output [((BIT_WIDTH*Tn) - 1):0]     o_nbout_packer_to_mem;
    wire [((BIT_WIDTH*Tn) - 1):0]       nbout_to_packer;

    wire [((BIT_WIDTH*Tn) - 1):0] out_wire;

    //----------- Internal Signals --------------//
    
    wire [ (BIT_WIDTH*Tn) - 1 : 0 ]     nbin_unpk_out;
    wire [ (BIT_WIDTH*TnxTn) - 1 : 0 ]  sb_unpk_out;

    wire [ (BIT_WIDTH*Tn) - 1 : 0 ]     nbout_pk_out;
    
    
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
   
    reg [ (BIT_WIDTH*Tn) - 1 : 0 ]     nfu3_out_reg;
    
    //------------- Code Start -----------------//

    // Depending on current state, either write NFU-2 partial sum 
    // or NFU-3 final results to NBout
    
    // This should be going to NBout (unpacked) and then have a separate module for doing
    // the packing after NBout. However, NBout isn't modelled, so just do the packing here
    // to account for the extra hardware. 
    genvar i;
    generate
        for(i=0; i<Tn; i=i+1) begin : nb_unpack_gen

            // Bug fix for unpacker
            nbin_unpacker_v2 nb_unpk_v2 (
                .clk(clk),
                .i_in(nb_in_reg[(i+1)*BIT_WIDTH - 1 : i*BIT_WIDTH] ),
                .i_load(i_load),
                .i_s(i_s),
                .i_n(i_n),
                .i_se(i_se),
                .i_ze(i_ze),
                .o_out(nbin_unpk_out[(i+1)*BIT_WIDTH - 1: i*BIT_WIDTH])
            );                  

            /*
            nbin_unpacker nb_unpk (
                .clk(clk),
                .i_in(nb_in_reg[(i+1)*BIT_WIDTH - 1 : i*BIT_WIDTH] ),
                .i_load(i_load),
                .i_s(i_s),
                .i_n(i_n),
                .i_se(i_se),
                .o_out(nbin_unpk_out[(i+1)*BIT_WIDTH - 1: i*BIT_WIDTH])
            );
            */
        end
    endgenerate

    generate
        for(i=0; i<TnxTn; i=i+1) begin : sb_unpack_gen
            sb_unpacker sb_unpk (
                .clk(clk),
                .i_in(sb_reg[(i+1)*BIT_WIDTH - 1 : i*BIT_WIDTH] ),
                .i_load(i_load),
                .i_s(i_s),
                .i_z(i_z),
                .o_out(sb_unpk_out[(i+1)*BIT_WIDTH - 1: i*BIT_WIDTH])
            );           
        end
    endgenerate

    generate
        for(i=0; i<Tn; i=i+1) begin : nb_pack_gen
            nbout_packer nb_pk (
                .clk(clk),
                .i_in( nbout_to_packer[(i+1)*BIT_WIDTH - 1 : i*BIT_WIDTH ]),
                .i_s(i_s),
                .i_load(i_nbout_load),
                .i_row_sel(i_nbout_row_sel),
                .i_n(i_nbout_n),
                .i_offset(i_nbout_offset),
                .o_out(out_wire[(i+1)*BIT_WIDTH - 1: i*BIT_WIDTH])
            );           
        end
    endgenerate

    //assign nbout_to_packer = (i_nbout_nfu2_nfu3) ? nfu2_out : nfu3_out;
    assign nbout_to_packer = nfu3_out_reg;

    assign  o_nbout_packer_to_mem = out_wire;
    
    //--------------------------------------------------// 
    //-------------- Main Pipeline Stages --------------//
    //--------------------------------------------------//
    // NFU-1 (3 internal pipeline stages)
    nfu_1_pipe n1 (clk, nbin_unpk_out, sb_unpk_out, nfu1_out);

    // NFU-2 (2 internal pipeline stages)
    nfu_2_pipe n2(clk, nfu1_nfu2_pipe_reg, nfu2_nfu3_pipe_reg, nfu2_out);

    // NFU-3
    nfu_3 n3(clk, nfu2_nfu3_pipe_reg, i_sigmoid_coef, i_load_sigmoid_coef, nfu3_out);
    //--------------------------------------------------// 

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
    
        nfu3_out_reg <= (i_nbout_nfu2_nfu3) ? nfu2_out : nfu3_out;
    end

    //--------------------------------------------------// 
    //--------------------------------------------------// 
    //--------------------------------------------------//

endmodule // End module top_pipeline


module base_top_pipeline (
        clk,                    // Main clock
        i_inputs,               // Inputs from NBin
        i_synapses,             // Inputs from SB
        i_nbout_to_nfu2,        // Partial sum loaded from NBout into internal NFU-2 register
        i_load_nbout,           // Mux select for storing nbout or NFU-2 result in internal reg. 
        i_sigmoid_coef,         // Coefficient values to store in sigmoid RAM
        i_load_sigmoid_coef,    // Control signal to store sigmoid coefficients
        i_nbout_nfu2_nfu3,      // Control signal to store partial nfu-2 or nfu-3 results to NBout
        o_to_nbout
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
    wire [((BIT_WIDTH*Tn) - 1):0]       nbout_to_packer;



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

    reg [(BIT_WIDTH*Tn) - 1 : 0]        nfu3_out_reg;
    
    
    //------------- Code Start -----------------//

    // Depending on current state, either write NFU-2 partial sum 
    // or NFU-3 final results to NBout
    
    assign o_to_nbout = nfu3_out_reg;

    
    //--------------------------------------------------// 
    //-------------- Main Pipeline Stages --------------//
    //--------------------------------------------------// 
    
    // NFU-1 (3 internal pipeline stages)
    nfu_1_pipe n1 (clk, nb_in_reg, sb_reg, nfu1_out);


    // NFU-2 (2 internal pipeline stages)
    nfu_2_pipe n2(clk, nfu1_nfu2_pipe_reg, nfu2_nfu3_pipe_reg, nfu2_out);
    
    // NFU-3 (baseline already has 3 pipe stages)
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

        nfu3_out_reg <= (i_nbout_nfu2_nfu3) ? nfu2_out : nfu3_out;
    end

    //--------------------------------------------------// 
    //--------------------------------------------------// 
    //--------------------------------------------------//

endmodule // End module top_pipeline

