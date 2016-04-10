module testbench; 

  parameter N = 16;  // Synapse bits
  parameter Ti = 16; // neuron tiling
  parameter Tn = 16; // synapse tiling
  parameter Tw = 16; // Window tiling, number of windows processed in parallel

  reg                 clk;
  reg                 reset;
  reg                 i_first_cycle;
  reg                 i_max;
  reg                 i_load;
  reg  [N-1:0]      i_nbout;
  reg  [N-1:0]      result;

  
  reg  [N-1:0]  nval, temp_nval, sval;
  reg  [4:0]    i_precision;
  reg  [4:0]    count;

  wire  [Ti-1:0]       i_neurons;
  wire  [Ti*N-1:0]     i_synapses;

  wire  [N-1:0]      o_nfu2_out;


  initial begin
    clk = 1;
    reset = 1;
    i_first_cycle = 1;
    i_max = 0;
    i_load = 1;

    i_precision = 5;
    nval = 10;
    sval = 37;

    temp_nval = 0;
    i_nbout = 0;
    #15
    count = 0;
    reset = 0;
    #10
    i_first_cycle = 0;
  end 

  always 
    #5 clk = !clk;
	 
  always @(posedge clk) begin
      count = count + 1;
	 if (reset | i_first_cycle)
		temp_nval = nval;
	 else
		temp_nval = temp_nval << 1;
      if (count == i_precision + 3)
          result = o_nfu2_out;
  end

  initial  begin
    $dumpfile ("serial_ip_testbench.vcd"); 
    $dumpvars; 
  end 

  initial  begin
    $display("nval=%h sval=%h ans=%h",nval,sval,nval*sval*16);
    $display("%4s %10s %10s %64s %10s %10s","time","clk","i_neurons","i_synapses","i_nbout","o_nfu2_out");
    //$monitor("%4d %10b %10h %64h %10h %10h",$time, clk,i_neurons,i_synapses,i_nbout,o_nfu2_out); 
  end 

  always @(posedge clk)
    $display("%4d %10b %10h %64h %10h %10h",$time, clk,i_neurons,i_synapses,i_nbout,o_nfu2_out); 

  initial 
    #200 $finish; 

  genvar i;
  generate 
    for (i=0; i<Ti; i=i+1) begin: input_bcast
      assign i_neurons[i] = temp_nval[i_precision-1]; // serial input
      assign i_synapses[(i+1)*Ti-1:i*Ti] = sval; // broadcast same value to all inputs
    end
  endgenerate

  serial_ip_pipe ip_tile(
    clk,
    reset,
    i_first_cycle,
    i_max,
    i_load,
    i_precision,
    i_neurons   [Ti-1:0],
    i_synapses  [Ti*N-1:0],
    i_nbout     [N-1:0],
    o_nfu2_out  [N-1:0]
  );

endmodule
