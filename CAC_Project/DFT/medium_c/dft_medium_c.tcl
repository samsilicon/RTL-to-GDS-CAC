# --- DFT Script for medium_c (balanced) netlist (Definitive, Professional Fix) ---
# This script corrects the invalid attribute error by removing the problematic line
# and relies on the tool's default behavior to create the required single scan chain.

# Create a directory for reports
file mkdir reports
set report_dir reports

# ---------------------------------------------------------------------------------
# STEP 1: Read the library, ORIGINAL RTL, and the balanced (medium_c) constraints.
# ---------------------------------------------------------------------------------
set_attr library ../../LIB/slow.lib
read_hdl ../../RTL/cac.v
elaborate collision_avoidance_car
read_sdc ../../SYNTHESIS/medium_c/optimalconstraints.sdc

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
# STEP 5: Insert a single scan chain. THIS IS THE KEY FIX.
# The invalid 'set_attr dft_max_scan_chains' command has been removed.
# The 'connect_scan_chains' command will now default to creating a single chain.
# ---------------------------------------------------------------------------------
connect_scan_chains -auto_create_chains

# ---------------------------------------------------------------------------------
# STEP 6: Generate all required output files and reports.
# ---------------------------------------------------------------------------------
# Write the new, scan-inserted netlist
write_hdl > $report_dir/cac_netlist_medium_c_scan.v

# Write the new SDC for the scan-inserted design
write_sdc > $report_dir/cac_constraints_medium_c_scan.sdc

# Write out test protocol files for automatic test equipment (ATE)
write_atpg -stil > $report_dir/cac_medium_c.stil

# Write out all the final area and timing reports for comparison
report_qor > $report_dir/qor_summary_scan.rpt
report_timing > $report_dir/timing_report_scan.rpt
report_area > $report_dir/area_report_scan.rpt
report_gates > $report_dir/cell_report_scan.rpt
report_power > $report_dir/power_report_scan.rpt

exit
