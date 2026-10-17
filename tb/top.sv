
import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_test::*;
module top();

  bit clk;
  always #2 clk = ~clk;

  fifo_if f_if (clk);
  

FIFO DUT (f_if); 
  
`ifdef SIM
    bind FIFO fifo_sva fifo_assertions (f_if); 
  `endif
  
   initial begin
    uvm_config_db#(virtual fifo_if)::set(null,"uvm_test_top","fifo_if",f_if);
  run_test("fifo_test");
  end


endmodule