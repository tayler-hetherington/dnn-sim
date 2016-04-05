module testbench; 

  parameter SEL_BITS  = 4;
  parameter WL        = 16;
  parameter WORDS     = 16;

  reg                         clk;
  reg                         enable;
  reg  [ WORDS*WL - 1 : 0 ]   data;
  reg  [ SEL_BITS  : 0 ]      sel;

  wire [ WORDS - 1 : 0 ]      stream;

  initial begin
    clk = 1;
    data = 64'h0003000A000E000F;
    enable = 1;
    sel = 4'h0;
    #15
    enable = 0;
    data = 'bx;
    for (sel=1; sel<16; sel=sel+1) begin
      #10;
    end
    #10 
    $finish;
  end 

  always 
    #5 clk = !clk;

  initial  begin
    $dumpfile ("serial_ip_testbench.vcd"); 
    $dumpvars; 
  end 

  always @(posedge clk) begin
    #1
    $display("%4d data=%h select=%2d stream=%b",$time,data,sel,stream); 
  end

transposer t1 (clk, enable, sel, data, stream);

endmodule
