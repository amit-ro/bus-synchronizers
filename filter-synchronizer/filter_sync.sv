/*
	module for the filter synchronizer, simple synchronizer for bus lines.
	note that in this configuration the number of synchronizers is the same as the bus width.
	input:
	clk_a - domain a's clock.
	clk_b - domain b's clock.
	rstb_a - domain a reset value.
	rstb_b - domain b reset value.
	bus_in - input bus value.
	output: synchronized bus.
*/
`timescale 1ps / 1ps
module filter_sync #(parameter NUMBER_OF_BITS = 4)
			(input logic clk_a,
			input logic clk_b,
			input logic rstb_a,
			input logic rstb_b,
			input logic [NUMBER_OF_BITS-1:0] bus_in,
			output logic [NUMBER_OF_BITS-1:0] synchronized_bus);
	
	// variables decleration
	logic [NUMBER_OF_BITS-1:0] samp_bus;
	logic [NUMBER_OF_BITS-1:0] filter_in;
	logic [NUMBER_OF_BITS-1:0] mux_in;
	logic [NUMBER_OF_BITS-1:0] mux_out;
	
	// first bus sampling
	always_ff @ (posedge clk_a or negedge rstb_a)
		if (~rstb_a)
			samp_bus <= {NUMBER_OF_BITS{1'b0}};
		else
			samp_bus <= bus_in;
	
	// synchronizer
	dff_sync #(.WIDTH(NUMBER_OF_BITS)) synchronizer (.clk(clk_b), .resetb(rstb_b), .d(samp_bus), .q(filter_in));
	
	// filter
	always_ff @ (posedge clk_b or negedge rstb_b)
		if (~rstb_b)
			mux_in <= {NUMBER_OF_BITS{1'b0}};
		else
			mux_in <= filter_in;
	
	assign mux_out = (mux_in == filter_in) ? mux_in : synchronized_bus;
	
	always_ff @ (posedge clk_b or negedge rstb_b)
		if (~rstb_b)
			synchronized_bus <= {NUMBER_OF_BITS{1'b0}};
		else
			synchronized_bus <= mux_out;
endmodule
