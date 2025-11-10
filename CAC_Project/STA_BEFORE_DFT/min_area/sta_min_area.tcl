# --- STA Script for min_area netlist (Definitive, Professional Fix) ---
# This script corrects the root cause of the "Untested" paths issue by fixing
# the order of operations, ensuring the library is read before the constraints.

# Create a directory for reports
file mkdir reports
set report_dir reports

# ---------------------------------------------------------------------------------
# STEP 1: Read the Technology Library FIRST. This is the critical fix.
# The tool needs the library's timing rules before it can interpret the SDC file.
# ---------------------------------------------------------------------------------
read_lib ../../LIB/slow.lib

# ---------------------------------------------------------------------------------
# STEP 2: Read the synthesized design (netlist).
# ---------------------------------------------------------------------------------
read_verilog ../../SYNTHESIS/min_area/reports/cac_netlist_minarea.v 
set_top_module collision_avoidance_car

# ---------------------------------------------------------------------------------
# STEP 3: Now, read the timing constraints file.
# The tool can now correctly create all checks (PulseWidth, etc.).
# ---------------------------------------------------------------------------------
read_sdc ../../SYNTHESIS/medium_c/optimalconstraints.sdc 

# ---------------------------------------------------------------------------------
# STEP 4: Apply professional settings to ensure 100% coverage.
# These commands will now work because the checks exist.
# ---------------------------------------------------------------------------------
set_propagated_clock [all_clocks]
set_case_analysis 0 [get_ports rst]

# ---------------------------------------------------------------------------------
# STEP 5: Force the tool to apply all settings before reporting.
# ---------------------------------------------------------------------------------
update_timing

# ---------------------------------------------------------------------------------
# STEP 6: Generate all required reports from the complete, updated timing model.
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
