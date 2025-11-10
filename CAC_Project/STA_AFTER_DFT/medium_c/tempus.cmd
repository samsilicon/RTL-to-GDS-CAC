#######################################################
#                                                     
#  Tempus Timing Signoff Solution Command Logging File                     
#  Created on Sat Oct 11 05:12:29 2025                
#                                                     
#######################################################

#@(#)CDS: Tempus Timing Signoff Solution v20.10-p003_1 (64bit) 04/29/2020 15:56 (Linux 2.6.32-431.11.2.el6.x86_64)
#@(#)CDS: NanoRoute 20.10-p003_1 NR200413-0234/20_10-UB (database version 18.20.505) {superthreading v1.69}
#@(#)CDS: AAE 20.10-p005 (64bit) 04/29/2020 (Linux 2.6.32-431.11.2.el6.x86_64)
#@(#)CDS: CTE 20.10-p005_1 () Apr 14 2020 09:14:28 ( )
#@(#)CDS: SYNTECH 20.10-b004_1 () Mar 12 2020 22:18:21 ( )
#@(#)CDS: CPE v20.10-p006

read_lib ../../LIB/slow.lib
read_verilog ../../DFT/medium_c/reports/cac_netlist_medium_c_scan.v
set_top_module collision_avoidance_car
create_clock -name "clk" -period 15 [get_ports clk]
set_clock_latency 0.25 [get_clocks clk]
set_clock_transition 0.2 -rise [get_clocks clk]
set_clock_transition 0.2 -fall [get_clocks clk]
set_clock_uncertainty 0.1 [get_clocks clk]
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
set_propagated_clock [all_clocks]
set_case_analysis 0 [get_ports rst]
set_case_analysis 0 [get_ports test_mode]
set_case_analysis 0 [get_ports scan_en]
update_timing
check_timing > $report_dir/check_timing.rpt 
report_timing > $report_dir/timing_report.rpt
report_timing -nworst 100 -late > $report_dir/timing_setup.rpt
report_timing -nworst 100 -early > $report_dir/timing_hold.rpt
report_analysis_coverage > $report_dir/analysis_coverage.rpt 
report_analysis_summary > $report_dir/analysis_summary.rpt 
report_clocks > $report_dir/clocks.rpt 
report_case_analysis > $report_dir/case_analysis.rpt 
report_constraints -all_violators > reports/allviolationsinit.rpt
exit
