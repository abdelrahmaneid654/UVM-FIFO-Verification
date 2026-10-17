package fifo_sb;
import uvm_pkg::*;
`include "uvm_macros.svh";
import Myseq_item::*;

class fifo_scoreboard extends uvm_scoreboard;
`uvm_component_utils(fifo_scoreboard);

uvm_analysis_export#(Myseq_item) sb_ae;
Myseq_item seq_item;
uvm_tlm_analysis_fifo#(Myseq_item)sb_fifo;
int correct_count=0;
int error_count=0;

reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];
int count=0; 
int wr_ptr=0,rd_ptr=0;
logic   empty_ref, full_ref;
logic  [FIFO_WIDTH-1:0] data_out_ref;


function new(string name="scoreboard",uvm_component parent);
    super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_fifo=new("fifo",this);
    sb_ae=new("sb_ae",this);
endfunction


function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    sb_ae.connect(sb_fifo.analysis_export);
endfunction


task run_phase(uvm_phase phase);
    super.run_phase(phase);

    
forever begin
    sb_fifo.get(seq_item);

    ref_model(seq_item);

    if(seq_item.data_out !== data_out_ref ) begin
        `uvm_error("run_phase",$sformatf("comparison failed , Transaction recieved by the DUT :%s while the refrence out =%0b",seq_item.convert2string(),data_out_ref));
        error_count++;
    end
    else begin
    `uvm_info("run_phase",$sformatf("correct out : %s",seq_item.convert2string()),UVM_HIGH);
    correct_count++;
    end
end
endtask

task ref_model(Myseq_item seq_item);
  if(!seq_item.rst_n) begin
            empty_ref=1;
            full_ref=0 ; 
            data_out_ref=0;
            count=0;
            wr_ptr=0;
            rd_ptr=0;
        end
        else begin
            //empty
            if(count==0)
            empty_ref=1;
            else
            empty_ref=0;
            //full
            if(count==FIFO_DEPTH)
                full_ref=1;
            else
                full_ref=0;

            //write
            if(!full_ref && seq_item.wr_en ) begin
            mem [wr_ptr] =seq_item.data_in;
            count++;
            wr_ptr= (wr_ptr+1) % (FIFO_DEPTH);
            end   
            //read
             if(!empty_ref && seq_item.rd_en) begin
                count--;
                data_out_ref=mem[rd_ptr];
                rd_ptr= (rd_ptr+1) % (FIFO_DEPTH);

            end

        end
    endtask

function void report_phase(uvm_phase phase);
     super.report_phase(phase);
     `uvm_info("report phase",$sformatf("Total Successful Transactions :%0d",correct_count),UVM_MEDIUM);
     `uvm_info("report phase",$sformatf("Total Failed Transactions :%0d",error_count),UVM_MEDIUM);
endfunction

endclass
endpackage