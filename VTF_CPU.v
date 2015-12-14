`timescale 1ns / 1ps

module VTF_CPU;

	// Inputs
	reg clk;
	reg enable;
	reg reset;
	reg [3:0] SW;
	reg start;
	reg button;

	// Outputs
	wire [6:0] light;
	wire [3:0] en;

	// Instantiate the Unit Under Test (UUT)
	CPU uut (
		.clk(clk), 
		.enable(enable), 
		.reset(reset), 
		.SW(SW), 
		.start(start), 
		.button(button), 
		.light(light), 
		.en(en)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		enable = 0;
		reset = 0;
		SW = 0;
		start = 0;
		button = 0;

		// Wait 100 ns for global reset to finish
		#100;
		
		// Test by me
		/*$display("pc :     id_ir      :reg_A:reg_B:reg_C:da:dd  :w:reC1:gr1 :gr2 : gr3: dm0: dm1: dm2");
		$monitor("%d:%b:%h :%h :%h :%h:%h:%b:%h:%h:%h:%h:%h:%h:%h", 
			uut.pcpu.pc, uut.pcpu.id_ir, uut.pcpu.reg_A, uut.pcpu.reg_B, uut.pcpu.reg_C,
			uut.d_addr, uut.d_dataout, uut.d_we, uut.pcpu.reg_C1, uut.pcpu.gr[1], uut.pcpu.gr[2], uut.pcpu.gr[3],
			uut.d_mem.d_mem[0], uut.d_mem.d_mem[1], uut.d_mem.d_mem[2]);*/
		// Bubble Test
		$display("pc :     id_ir      :reg_A:reg_B:reg_C:da:dd  :w:reC1:gr1 :gr2 : gr3: dm0: dm1: dm2: dm3: dm4: dm5: dm6: dm7: dm8: dm9: dm10");
		$monitor("%d:%b:%h :%h :%h :%h:%h:%b:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h", 
			uut.pcpu.pc, uut.pcpu.id_ir, uut.pcpu.reg_A, uut.pcpu.reg_B, uut.pcpu.reg_C,
			uut.d_addr, uut.d_dataout, uut.d_we, uut.pcpu.reg_C1, uut.pcpu.gr[1], uut.pcpu.gr[2], uut.pcpu.gr[3],
			uut.d_mem.d_mem[0], uut.d_mem.d_mem[1], uut.d_mem.d_mem[2], uut.d_mem.d_mem[3], uut.d_mem.d_mem[4], uut.d_mem.d_mem[5],
			uut.d_mem.d_mem[6], uut.d_mem.d_mem[7], uut.d_mem.d_mem[8], uut.d_mem.d_mem[9], uut.d_mem.d_mem[10]);
			
      enable <= 0; start <= 0;
		// Add stimulus here
		#10 reset <= 1;
		#10 reset <= 0;
		#10 enable <= 1;
		#10 start <=1;
		//#10 start <= 0;
		//Test Need 100.00us
		#100000 $display("After Computing");
					$display("dm0 = %h", uut.d_mem.d_mem[0]);
					$display("dm1 = %h", uut.d_mem.d_mem[1]);
					$display("dm2 = %h", uut.d_mem.d_mem[2]);
					$display("dm3 = %h", uut.d_mem.d_mem[3]);
					$display("dm4 = %h", uut.d_mem.d_mem[4]);
					$display("dm5 = %h", uut.d_mem.d_mem[5]);
					$display("dm6 = %h", uut.d_mem.d_mem[6]);
					$display("dm7 = %h", uut.d_mem.d_mem[7]);
					$display("dm8 = %h", uut.d_mem.d_mem[8]);
					$display("dm9 = %h", uut.d_mem.d_mem[9]);
					$display("dm10 = %h", uut.d_mem.d_mem[10]);
					$display("dm11 = %h", uut.d_mem.d_mem[11]);
	
	end
   always #20 button = ~button;
	always #5 clk = ~clk;
endmodule

