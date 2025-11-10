# --- STA Script for medium_c SCAN-INSERTED netlist (Definitive, Professional Fix) ---
# This script uses our proven, self-contained template to provide a complete and
# professional analysis of the post-DFT medium_c design.

# Create a directory for reports
file mkdir reports
set report_dir reports

# ---------------------------------------------------------------------------------
# STEP 1: Read the Technology Library FIRST. This is the most critical fix.
# ---------------------------------------------------------------------------------
read_lib ../../LIB/slow.lib

# ---------------------------------------------------------------------------------
# STEP 2: Read the synthesized, SCAN-INSERTED netlist.
# ---------------------------------------------------------------------------------
read_verilog ../../DFT/medium_c/reports/cac_netlist_medium_c_scan.v 
set_top_module collision_avoidance_car

# ---------------------------------------------------------------------------------
# STEP 3: Define ALL timing constraints natively inside the script.
# This avoids any potential issues with reading external SDC files.
# We use the 15ns clock as required.
# ---------------------------------------------------------------------------------
create_clock -name "clk" -period 15 [get_ports clk]

# Add realistic clock characteristics
set_clock_latency 0.25 [get_clocks clk]
set_clock_transition 0.2 -rise [get_clocks clk]
set_clock_transition 0.2 -fall [get_clocks clk]
set_clock_uncertainty 0.1 [get_clocks clk]

# Define all Input and Output Delays
set_input_delay 0.4 -clock [get_clocks clk] [get_ports rst]
set_input_delay 0.4 -clock [get_clocks clk] [get_ports front_obstacle_detected]
set_input_delay 0.4 -clock [get_clocks clk] [get_ports left_obstacle_detected]
set_input_delay 0.4 -clock [get_clocks clk] [get_ports right_obstacle_detected]
set_input_delay 0.4 -clock [get_clocks clk] [get_ports front_obstacle_slow]
set_input_delay 0.4 -clock [get_clocks clk] [get_ports lane_clear_left]
set_input_delay 0.4 -clock [get_clocks clk] [get_ports lane_clear_right]
set_input_delay 0.4 -clock [get_clocks clk] [get_ports destination_reached]
set_input_delay 0.4 -clock [get_clocks clk] [get_ports {speed_limit_zone[*]}]

set_output_delay 0.2 -clock [get_clocks clk] [get_ports {acceleration[*]}]
set_output_delay 0.2 -clock [get_clocks clk] [get_ports {steering[*]}]
set_output_delay 0.2 -clock [get_clocks clk] [get_ports {indicators[*]}]
set_output_delay 0.2 -clock [get_clocks clk] [get_ports {current_speed_out[*]}]
set_output_delay 0.2 -clock [get_clocks clk] [get_ports {distance_travelled_out[*]}]
set_output_delay 0.2 -clock [get_clocks clk] [get_ports {total_power_consumed_out[*]}]

# ---------------------------------------------------------------------------------
# STEP 4: Apply professional settings to ensure 100% coverage.
# We must set ALL control ports (reset and the new DFT ports) to an inactive state.
# ---------------------------------------------------------------------------------
set_propagated_clock [all_clocks]
set_case_analysis 0 [get_ports rst]
set_case_analysis 0 [get_ports test_mode]
set_case_analysis 0 [get_ports scan_en]

# ---------------------------------------------------------------------------------
# STEP 5: Force the tool to apply all settings before reporting. THIS IS THE KEY.
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
