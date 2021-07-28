`timescale 1ns / 1ps


module AsynFIFO(data_out, wr_full, rd_empty,rd_clk, wr_clk, reset);

	parameter WIDTH = 8;
	parameter POINTER = 4;
	output [WIDTH-1 : 0] data_out;
	output wr_full;
	output rd_empty;
	wire [WIDTH-1 : 0] data_in;
	input rd_clk, wr_clk;
	input reset;
 
	reg [POINTER : 0] rd_pointer, rd_sync_1, rd_sync_2;
	reg [POINTER : 0] wr_pointer, wr_sync_1, wr_sync_2;
	wire [POINTER:0] rd_pointer_g,wr_pointer_g;

	parameter DEPTH = 1 << POINTER;	

	reg [WIDTH-1 : 0] mem [DEPTH-1 : 0];

	wire [POINTER : 0] rd_pointer_sync;
	wire [POINTER: 0] wr_pointer_sync;
	reg full,empty;
	reg [7:0] tr_ptr;
	
	//--write logic--//
	
	always @(posedge wr_clk or posedge reset) begin
		if (reset) begin
			wr_pointer <= 0;
			tr_ptr<=0;
		end
		else if (full == 1'b0) begin
			wr_pointer <= wr_pointer + 1;
			tr_ptr<=tr_ptr+1;
			mem[wr_pointer[POINTER-1 : 0]] <= data_in;
		end
	end

	transmitter_data td(tr_ptr,data_in);

	//--read pointer synchronizer controled by write clock--//

	always @(posedge wr_clk) begin
		rd_sync_1 <= rd_pointer_g;
		rd_sync_2 <= rd_sync_1;
	end
	
	//--read logic--//
	
	always @(posedge rd_clk or posedge reset) begin
		if (reset) begin
			rd_pointer <= 0;
		end
		else if (empty == 1'b0) begin
			rd_pointer <= rd_pointer + 1;
		end
	end

	//--write pointer synchronizer controled by read clock--//

	always @(posedge rd_clk) begin
		wr_sync_1 <= wr_pointer_g;
		wr_sync_2 <= wr_sync_1;
	end


	always @(*)
	begin
		if({~wr_pointer[POINTER],wr_pointer[POINTER-1:0]}==rd_pointer_sync)
			full = 1;
		else
			full = 0;	
	end



	always @(*)
	begin
		if(wr_pointer_sync==rd_pointer)	 
			empty = 1;	
		else
			empty = 0;
	end

	assign data_out = mem[rd_pointer[POINTER-1 : 0]];



	assign wr_pointer_g = wr_pointer ^ (wr_pointer >> 1);
	assign rd_pointer_g = rd_pointer ^ (rd_pointer >> 1);

	gray_to_binary g2bwrite(wr_sync_2,wr_pointer_sync);
	gray_to_binary g2bread(rd_sync_2,rd_pointer_sync);

	assign wr_full = full;
	assign rd_empty = empty;

endmodule 
