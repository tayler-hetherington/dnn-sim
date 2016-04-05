`define CLOG2(x) \
    (x <= 2) ? 1 : \
    (x <= 4) ? 2 : \
    (x <= 8) ? 3 : \
    (x <= 16) ? 4 : \
    (x <= 32) ? 5 : \
    (x <= 64) ? 6 : \

module shuffler (
        clk,    // Main clock
        i_data, // input data
        i_sel,  // select signals
        o_data  // output data
    );

    // ASSUMPTION: Using a fixed 16to1 mux, assuming IN_BRICKS is 16

    parameter BL = 256;           // brick length
    parameter IN_BRICKS = 16;     // number of input brick busses
    parameter OUT_BRICKS = 16;    // number of output brick busses
    parameter SEL_BITS = 4; //`CLOG2(IN_BRICKS);    // number of select bits

    input clk;
    input  [ IN_BRICKS*BL - 1 : 0 ]            i_data;
    input  [ SEL_BITS*OUT_BRICKS -1 : 0 ]      i_sel;
    output [ OUT_BRICKS*BL - 1 : 0 ]           o_data;

    
    genvar i;
    generate
        for(i=0; i<OUT_BRICKS; i=i+1) begin : mux
          mux_16_to_1 #(BL) MUX_ARRAY (
              i_sel[(i+1)*SEL_BITS - 1 : i*SEL_BITS],
              i_data[(1)*BL-1  : (0)*BL],
              i_data[(2)*BL-1  : (1)*BL],
              i_data[(3)*BL-1  : (2)*BL],
              i_data[(4)*BL-1  : (3)*BL],
              i_data[(5)*BL-1  : (4)*BL],
              i_data[(6)*BL-1  : (5)*BL],
              i_data[(7)*BL-1  : (6)*BL],
              i_data[(8)*BL-1  : (7)*BL],
              i_data[(9)*BL-1  : (8)*BL],
              i_data[(10)*BL-1 : (9)*BL],
              i_data[(11)*BL-1 : (10)*BL],
              i_data[(12)*BL-1 : (11)*BL],
              i_data[(13)*BL-1 : (12)*BL],
              i_data[(14)*BL-1 : (13)*BL],
              i_data[(15)*BL-1 : (14)*BL],
              i_data[(16)*BL-1 : (15)*BL],
              o_data[(i+1)*BL-1 : (i+0)*BL]
            );
        end
    endgenerate

endmodule
