package fifo_sequencer;
import uvm_pkg::*;
`include "uvm_macros.svh"
import Myseq_item::*;

class fifo_sequencer extends uvm_sequencer#(Myseq_item);
  `uvm_component_utils(fifo_sequencer)

  function new(string name="sqr",uvm_component parent);
      super.new(name,parent);
  endfunction
endclass
endpackage