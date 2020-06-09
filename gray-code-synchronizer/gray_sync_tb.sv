/*
	test bench for the gray synchronizer
*/

`timescale 1ps / 1ps
module gray_sync_tb();
	logic clk_domain_a;
	logic clk_domain_b;
	logic rstb_domain_a;
	logic rstb_domain_b;
	logic enable;
	logic [3:0]out_val;
	
	gray_sync gray_sync_DUT (.clk_a(clk_domain_a),
							 .clk_b(clk_domain_b), 
							 .rstb_a(rstb_domain_a),
							 .rstb_b(rstb_domain_b),
							 .enable(enable),
							 .out_val(out_val));

	
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
		{clk_domain_b, clk_domain_a, rstb_domain_a, rstb_domain_b, enable} = 1'b0;
		#12ns;
		
		@ (posedge clk_domain_a)
			rstb_domain_a = 1'b1;
		
		@ (posedge clk_domain_b)
			rstb_domain_b = 1'b1;
		#50ns;
		
		@ (posedge clk_domain_a)
			enable = 1'b1;
		
		#120ns;
		enable = 1'b0;
	end
endmodule
