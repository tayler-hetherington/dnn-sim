module testbench; 

  parameter BL = 256;           // brick length
  parameter IN_BRICKS = 16;     // number of input brick busses
  parameter OUT_BRICKS = 16;    // number of output brick busses
  parameter SEL_BITS = 4; //`CLOG2(IN_BRICKS);    // number of select bits

  reg                 clk;
  reg  [ IN_BRICKS*BL - 1 : 0 ]            i_data;
  reg  [ SEL_BITS*OUT_BRICKS -1 : 0 ]      i_sel;

  wire [ OUT_BRICKS*BL - 1 : 0 ]           o_data;

  initial begin
    clk = 1;
    i_data = {
      256'h0000000000000000000000000000000000000000000000000000000000000000,
      256'h0001000100010001000100010001000100010001000100010001000100010001,
      256'h0002000200020002000200020002000200020002000200020002000200020002,
      256'h0003000300030003000300030003000300030003000300030003000300030003,
      256'h0004000400040004000400040004000400040004000400040004000400040004,
      256'h0005000500050005000500050005000500050005000500050005000500050005,
      256'h0006000600060006000600060006000600060006000600060006000600060006,
      256'h0007000700070007000700070007000700070007000700070007000700070007,
      256'h0008000800080008000800080008000800080008000800080008000800080008,
      256'h0009000900090009000900090009000900090009000900090009000900090009,
      256'h000A000A000A000A000A000A000A000A000A000A000A000A000A000A000A000A,
      256'h000B000B000B000B000B000B000B000B000B000B000B000B000B000B000B000B,
      256'h000C000C000C000C000C000C000C000C000C000C000C000C000C000C000C000C,
      256'h000D000D000D000D000D000D000D000D000D000D000D000D000D000D000D000D,
      256'h000E000E000E000E000E000E000E000E000E000E000E000E000E000E000E000E,
      256'h000F000F000F000F000F000F000F000F000F000F000F000F000F000F000F000F
    };
    #10
    i_sel = 64'h0123456789ABCDEF;
    #10 
    i_sel = 64'h0000000000000000;
    #10 
    i_sel = 64'hFFFFFFFFFFFFFFFF;
    #10 
    i_sel = 64'h02468ACE00000000;
    #10 
    $finish;


  end 

  always 
    #5 clk = !clk;

  initial  begin
    $dumpfile ("serial_ip_testbench.vcd"); 
    $dumpvars; 
  end 

  initial  begin
    $display("i_data=%h i_sel=%h o_data=%h",i_data,i_sel,o_data);
  end 

  always @(negedge clk) begin
    $display("%4d",$time); 
    $display("i_sel=%h",i_sel); 
    $display(" 0: %32h",o_data[(1*256)-1:(0*256)]); 
    $display(" 1: %32h",o_data[(2*256)-1:(1*256)]); 
    $display(" 2: %32h",o_data[(3*256)-1:(2*256)]); 
    $display(" 3: %32h",o_data[(4*256)-1:(3*256)]); 
    $display(" 4: %32h",o_data[(5*256)-1:(4*256)]); 
    $display(" 5: %32h",o_data[(6*256)-1:(5*256)]); 
    $display(" 6: %32h",o_data[(7*256)-1:(6*256)]); 
    $display(" 7: %32h",o_data[(8*256)-1:(7*256)]); 
    $display(" 8: %32h",o_data[(9*256)-1:(8*256)]); 
    $display(" 9: %32h",o_data[(10*256)-1:(9*256)]); 
    $display("10: %32h",o_data[(11*256)-1:(10*256)]); 
    $display("11: %32h",o_data[(12*256)-1:(11*256)]); 
    $display("12: %32h",o_data[(13*256)-1:(12*256)]); 
    $display("13: %32h",o_data[(14*256)-1:(13*256)]); 
    $display("14: %32h",o_data[(15*256)-1:(14*256)]); 
    $display("15: %32h",o_data[(16*256)-1:(15*256)]); 
  end

//shuffler s1 (clk, i_data, i_sel, o_data);
transposer t1 (clk, enable, select, data, stream);

endmodule
