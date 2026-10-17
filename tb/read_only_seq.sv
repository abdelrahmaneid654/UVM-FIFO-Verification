
package read_only_seq;
 import uvm_pkg::*;
`include "uvm_macros.svh"
 import Myseq_item::*;

class read_only_seq extends uvm_sequence#(Myseq_item);

`uvm_object_utils(read_only_seq);
function new(string name="read only seq");
    super.new(name);
endfunction
Myseq_item seq_item;

task body();
    seq_item=Myseq_item::type_id::create("seq_item");
    repeat(20)begin
        start_item(seq_item);
        assert(seq_item.randomize() with 
        {
            seq_item.wr_en==0;
            seq_item.rd_en==1;
         });
        finish_item(seq_item);
    end
endtask
endclass
endpackage

