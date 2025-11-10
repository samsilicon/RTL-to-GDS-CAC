# --- DFT Script for min_area netlist (Definitive, Professional Fix) ---
# This script corrects the library loading and input file to correctly perform
# scan synthesis on the min_area design.

# Create a directory for reports
file mkdir reports
set report_dir reports

# ---------------------------------------------------------------------------------
# STEP 1: Read the library, ORIGINAL RTL, and constraints.
# This is a "scan synthesis" flow. We synthesize and insert scan at the same time.
# ---------------------------------------------------------------------------------
# THE KEY FIX: Use the correct command to load the library.
set_attr library ../../LIB/slow.lib
# Read the original RTL, not the pre-synthesized netlist.
read_hdl ../../RTL/cac.v
elaborate collision_avoidance_car
# Read the SDC for the min_area run.
read_sdc ../../SYNTHESIS/min_area/minareaconstraints.sdc

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
# STEP 4: Synthesize the design with scan awareness.
# ---------------------------------------------------------------------------------
synthesize -to_mapped -effort medium

# ---------------------------------------------------------------------------------
# STEP 5: Insert the scan chain.
# ---------------------------------------------------------------------------------
connect_scan_chains -auto_create_chains

# ---------------------------------------------------------------------------------
# STEP 6: Generate all required output files and reports.
# ---------------------------------------------------------------------------------
# Write the new, scan-inserted netlist
write_hdl > $report_dir/cac_netlist_minarea_scan.v

# Write the new SDC for the scan-inserted design
write_sdc > $report_dir/cac_constraints_minarea_scan.sdc

# Write out test protocol files for automatic test equipment (ATE)
write_atpg -stil > $report_dir/cac_minarea.stil

# Write out all the final area and timing reports for comparison
report_qor > $report_dir/qor_summary_scan.rpt
report_timing > $report_dir/timing_report_scan.rpt
report_area > $report_dir/area_report_scan.rpt
report_gates > $report_dir/cell_report_scan.rpt
report_power > $report_dir/power_report_scan.rpt

exit
