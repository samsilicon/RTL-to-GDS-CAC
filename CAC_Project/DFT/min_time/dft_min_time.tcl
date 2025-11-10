# --- DFT Script for min_time netlist (Definitive, Professional Fix) ---
# This script performs scan synthesis on the min_time design, using the final
# aggressive timing constraints and creating a single scan chain.

# Create a directory for reports
file mkdir reports
set report_dir reports

# ---------------------------------------------------------------------------------
# STEP 1: Read the library, ORIGINAL RTL, and the final min_time constraints.
# ---------------------------------------------------------------------------------
set_attr library ../../LIB/slow.lib
read_hdl ../../RTL/cac.v
elaborate collision_avoidance_car
# Use the final, aggressive SDC file that produced the slight negative slack.
read_sdc ../../SYNTHESIS/min_time/mintimeconstraints.sdc

# ---------------------------------------------------------------------------------
# STEP 2: Define the DFT (Scan) Architecture.
# ---------------------------------------------------------------------------------
set_attr dft_scan_style muxed_scan
define_dft shift_enable -active high -create_port scan_en
define_dft test_mode -active high -create_port test_mode
define_dft test_clock clk

# ---------------------------------------------------------------------------------
# STEP 3: Check for and fix any DFT rule violations.
# ---------------------------------------------------------------------------------
check_dft_rules > $report_dir/dft_rules_report.txt
fix_dft_violations -test_control test_mode -async_set -async_reset -clock

# ---------------------------------------------------------------------------------
# STEP 4: Synthesize the design with scan awareness, prioritizing timing.
# ---------------------------------------------------------------------------------
synthesize -to_mapped -effort high

# ---------------------------------------------------------------------------------
# STEP 5: Insert a single scan chain.
# For a single-clock design, this is the default behavior.
# ---------------------------------------------------------------------------------
connect_scan_chains -auto_create_chains

# ---------------------------------------------------------------------------------
# STEP 6: Generate all required output files and reports.
# ---------------------------------------------------------------------------------
# Write the new, scan-inserted netlist
write_hdl > $report_dir/cac_netlist_mintime_scan.v

# Write the new SDC for the scan-inserted design
write_sdc > $report_dir/cac_constraints_mintime_scan.sdc

# Write out test protocol files for automatic test equipment (ATE)
write_atpg -stil > $report_dir/cac_mintime.stil

# Write out all the final area and timing reports for comparison
report_qor > $report_dir/qor_summary_scan.rpt
report_timing > $report_dir/timing_report_scan.rpt
report_area > $report_dir/area_report_scan.rpt
report_gates > $report_dir/cell_report_scan.rpt
report_power > $report_dir/power_report_scan.rpt

exit
