package fifo_coverage;
import uvm_pkg::*;
`include "uvm_macros.svh";
import Myseq_item::*;

class fifo_coverage extends uvm_component;
`uvm_component_utils(fifo_coverage);
uvm_analysis_export#(Myseq_item) cvg_ae;
uvm_tlm_analysis_fifo#(Myseq_item) cvg_fifo;
Myseq_item cvg_seq_item;

covergroup cvr_gp;

    cp_wr_en     : coverpoint cvg_seq_item.wr_en;
    cp_rd_en     : coverpoint cvg_seq_item.rd_en;
    cp_full      : coverpoint cvg_seq_item.full;
    cp_almostfull: coverpoint cvg_seq_item.almostfull;
    cp_empty     : coverpoint cvg_seq_item.empty;
    cp_almostempty: coverpoint cvg_seq_item.almostempty;
    cp_overflow  : coverpoint cvg_seq_item.overflow;
    cp_underflow : coverpoint cvg_seq_item.underflow;
    cp_wr_ack    : coverpoint cvg_seq_item.wr_ack;

    full: cross cp_wr_en, cp_rd_en, cp_full {
        ignore_bins ign_full = binsof(cp_full) intersect {1} && binsof(cp_rd_en) intersect {1};
    }

    almostfull: cross cp_wr_en, cp_rd_en, cp_almostfull;

    

    almostempty: cross cp_wr_en, cp_rd_en, cp_almostempty;

    overflow: cross cp_wr_en, cp_rd_en, cp_overflow {
        ignore_bins ign_ovf1 = binsof(cp_overflow) intersect {1} && binsof(cp_rd_en) intersect {1};
        ignore_bins ign_ovf2 = binsof(cp_overflow) intersect {1} && binsof(cp_wr_en) intersect {0};
    }

    underflow: cross cp_wr_en, cp_rd_en, cp_underflow {
        ignore_bins ign_unf1 = binsof(cp_underflow) intersect {1} && binsof(cp_rd_en) intersect {0};
        ignore_bins ign_unf2 = binsof(cp_underflow) intersect {1} && binsof(cp_wr_en) intersect {1};
    }

    wr_ack: cross cp_wr_en, cp_rd_en, cp_wr_ack {
        ignore_bins ign_ack = binsof(cp_wr_ack) intersect {1} && binsof(cp_wr_en) intersect {0};
    }

endgroup

function new(string name="fifo coverage",uvm_component parent);
    super.new(name,parent);
    cvr_gp=new();
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
cvg_ae=new("cvg_ae",this);
cvg_fifo=new("cvg_fifo",this);
    
endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
cvg_ae.connect(cvg_fifo.analysis_export);
    
endfunction
task run_phase(uvm_phase phase);
forever begin
cvg_fifo.get(cvg_seq_item);
cvr_gp.sample();
end
endtask


endclass
    
endpackage