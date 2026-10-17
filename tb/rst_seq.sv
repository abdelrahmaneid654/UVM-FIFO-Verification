package rst_seq;
 import uvm_pkg::*;
`include "uvm_macros.svh"
 import Myseq_item::*;
class rst_seq extends uvm_sequence#(Myseq_item);

`uvm_object_utils(rst_seq);
function new(string name="rst seq");
    super.new(name);
endfunction
Myseq_item seq_item;

task body();
    seq_item=Myseq_item::type_id::create("seq_item");
    repeat(1)begin
        start_item(seq_item);
        assert(seq_item.randomize() with 
        {
            seq_item.rst_n==0;

         });
        finish_item(seq_item);
    end
endtask
endclass
endpackage
