`timescale 1ns / 1ps
`include"headfile.v"

module D_mem(
	input mem_clk,
	input dwe,
	input [7:0] addr,
	input [15:0] wdata,
	output wire [15:0] rdata
    );
	
	reg [15:0] d_mem [255:0];
	assign rdata = d_mem[addr];
	
	always@(posedge mem_clk)
	begin
			if(dwe)
				d_mem[addr] <= wdata;
	end

	//Test by me
	/*initial begin//初始化时全为0
		d_mem[0] = 16'b0000000000000000;
		d_mem[1] = 16'b0000000000000000;
		d_mem[2] = 16'b0000000000000000;
		d_mem[3] = 16'b0000000000000000;
		d_mem[4] = 16'b0000000000000000;
		d_mem[5] = 16'b0000000000000000;
		d_mem[6] = 16'b0000000000000000;
		d_mem[7] = 16'b0000000000000000;
		d_mem[8] = 16'b0000000000000000;
		d_mem[9] = 16'b0000000000000000;
		d_mem[10] = 16'b0000000000000000;
		d_mem[11] = 16'b0000000000000000;
		d_mem[12] = 16'b0000000000000000;
		d_mem[13] = 16'b0000000000000000;
		d_mem[14] = 16'b0000000000000000;
		d_mem[15] = 16'b0000000000000000;
		d_mem[16] = 16'b0000000000000000;
		d_mem[17] = 16'b0000000000000000;
		d_mem[18] = 16'b0000000000000000;
		d_mem[19] = 16'b0000000000000000;
	end*/
	
	// Bubble Test
	/*initial begin
		d_mem[0] = 16'h000a;
		d_mem[1] = 16'h0004;
		d_mem[2] = 16'h0005;
		d_mem[3] = 16'h2369;
		d_mem[4] = 16'h69c3;
		d_mem[5] = 16'h0060;
		d_mem[6] = 16'h0fff;
		d_mem[7] = 16'h5555;
		d_mem[8] = 16'h6152;
		d_mem[9] = 16'h1057;
		d_mem[10] = 16'h2895;
	end*/
	
	// GCD Test
	/*initial begin
		d_mem[0] = 16'h0000;
		d_mem[1] = 16'h0020;
		d_mem[2] = 16'h0018;
		d_mem[3] = 16'h0000;
		d_mem[4] = 16'h0000;
		d_mem[5] = 16'h0000;
		d_mem[6] = 16'h0000;
		d_mem[7] = 16'h0000;
		d_mem[8] = 16'h0000;
		d_mem[9] = 16'h0000;
		d_mem[10] = 16'h0000;
	end*/
	
	// Sort Test
	/*initial begin
		d_mem[0] = 16'h000a;
		d_mem[1] = 16'h0009;
		d_mem[2] = 16'h0006;
		d_mem[3] = 16'h0005;
		d_mem[4] = 16'h0001;
		d_mem[5] = 16'h0004;
		d_mem[6] = 16'h0003;
		d_mem[7] = 16'h0011;
		d_mem[8] = 16'h0000;
		d_mem[9] = 16'h0000;
		d_mem[10] = 16'h0000;
	end*/
	
	// ADD64 Test
	initial begin
		d_mem[0] <= 16'hfffe;
		d_mem[1] <= 16'hfffe;
		d_mem[2] <= 16'hfffe;
		d_mem[3] <= 16'h0000;
		d_mem[4] <= 16'hffff;
		d_mem[5] <= 16'hffff;
		d_mem[6] <= 16'hffff;
		d_mem[7] <= 16'h0000;
		d_mem[8] = 16'h0000;
		d_mem[9] = 16'h0000;
		d_mem[10] = 16'h0000;
	end
	
	// Test All
	/*initial begin
		d_mem[0] <= 16'hfffd;
		d_mem[1] <= 16'h0004;
		d_mem[2] <= 16'h0005;
		d_mem[3] <= 16'hc369;
		d_mem[4] <= 16'h69c3;
		d_mem[5] <= 16'h0041;
		d_mem[6] <= 16'hffff;
		d_mem[7] <= 16'h0001;
	end*/

endmodule
