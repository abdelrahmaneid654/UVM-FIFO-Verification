package fifo_driver;
import uvm_pkg::*;
`include "uvm_macros.svh"
import Myseq_item::*;

class fifo_driver extends uvm_driver #(Myseq_item);
    `uvm_component_utils(fifo_driver)
    virtual fifo_if vif;
    Myseq_item seq_item;

    function new(string name="fifo_driver", uvm_component parent);
      super.new(name,parent);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        
        forever begin
          seq_item_port.get_next_item(seq_item);
          
          vif.rst_n   = seq_item.rst_n;
          vif.wr_en   = seq_item.wr_en;
          vif.rd_en   = seq_item.rd_en;
          vif.data_in = seq_item.data_in;

          @(negedge vif.clk);
          seq_item_port.item_done();   
        end
    endtask

endclass
endpackage