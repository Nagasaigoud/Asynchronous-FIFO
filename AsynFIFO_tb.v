`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:30:15 07/24/2021
// Design Name:   AsynFIFO
// Module Name:   E:/Placements/Project/AsynFIFO/AsynFIFO_tb.v
// Project Name:  AsynFIFO
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: AsynFIFO
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module AsynFIFO_tb;

	// Inputs
	reg rd_clk;
	reg wr_clk;
	reg reset;

	// Outputs
	wire [7:0] data_out;
	wire wr_full;
	wire rd_empty;

	// Instantiate the Unit Under Test (UUT)
	AsynFIFO uut (
		.data_out(data_out), 
		.wr_full(wr_full), 
		.rd_empty(rd_empty), 
		.rd_clk(rd_clk), 
		.wr_clk(wr_clk), 
		.reset(reset)
	);

	initial begin
		// Initialize Inputs
		reset = 1;

		wr_clk = 0;
		rd_clk=0;
		#2 reset = 0;
		// Wait 100 ns for global reset to finish
		  
		// Add stimulus here

	end
	always 
	begin
		#25 rd_clk = ~ rd_clk;
	end
 	always
	begin
		#2.5 wr_clk = ~ wr_clk;
	end  

  

   
endmodule

