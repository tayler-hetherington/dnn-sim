// Patrick Judd 2016-03-04
// 16x16 register bank that can be loaded all at once
// and read out each bit of the word serially
//
// version 1: using a 16to1 mux per word

module register (
    clk,
    enable,
    d,
    q
    );

  input clk;
  input enable;
  input d;
  output reg q;

  always @(posedge clk) begin
    if (enable==1)
      q <= d;
  end

endmodule

module transposer (
    clk, 
    i_enable,
    i_sel,
    i_data,
    o_stream
);
    parameter SEL_BITS  = 4;
    parameter WL        = 16;
    parameter WORDS     = 16;
  
    input clk; 
    input i_enable;
    input [ SEL_BITS - 1 : 0 ] i_sel;
    input [ WL * WORDS - 1 : 0 ] i_data;
    wire [ WL * WORDS - 1 : 0 ] q;
    output [ WORDS - 1 : 0 ] o_stream;
  
    genvar i,j;
    generate
        for(j=0; j<WORDS; j=j+1) begin : words
          for(i=0; i<WL; i=i+1) begin : bits
            register REG (clk, i_enable, i_data[j*WORDS+i], q[j*WORDS+i]);
          end
          mux_16_to_1 #(1) MUX_ARRAY ( i_sel, 
              q[j*WORDS+0],
              q[j*WORDS+1],
              q[j*WORDS+2],
              q[j*WORDS+3],
              q[j*WORDS+4],
              q[j*WORDS+5],
              q[j*WORDS+6],
              q[j*WORDS+7],
              q[j*WORDS+8],
              q[j*WORDS+9],
              q[j*WORDS+10],
              q[j*WORDS+11],
              q[j*WORDS+12],
              q[j*WORDS+13],
              q[j*WORDS+14],
              q[j*WORDS+15],
              o_stream[j]);
        end
    endgenerate

endmodule

module transposer_array (
    clk, 
    i_enable,
    i_sel,
    i_data,
    o_stream
);
    parameter SEL_BITS   = 4;
    parameter WL         = 16;
    parameter WORDS      = 16;
    parameter ARRAY_SIZE = 16;
    parameter BL = WL * WORDS;  // BRICK LENGTH in bits
  
    input clk; 
    input [ ARRAY_SIZE - 1 : 0 ] i_enable;
    input [ SEL_BITS - 1 : 0 ] i_sel;
    input [ ARRAY_SIZE * BL - 1 : 0 ] i_data;
    wire [ ARRAY_SIZE * BL - 1 : 0 ] q;
    output [ ARRAY_SIZE * WORDS - 1 : 0 ] o_stream;

    reg [ ARRAY_SIZE - 1 : 0 ] i_enable_reg;
    reg [ SEL_BITS - 1 : 0 ] i_sel_reg;
    reg [ ARRAY_SIZE * BL - 1 : 0 ] i_data_reg;
    reg [ ARRAY_SIZE * WORDS - 1 : 0 ] o_stream_reg;

    wire [ ARRAY_SIZE * WORDS - 1 : 0 ] o;


    assign o_stream = o_stream_reg;
    always @(posedge clk) begin
        i_enable_reg <= i_enable;
        i_sel_reg <= i_sel;
        i_data_reg <= i_data;
        o_stream_reg <= o;
    end


    genvar i;
    generate
      for (i=0; i<ARRAY_SIZE; i=i+1) begin : TRANS_ARRAY
        transposer TRANS(
            clk,
            i_enable_reg[i],
            i_sel_reg,
            i_data_reg[ (i+1)*BL-1 : i*BL ],
            o[ (i+1)*WORDS-1 : i*WORDS ]
          );
      end
    endgenerate

endmodule
