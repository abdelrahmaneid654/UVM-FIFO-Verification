package fifo_agent;
import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_driver::*;
import fifo_monitor::*;
import fifo_sequencer::*;
import Myseq_item::*;
import fifo_config::*;

class fifo_agent extends uvm_agent;
  `uvm_component_utils(fifo_agent)
  fifo_sequencer agt_sqr;
  fifo_driver agt_drv;
  fifo_monitor agt_mon;
  fifo_config agt_cfg;
  uvm_analysis_port#(Myseq_item) agt_ap;

  function new(string name="agent",uvm_component parent);
      super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase );
    super.build_phase(phase);
    agt_sqr=fifo_sequencer::type_id::create("agt_sqr",this);
    agt_drv=fifo_driver::type_id::create("agt_drv",this);
    agt_mon=fifo_monitor::type_id::create("agt_mon",this);
    agt_ap=new("agt_ap",this);

    if(!uvm_config_db#(fifo_config):: get(this,"","SCF",agt_cfg))
          `uvm_fatal("build_phase"," unable to get the config object");
  endfunction

  function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      agt_drv.seq_item_port.connect(agt_sqr.seq_item_export);
      agt_drv.vif=agt_cfg.vif;
      agt_mon.vif=agt_cfg.vif;
      agt_mon.mon_ap.connect(agt_ap);
  endfunction
endclass
endpackage