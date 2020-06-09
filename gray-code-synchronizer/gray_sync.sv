/*
	module that implements an incremental bus synchronizer.
	if the bus is incremental (counter for example) the synchronization can be done with simple synchronizers.
	the only thing that should be noted is that the value needs to be converted to gray code.
	input:
	clk_a - domain a's clock.
	clk_b - domain b's clock.
	rstb_a - domain a reset value.
	rstb_b - domain b reset value.
	enable - enable signal.
	output: synchronized bus.
*/
`timescale 1ps / 1ps
module gray_sync #(parameter NUMBER_OF_BITS = 4)
		(input logic clk_a,
		input logic clk_b,
		input logic rstb_a,
		input logic rstb_b,
		input logic enable,
		output logic [NUMBER_OF_BITS-1:0] out_val);
	
	// inner variables
	logic [NUMBER_OF_BITS-1:0] inc_mux;
	logic [NUMBER_OF_BITS-1:0] g_count_in;
	logic [NUMBER_OF_BITS-1:0] g_count_out;
	logic [NUMBER_OF_BITS-1:0] b_count;
	logic [NUMBER_OF_BITS-1:0] sync_out;
	
	// gray to binary converter
	gray2bin #(.NUMBER_OF_BITS(NUMBER_OF_BITS)) bin_count (.gray_in(g_count_out), .bin_out(b_count));
	
	// increment by 1 if enable is 1
	assign inc_mux = enable ? b_count + 1'b1 : b_count;
	
	// binary to gray converter
	bin2gray #(.NUMBER_OF_BITS(NUMBER_OF_BITS)) g_in (.bin_in(inc_mux), .gray_out(g_count_in));
	
	// flip flop sample before synchronization
	always_ff @ (posedge clk_a or negedge rstb_a)
		if (~rstb_a)
			g_count_out <= {NUMBER_OF_BITS{1'b0}};
		else
			g_count_out <= g_count_in;
	
	// synchronizer
	dff_sync #(.WIDTH(NUMBER_OF_BITS)) sync_bus (.clk(clk_b), .resetb(rstb_b), .d(g_count_out), .q(sync_out));
	
	// gray to binary converter
	gray2bin #(.NUMBER_OF_BITS(NUMBER_OF_BITS)) bin_out_val (.gray_in(sync_out), .bin_out(out_val));
endmodule