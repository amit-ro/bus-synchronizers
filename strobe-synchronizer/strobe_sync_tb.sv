/*
	testbench for the strobe synchronizer
*/
`timescale 1ps / 1ps
module strobe_sync_tb();
	logic clk_domain_a;
	logic clk_domain_b;
	logic rstb_domain_a;
	logic rstb_domain_b;
	logic [3:0] bus_in;
	logic [3:0]out_val;
	
	strobe_sync strobe_sync_DUT (.clk_a(clk_domain_a),
							 .clk_b(clk_domain_b), 
							 .rstb_a(rstb_domain_a),
							 .rstb_b(rstb_domain_b),
							 .bus_in(bus_in),
							 .synchronized_bus(out_val));
							 
							 
	initial
	begin
		fork
			forever	#5ns
				clk_domain_a = ~clk_domain_a;
			
			#2ns forever #5ns
				clk_domain_b = ~clk_domain_b;
		join
	end
	
	initial
	
	begin
		{clk_domain_b, clk_domain_a, rstb_domain_a, rstb_domain_b} = 1'b0;
		bus_in = 4'b0;
		#15ns;	
		@ (posedge clk_domain_a)
			rstb_domain_a = 1'b1;
		
		@ (posedge clk_domain_b)
			rstb_domain_b = 1'b1;
		#50ns;
		
		@ (posedge clk_domain_a)
			bus_in = 4'b1010;
	end
endmodule

