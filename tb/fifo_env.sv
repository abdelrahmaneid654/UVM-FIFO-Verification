package fifo_env;
import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_agent::*;
import fifo_sb::*;
import fifo_coverage::*;

class fifo_env extends uvm_env;
  `uvm_component_utils(fifo_env)
  
  fifo_scoreboard env_sb;
  fifo_agent env_agt;
  fifo_coverage env_cvg;

  function new(string name = "fifo_env", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env_sb=fifo_scoreboard::type_id::create("score_board",this);
    env_agt=fifo_agent::type_id::create("agent",this);
    env_cvg=fifo_coverage::type_id::create("env_cvg",this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    env_agt.agt_ap.connect(env_sb.sb_ae);
    env_agt.agt_ap.connect(env_cvg.cvg_ae);
  endfunction
endclass
endpackage