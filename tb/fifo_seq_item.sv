package Myseq_item;
import uvm_pkg::*;
`include "uvm_macros.svh";

parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
class Myseq_item extends uvm_sequence_item;
`uvm_object_utils(Myseq_item);

rand logic [FIFO_WIDTH-1:0] data_in;
rand logic  rst_n, wr_en, rd_en;
 logic  [FIFO_WIDTH-1:0] data_out;
 logic  wr_ack, overflow;
 logic full, empty, almostfull, almostempty, underflow;


  function new(string name="seq_item");
    super.new(name);
  endfunction

constraint c1{
    rst_n dist {1:=98 , 0:=2};
}

function string convert2string();
  return $sformatf("rst_n=%0b wr_en=%0b rd_en=%0b data_in=0x%0h | data_out=0x%0h wr_ack=%0b overflow=%0b full=%0b empty=%0b almostfull=%0b almostempty=%0b underflow=%0b", 
                   rst_n, wr_en, rd_en, data_in, data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow);
endfunction 
endclass
endpackage