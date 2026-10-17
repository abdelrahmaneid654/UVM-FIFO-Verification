package fifo_monitor;
import uvm_pkg::*;
`include "uvm_macros.svh"
import Myseq_item::*;

class fifo_monitor extends uvm_monitor;
  `uvm_component_utils(fifo_monitor)

  virtual fifo_if vif;
  Myseq_item rsp_seq_item;
  uvm_analysis_port#(Myseq_item) mon_ap;

  function new(string name="monitor",uvm_component parent);
      super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      mon_ap=new("mon_ap",this);  
  endfunction

  task run_phase(uvm_phase phase);  
    super.run_phase(phase);
    forever begin
      rsp_seq_item = Myseq_item::type_id::create("rsp_seq_item");
      
      @(negedge vif.clk);
      
      rsp_seq_item.rst_n   = vif.rst_n;
      rsp_seq_item.wr_en   = vif.wr_en;
      rsp_seq_item.rd_en   = vif.rd_en;
      rsp_seq_item.data_in = vif.data_in;

      rsp_seq_item.data_out    = vif.data_out;
      rsp_seq_item.wr_ack      = vif.wr_ack;
      rsp_seq_item.overflow    = vif.overflow;
      rsp_seq_item.full        = vif.full;
      rsp_seq_item.empty       = vif.empty;
      rsp_seq_item.almostfull  = vif.almostfull;
      rsp_seq_item.almostempty = vif.almostempty;
      rsp_seq_item.underflow   = vif.underflow;
      
      mon_ap.write(rsp_seq_item);
    end
  endtask
endclass
endpackage