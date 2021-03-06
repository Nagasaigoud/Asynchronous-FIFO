`timescale 1ns / 1ps

module transmitter_data(wr_ptr,data_out);
	output [7:0] data_out;
	input [7:0] wr_ptr;
	reg [7:0] input_rom [255:0];
	integer i;
	initial begin

	for(i=0;i<256;i=i+1)
		input_rom[i] = i;
	end

	assign data_out = input_rom[wr_ptr];

//transmitter_data td(tr_ptr,data_in);
endmodule
