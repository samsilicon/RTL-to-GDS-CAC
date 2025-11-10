#######################################################
#                                                     
#  Tempus Timing Signoff Solution Command Logging File                     
#  Created on Fri Oct 10 16:00:34 2025                
#                                                     
#######################################################

#@(#)CDS: Tempus Timing Signoff Solution v20.10-p003_1 (64bit) 04/29/2020 15:56 (Linux 2.6.32-431.11.2.el6.x86_64)
#@(#)CDS: NanoRoute 20.10-p003_1 NR200413-0234/20_10-UB (database version 18.20.505) {superthreading v1.69}
#@(#)CDS: AAE 20.10-p005 (64bit) 04/29/2020 (Linux 2.6.32-431.11.2.el6.x86_64)
#@(#)CDS: CTE 20.10-p005_1 () Apr 14 2020 09:14:28 ( )
#@(#)CDS: SYNTECH 20.10-b004_1 () Mar 12 2020 22:18:21 ( )
#@(#)CDS: CPE v20.10-p006

read_lib ../../LIB/slow.lib
read_verilog ../../DFT/min_time/reports/cac_netlist_mintime_scan.v
set_top_module collision_avoidance_car
read_sdc ../../SYNTHESIS/medium_c/optimalconstraints.sdc
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
