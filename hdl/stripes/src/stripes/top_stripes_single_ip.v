module top_serial_pipe (
                clk,
                reset,
                i_first_cycle,
                i_max,
				i_load,
			    i_precision,
                i_neurons,
                i_synapses,
                i_nbout,
                o_nfu2
    );

    parameter N = 16;  // Synapse bits
    parameter Ti = 16; // neuron tiling
    parameter Tn = 16; // synapse tiling
    parameter Tw = 16; // Window tiling, number of windows processed in parallel

    input clk;
    input reset;
    input i_first_cycle;
    input i_max;
    input i_load;
	  input [4:0] i_precision;
    input [Ti-1:0] i_neurons;
    //input [Ti-1:0][N-1:0] i_synapses;
    input [Ti*N-1:0] i_synapses;
    input [N-1:0] i_nbout;

    output [N-1:0] o_nfu2;
    
    reg [N-1:0] o_nfu2_out;

    assign o_nfu2 = o_nfu2_out;

    serial_ip_pipe SINGLE_TILE (
        clk,
        reset,
        i_first_cycle,
        i_max,
        i_load,
        i_precision,
        i_neurons,
        i_synapses,
        i_nbout,
        o_nfu2_out
    );

        

endmodule

