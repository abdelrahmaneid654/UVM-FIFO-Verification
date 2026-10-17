////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
// Description: FIFO Design 
////////////////////////////////////////////////////////////////////////////////
module FIFO(fifo_if f_if);

localparam max_fifo_addr = $clog2(f_if.FIFO_DEPTH);

reg [f_if.FIFO_WIDTH-1:0] mem [f_if.FIFO_DEPTH-1:0];

logic [max_fifo_addr-1:0] wr_ptr, rd_ptr;
logic [max_fifo_addr:0] count;
assign f_if.count=count;
assign f_if.wr_ptr=wr_ptr;
assign f_if.rd_ptr=rd_ptr;

always @(posedge f_if.clk or negedge f_if.rst_n) begin
	if (!f_if.rst_n) begin
		wr_ptr <= 0;
		f_if.wr_ack <=0; // modified
		f_if.overflow <=0; // modified
	end
	else if (f_if.wr_en && count < f_if.FIFO_DEPTH) begin
		mem[wr_ptr] <= f_if.data_in;
		f_if.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		f_if.overflow <=0; // modified


	end
	else begin 
		f_if.wr_ack <= 0; 
		if (f_if.full & f_if.wr_en ) 
			f_if.overflow <= 1;
		else
			f_if.overflow <= 0;
	end
end

always @(posedge f_if.clk or negedge f_if.rst_n) begin
	if (!f_if.rst_n) begin
		rd_ptr <= 0;
		f_if.underflow<=0; //modified
		f_if.data_out<=0;  //modified
	end
	else if (f_if.rd_en && count != 0) begin
		f_if.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		f_if.underflow<=0; //modified

	end
	else if(f_if.rd_en && count == 0) 
		f_if.underflow<=1;
	
	else
			f_if.underflow<=0; //modified
end

always @(posedge f_if.clk or negedge f_if.rst_n) begin
	if (!f_if.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({f_if.wr_en, f_if.rd_en} == 2'b10) && !f_if.full) 
			count <= count + 1;
		else if ( ({f_if.wr_en, f_if.rd_en} == 2'b01) && !f_if.empty)
			count <= count - 1;
		else if ( ({f_if.wr_en, f_if.rd_en} == 2'b11) && f_if.empty) //added
			count <= count + 1;

		else if ( ({f_if.wr_en, f_if.rd_en} == 2'b11) && f_if.full) // added
			count <= count - 1;

	end
end

assign f_if.full = (count == f_if.FIFO_DEPTH)? 1 : 0;
assign f_if.empty = (count == 0)? 1 : 0;
assign f_if.almostfull = (count == f_if.FIFO_DEPTH-1)? 1 : 0; // modified
assign f_if.almostempty = (count == 1)? 1 : 0;

endmodule