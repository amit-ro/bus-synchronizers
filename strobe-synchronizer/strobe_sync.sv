/*
	module for the strobe synchronizer, sinple bus synchronizer.
	in this configuration there is only one sunchrinizer, in that way it saves hardware.
	only the change detection is synchronized, after it is successfully synchronized it passes the input bus.
	input:
	clk_a - domain a's clock.
	clk_b - domain b's clock.
	rstb_a - domain a reset value.
	rstb_b - domain b reset value.
	bus_in - input bus value.
	output: synchronized bus.
*/
`timescale 1ps / 1ps
module strobe_sync #(parameter NUMBER_OF_BITS = 4)
			(input logic clk_a,
			input logic clk_b,
			input logic rstb_a,
			input logic rstb_b,
			input logic [NUMBER_OF_BITS-1:0] bus_in,
			output logic [NUMBER_OF_BITS-1:0] synchronized_bus);

	// variable decleration
	logic [NUMBER_OF_BITS-1:0] samp_bus;
	logic change_detector;
	logic sync_out;
	logic deriv_ff;
	logic edge_detect;
	logic [NUMBER_OF_BITS-1:0] mux_out;
	
	// bus sampling
	always_ff @ (posedge clk_a or negedge rstb_a)
		if (~rstb_a)
			samp_bus <= {NUMBER_OF_BITS{1'b1}};
		else
			samp_bus <= bus_in;
	
	// change detector
	always_ff @ (posedge clk_a or negedge rstb_a)
		if (~rstb_a)
			change_detector <= 1'b0;
		else 
			change_detector <= (bus_in != samp_bus);
			
	// synchronizer
	dff_sync synchronizer (.clk(clk_b), .resetb(rstb_b), .d(change_detector), .q(sync_out));
	
	// posedge deriver
	always_ff @ (posedge clk_b or negedge rstb_b)
		if (~rstb_b)
			deriv_ff <= 1'b0;
		else
			deriv_ff <= sync_out;
			
	assign edge_detect = sync_out&(~deriv_ff);
	
	// output bus sampling
	assign mux_out = edge_detect? samp_bus:synchronized_bus;
	
	always_ff @ (posedge clk_b or negedge rstb_b)
		if (~rstb_b)
			synchronized_bus <= {NUMBER_OF_BITS{1'b0}};
		else
			synchronized_bus <= mux_out;
endmodule
