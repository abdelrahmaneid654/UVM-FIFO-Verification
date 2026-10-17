`ifdef SIM
import Myseq_item::*;
module fifo_sva(fifo_if f_if);
always_comb begin 

	if(!f_if.rst_n)
	reset :assert final (f_if.count == 0 && f_if.wr_ptr==0 && f_if.rd_ptr ==0 && f_if.data_out == 0 && f_if.wr_ack == 0 && f_if.overflow == 0 && f_if.underflow == 0 &&
f_if.empty == 1 && f_if.full == 0 && f_if.almostfull == 0 && f_if.almostempty == 0);
	
end


property data_out_stable;
  @(posedge f_if.clk) disable iff (!f_if.rst_n)
  !(f_if.rd_en && !f_if.empty) |=> $stable(f_if.data_out);
endproperty

property Write_Acknowledge;
    @(posedge f_if.clk) disable iff (!f_if.rst_n) (f_if.wr_en && !f_if.full) |=> f_if.wr_ack;
endproperty

property Overflow_Detection;
    @(posedge f_if.clk) disable iff (!f_if.rst_n) (f_if.wr_en && f_if.full  ) |=> f_if.overflow;
endproperty

property Underflow_Detection;
    @(posedge f_if.clk) disable iff (!f_if.rst_n) (f_if.rd_en && f_if.empty ) |=> f_if.underflow;
endproperty 

property Empty_Flag;
    @(posedge f_if.clk) disable iff (!f_if.rst_n) (f_if.count == 0) |-> f_if.empty;
endproperty

property Full_Flag;
    @(posedge f_if.clk) disable iff (!f_if.rst_n) (f_if.count == f_if.FIFO_DEPTH) |-> f_if.full;
endproperty

property Almost_Full;
    @(posedge f_if.clk) disable iff (!f_if.rst_n) (f_if.count == f_if.FIFO_DEPTH-1) |-> f_if.almostfull;
endproperty

property Almost_Empty;
    @(posedge f_if.clk) disable iff (!f_if.rst_n) (f_if.count == 1) |-> f_if.almostempty;
endproperty

property Wraparound_write;
    @(posedge f_if.clk) disable iff (!f_if.rst_n) ((f_if.wr_ptr == f_if.FIFO_DEPTH-1) && f_if.wr_en && !f_if.full) |=> !f_if.wr_ptr;
endproperty

property Wraparound_read;
    @(posedge f_if.clk) disable iff (!f_if.rst_n) ((f_if.rd_ptr == f_if.FIFO_DEPTH-1) && f_if.rd_en && !f_if.empty) |=> !f_if.rd_ptr;
endproperty

property Pointer_threshold;
    @(posedge f_if.clk) disable iff (!f_if.rst_n) (f_if.rd_ptr < f_if.FIFO_DEPTH && f_if.wr_ptr < f_if.FIFO_DEPTH && f_if.count <= f_if.FIFO_DEPTH);
endproperty
assert property (Write_Acknowledge);
cover property (Write_Acknowledge);

assert property (data_out_stable);
cover property (data_out_stable);

assert property (Overflow_Detection);
cover property (Overflow_Detection);

assert property (Underflow_Detection);
cover property (Underflow_Detection);

assert property (Empty_Flag);
cover property (Empty_Flag);

assert property (Full_Flag);
cover property (Full_Flag);

assert property (Almost_Full);
cover property (Almost_Full);

assert property (Almost_Empty);
cover property (Almost_Empty);

assert property (Wraparound_write);
cover property (Wraparound_write);

assert property (Wraparound_read);
cover property (Wraparound_read);

assert property (Pointer_threshold);
cover property (Pointer_threshold);
endmodule
`endif