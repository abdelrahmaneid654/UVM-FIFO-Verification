package write_read_seq;
 import uvm_pkg::*;
`include "uvm_macros.svh"
 import Myseq_item::*;
class write_read_seq extends uvm_sequence#(Myseq_item);

`uvm_object_utils(write_read_seq);
function new(string name="write_read_seq");
    super.new(name);
endfunction
Myseq_item seq_item;

task body();
    seq_item=Myseq_item::type_id::create("seq_item");
    repeat(500)begin
        start_item(seq_item);
        assert(seq_item.randomize() with 
        {
            seq_item.wr_en dist{1:=70 , 0:=30};
            seq_item.rd_en  dist{1:=50 , 0:=50 };

        
         });
        finish_item(seq_item);
    end
endtask
endclass
endpackage
