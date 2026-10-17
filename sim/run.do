vlib work

vlog ../RTL/FIFO.sv ../RTL/fifo_if.sv +cover=sbt -covercells 
vlog -f src_files.f +define+SIM
vsim -voptargs=+acc work.top -cover

add wave -position insertpoint sim:/top/f_if/*

run -all

coverage save fifo.ucdb -du FIFO -du fifo_sva -du fifo_coverage -du fifo_if
vcover report fifo.ucdb -details -annotate -all -output ../reports/coverage_rpt_fifo.txt