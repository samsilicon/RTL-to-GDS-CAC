// Conformal LEC Script for Failure Analysis

set log file lec_fail_cec.log -replace
read library -verilog ../../LIB/slow.v -both

// Golden design is the original, correct RTL
read design -verilog ../../RTL/cac.v -golden

// Revised design is our manually broken netlist
read design ./bad_netlist_3.v -verilog -revised

// This command is still needed for the golden design
set flatten model -seq_constant -golden

set system mode lec
add compared points -all
compare
report verification


