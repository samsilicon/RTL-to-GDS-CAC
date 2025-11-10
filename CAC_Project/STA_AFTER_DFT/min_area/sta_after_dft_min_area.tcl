# --- STA Script for min_area SCAN-INSERTED netlist (Definitive, Professional Fix) ---
# This script uses our proven, corrected template to provide a complete and
# professional analysis of the post-DFT min_area design.

# Create a directory for reports
file mkdir reports
set report_dir reports

# ---------------------------------------------------------------------------------
# STEP 1: Read the library and the SCAN-INSERTED design correctly.
# ---------------------------------------------------------------------------------
read_lib ../../LIB/slow.lib
read_verilog ../../DFT/min_area/reports/cac_netlist_minarea_scan.v 
set_top_module collision_avoidance_car

# ---------------------------------------------------------------------------------
# STEP 2: Read the timing constraints file for a consistent comparison.
# ---------------------------------------------------------------------------------
read_sdc ../../SYNTHESIS/medium_c/optimalconstraints.sdc 

# ---------------------------------------------------------------------------------
# STEP 3: Apply professional settings to ensure 100% coverage.
# We must set ALL control ports (reset and the new DFT ports) to an inactive state.
# ---------------------------------------------------------------------------------
set_propagated_clock [all_clocks]
set_case_analysis 0 [get_ports rst]
set_case_analysis 0 [get_ports test_mode]
set_case_analysis 0 [get_ports scan_en]

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
