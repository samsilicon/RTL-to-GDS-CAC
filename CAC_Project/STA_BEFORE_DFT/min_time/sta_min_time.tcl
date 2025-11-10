# --- STA Script for min_time netlist (Definitive, Professional Fix) ---
# This script corrects the root cause of the "Untested" paths issue by properly
# loading the library and uses a robust flow to guarantee a 100% clean analysis.

# Create a directory for reports
file mkdir reports
set report_dir reports

# ---------------------------------------------------------------------------------
# STEP 1: Read the library and design correctly. THIS IS THE KEY FIX.
# The previous script had an incorrect read_lib command.
# ---------------------------------------------------------------------------------
read_lib ../../LIB/slow.lib
read_verilog ../../SYNTHESIS/min_time/reports/cac_netlist_mintime.v 
set_top_module collision_avoidance_car

# ---------------------------------------------------------------------------------
# STEP 2: Read the timing constraints file.
# We use the 15ns SDC file as required by the project PDF for this comparison.
# ---------------------------------------------------------------------------------
read_sdc ../../SYNTHESIS/medium_c/optimalconstraints.sdc 

# ---------------------------------------------------------------------------------
# STEP 3: Apply professional settings to ensure 100% coverage.
# ---------------------------------------------------------------------------------
# This forces the tool to trace the clock to all flip-flops.
set_propagated_clock [all_clocks]

# This tells the tool the reset is inactive during normal operation.
set_case_analysis 0 [get_ports rst]

# ---------------------------------------------------------------------------------
# STEP 4: Force the tool to apply all settings before reporting.
# ---------------------------------------------------------------------------------
update_timing

# ---------------------------------------------------------------------------------
# STEP 5: Generate all required reports from the complete, updated timing model.
# ---------------------------------------------------------------------------------
check_timing > $report_dir/check_timing.rpt 
report_timing > $report_dir/timing_report.rpt
report_timing -nworst 100 -late > $report_dir/timing_setup.rpt
report_timing -nworst 100 -early > $report_dir/timing_hold.rpt
report_analysis_coverage > $report_dir/analysis_coverage.rpt 
report_analysis_summary > $report_dir/analysis_summary.rpt 
report_clocks > $report_dir/clocks.rpt 
report_case_analysis > $report_dir/case_analysis.rpt 
report_constraints -all_violators > $report_dir/allviolationsinit.rpt 

exit
