package fifo_test;
import uvm_pkg::*;
`include "uvm_macros.svh"

import fifo_env::*;
import fifo_config::*;
import write_only_seq::*;
import write_read_seq::*;
import read_only_seq::*;
import rst_seq::*;



class fifo_test extends uvm_test;
  `uvm_component_utils(fifo_test)

  function new(string name,uvm_component parent);
    super.new (name,parent);
  endfunction

  fifo_env tst_env;
  fifo_config tst_config;
  write_only_seq write_seq; 
  read_only_seq read_seq; 
  write_read_seq w_r_seq; 
  rst_seq r_seq;

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tst_env = fifo_env::type_id::create("tst_env",this);
     write_seq   = write_only_seq::type_id::create("write_seq",this);
     read_seq   = read_only_seq::type_id::create("read_seq",this);
     w_r_seq   = write_read_seq::type_id::create("write_read_seq",this);
     r_seq   = rst_seq::type_id::create("r_seq",this);



    tst_config = fifo_config::type_id::create("fifo_config");
    
    if(!uvm_config_db#(virtual fifo_if)::get(this,"","fifo_if",tst_config.vif))
      `uvm_fatal("build_phase","Test unable to get the virtual interface");

    uvm_config_db#(fifo_config)::set(this,"*","SCF",tst_config);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    phase.raise_objection(this);
    
    `uvm_info("run phase","Reset asserted ",UVM_LOW);
    r_seq.start(tst_env.env_agt.agt_sqr);
    `uvm_info("run phase","Reset Deasserted ",UVM_LOW);

    `uvm_info("run phase","Write sequence Started ",UVM_LOW);
    write_seq.start(tst_env.env_agt.agt_sqr);
    `uvm_info("run phase","Write sequence Finished ",UVM_LOW);

    `uvm_info("run phase","read sequence Started ",UVM_LOW);
    read_seq.start(tst_env.env_agt.agt_sqr);
    `uvm_info("run phase","read sequence Finished ",UVM_LOW);

    `uvm_info("run phase","Write&read sequence Started ",UVM_LOW);
    w_r_seq.start(tst_env.env_agt.agt_sqr);
    `uvm_info("run phase","Write&read sequence Finished ",UVM_LOW);

    phase.drop_objection(this);
  endtask

endclass: fifo_test
endpackage