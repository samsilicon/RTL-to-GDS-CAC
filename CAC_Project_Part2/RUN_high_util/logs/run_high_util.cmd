#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Sun Nov  9 04:47:19 2025                
#                                                     
#######################################################

#@(#)CDS: Innovus v20.10-p004_1 (64bit) 05/07/2020 20:02 (Linux 2.6.32-431.11.2.el6.x86_64)
#@(#)CDS: NanoRoute 20.10-p004_1 NR200413-0234/20_10-UB (database version 18.20.505) {superthreading v1.69}
#@(#)CDS: AAE 20.10-p005 (64bit) 05/07/2020 (Linux 2.6.32-431.11.2.el6.x86_64)
#@(#)CDS: CTE 20.10-p005_1 () Apr 14 2020 09:14:28 ( )
#@(#)CDS: SYNTECH 20.10-b004_1 () Mar 12 2020 22:18:21 ( )
#@(#)CDS: CPE v20.10-p006
#@(#)CDS: IQuantus/TQuantus 19.1.3-s155 (64bit) Sun Nov 3 18:26:52 PST 2019 (Linux 2.6.32-431.11.2.el6.x86_64)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
getVersion
getVersion
getVersion
set init_lef_file ../IN/lef/gsclib090_translated_ref.lef
set init_verilog ../IN/netlist/cac_netlist_medium_c_scan.v
set init_top_cell collision_avoidance_car
set init_io_file cac_pins.io
set init_pwr_net VDD
set init_gnd_net VSS
set init_mmmc_file ./scripts/cac_mmmc.view
init_design
setDesignMode -process 90 -flowEffort standard
specifyScanChain scan1 -start DFT_sdi_1 -stop DFT_sdo_1
floorPlan -site gsclib090site -r 1.0 0.8 10 10 10 10
addRing -skip_via_on_wire_shape Noshape -skip_via_on_pin Standardcell -center 1 -stacked_via_top_layer Metal9 -type core_rings -jog_distance 0.435 -threshold 0.435 -nets {VSS VDD} -follow core -stacked_via_bottom_layer Metal1 -layer {bottom Metal8 top Metal8 right Metal9 left Metal9} -width 1.25 -spacing 0.4
addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit Metal9 -max_same_layer_jog_length 0.88 -padcore_ring_bottom_layer_limit Metal7 -number_of_sets 10 -skip_via_on_pin Standardcell -stacked_via_top_layer Metal9 -padcore_ring_top_layer_limit Metal9 -spacing 0.4 -merge_stripes_value 0.435 -layer Metal8 -block_ring_bottom_layer_limit Metal7 -width 0.44 -nets {VDD VSS} -stacked_via_bottom_layer Metal1
globalNetConnect VDD -type pgpin -pin VDD -override -verbose -netlistOverride
globalNetConnect VSS -type pgpin -pin VSS -override -verbose -netlistOverride
sroute -nets {VDD VSS} -allowLayerChange 1 -layerChangeRange {Metal1 Metal9}
saveDesign ./db/02_power_plan
checkDesign -physicalLibrary
checkDesign -timingLibrary
checkDesign -netlist
report_timing -max_paths 100 -late -view {view1} > $rpt_dir_pre_placement/timing_setup_pre_placement.rpt
report_timing -max_paths 100 -early -view {view1} > $rpt_dir_pre_placement/timing_hold_pre_placement.rpt
report_timing -retime path_slew_propagation -max_path 50 -nworst 50 > $rpt_dir_pre_placement/timing_pba_pre_placement.rpt
report_area -detail > ./reports/pre_placement/area_pre_placement.rpt
report_power -outfile ./reports/pre_placement/power_pre_placement.rpt
setPlaceMode -fp false
getPlaceMode -place_hierarchical_flow -quiet
report_message -start_cmd
getRouteMode -maxRouteLayer -quiet
getRouteMode -user -maxRouteLayer
getPlaceMode -user -maxRouteLayer
getPlaceMode -quiet -adaptiveFlowMode
getPlaceMode -timingDriven -quiet
getPlaceMode -adaptive -quiet
getPlaceMode -relaxSoftBlockageMode -quiet
getPlaceMode -user -relaxSoftBlockageMode
getPlaceMode -ignoreScan -quiet
getPlaceMode -user -ignoreScan
getPlaceMode -repairPlace -quiet
getPlaceMode -user -repairPlace
getPlaceMode -inPlaceOptMode -quiet
getPlaceMode -quiet -bypassFlowEffortHighChecking
getDesignMode -quiet -siPrevention
getPlaceMode -exp_slack_driven -quiet
um::push_snapshot_stack
getDesignMode -quiet -flowEffort
getDesignMode -highSpeedCore -quiet
getPlaceMode -quiet -adaptive
set spgFlowInInitialPlace 1
getPlaceMode -sdpAlignment -quiet
getPlaceMode -softGuide -quiet
getPlaceMode -useSdpGroup -quiet
getPlaceMode -sdpAlignment -quiet
getPlaceMode -enableDbSaveAreaPadding -quiet
getPlaceMode -quiet -wireLenOptEffort
getPlaceMode -sdpPlace -quiet
getPlaceMode -exp_slack_driven -quiet
getPlaceMode -sdpPlace -quiet
getPlaceMode -groupHighLevelClkGate -quiet
setvar spgRptErrorForScanConnection 0
getPlaceMode -place_global_exp_allow_missing_scan_chain -quiet
getPlaceMode -place_check_library -quiet
getPlaceMode -trimView -quiet
getPlaceMode -expTrimOptBeforeTDGP -quiet
getPlaceMode -quiet -useNonTimingDeleteBufferTree
getPlaceMode -congEffort -quiet
getPlaceMode -relaxSoftBlockageMode -quiet
getPlaceMode -user -relaxSoftBlockageMode
getPlaceMode -ignoreScan -quiet
getPlaceMode -user -ignoreScan
getPlaceMode -repairPlace -quiet
getPlaceMode -user -repairPlace
getPlaceMode -congEffort -quiet
getPlaceMode -fp -quiet
getPlaceMode -timingDriven -quiet
getPlaceMode -user -timingDriven
getPlaceMode -fastFp -quiet
getPlaceMode -clusterMode -quiet
get_proto_model -type_match {flex_module flex_instgroup} -committed -name -tcl
getPlaceMode -inPlaceOptMode -quiet
getPlaceMode -quiet -bypassFlowEffortHighChecking
getPlaceMode -ultraCongEffortFlow -quiet
getPlaceMode -forceTiming -quiet
getPlaceMode -fp -quiet
getPlaceMode -fastfp -quiet
getPlaceMode -timingDriven -quiet
getPlaceMode -fp -quiet
getPlaceMode -fastfp -quiet
getPlaceMode -powerDriven -quiet
getExtractRCMode -quiet -engine
getAnalysisMode -quiet -clkSrcPath
getAnalysisMode -quiet -clockPropagation
getAnalysisMode -quiet -cppr
setExtractRCMode -engine preRoute
setAnalysisMode -clkSrcPath false -clockPropagation forcedIdeal
getPlaceMode -exp_slack_driven -quiet
isAnalysisModeSetup
getPlaceMode -quiet -place_global_exp_solve_unbalance_path
getPlaceMode -quiet -NMPsuppressInfo
getPlaceMode -quiet -place_global_exp_wns_focus_v2
getPlaceMode -enableDistPlace -quiet
getPlaceMode -quiet -clusterMode
getPlaceMode -wl_budget_mode -quiet
setPlaceMode -reset -place_global_exp_balance_buffer_chain
getPlaceMode -wl_budget_mode -quiet
setPlaceMode -reset -place_global_exp_balance_pipeline
getPlaceMode -place_global_exp_balance_buffer_chain -quiet
getPlaceMode -place_global_exp_balance_pipeline -quiet
getPlaceMode -tdgpMemFlow -quiet
getPlaceMode -user -resetCombineRFLevel
getPlaceMode -quiet -resetCombineRFLevel
setPlaceMode -resetCombineRFLevel 1000
setvar spgSpeedupBuildVSM 1
getPlaceMode -tdgpResetCteTG -quiet
getPlaceMode -macroPlaceMode -quiet
getPlaceMode -enableDistPlace -quiet
getPlaceMode -exp_slack_driven -quiet
getPlaceMode -place_global_ignore_spare -quiet
getPlaceMode -enableDistPlace -quiet
getPlaceMode -quiet -expNewFastMode
setPlaceMode -expHiddenFastMode 1
setPlaceMode -reset -ignoreScan
getPlaceMode -quiet -place_global_exp_auto_finish_floorplan
colorizeGeometry
getPlaceMode -quiet -IOSlackAdjust
getPlaceMode -tdgpCteZeroDelayModeDelBuf -quiet
set_global timing_enable_zero_delay_analysis_mode true
getPlaceMode -quiet -useNonTimingDeleteBufferTree
getPlaceMode -quiet -prePlaceOptSimplifyNetlist
getPlaceMode -quiet -enablePrePlaceOptimizations
getPlaceMode -quiet -prePlaceOptDecloneInv
deleteBufferTree -decloneInv
getPlaceMode -tdgpCteZeroDelayModeDelBuf -quiet
set_global timing_enable_zero_delay_analysis_mode false
getAnalysisMode -quiet -honorClockDomains
getPlaceMode -honorUserPathGroup -quiet
getAnalysisMode -quiet -honorClockDomains
set delaycal_use_default_delay_limit 101
set delaycal_default_net_delay 0
set delaycal_default_net_load 0
set delaycal_default_net_load_ignore_for_ilm 0
getAnalysisMode -clkSrcPath -quiet
getAnalysisMode -clockPropagation -quiet
getAnalysisMode -checkType -quiet
buildTimingGraph
getDelayCalMode -ignoreNetLoad -quiet
getDelayCalMode -ignoreNetLoad -quiet
setDelayCalMode -ignoreNetLoad true -quiet
get_global timing_enable_path_group_priority
get_global timing_constraint_enable_group_path_resetting
set_global timing_enable_path_group_priority false
set_global timing_constraint_enable_group_path_resetting false
getOptMode -allowPreCTSClkSrcPaths -quiet
set_global _is_ipo_interactive_path_groups 1
group_path -name in2reg_tmp.36380 -from {0x17f8 0x17fb} -to 0x17fc -ignore_source_of_trigger_arc
getOptMode -allowPreCTSClkSrcPaths -quiet
set_global _is_ipo_interactive_path_groups 1
group_path -name in2out_tmp.36380 -from {0x17ff 0x1802} -to 0x1803 -ignore_source_of_trigger_arc
set_global _is_ipo_interactive_path_groups 1
group_path -name reg2reg_tmp.36380 -from 0x1805 -to 0x1806
set_global _is_ipo_interactive_path_groups 1
group_path -name reg2out_tmp.36380 -from 0x1809 -to 0x180a
setPathGroupOptions reg2reg_tmp.36380 -effortLevel high
reset_path_group -name reg2out_tmp.36380
set_global _is_ipo_interactive_path_groups 0
reset_path_group -name in2reg_tmp.36380
set_global _is_ipo_interactive_path_groups 0
reset_path_group -name in2out_tmp.36380
set_global _is_ipo_interactive_path_groups 0
reset_path_group -name reg2reg_tmp.36380
set_global _is_ipo_interactive_path_groups 0
setDelayCalMode -ignoreNetLoad false
set delaycal_use_default_delay_limit 1000
set delaycal_default_net_delay 1000ps
set delaycal_default_net_load 0.5pf
set delaycal_default_net_load_ignore_for_ilm 0
all_setup_analysis_views
getPlaceMode -place_global_exp_ignore_low_effort_path_groups -quiet
getPlaceMode -exp_slack_driven -quiet
getAnalysisMode -quiet -honorClockDomains
getPlaceMode -ignoreUnproperPowerInit -quiet
getPlaceMode -quiet -expSkipGP
setDelayCalMode -engine feDc
createBasicPathGroups -quiet
psp::embedded_egr_init_
psp::embedded_egr_term_
reset_path_group
set_global _is_ipo_interactive_path_groups 0
scanReorder
setDelayCalMode -engine aae
all_setup_analysis_views
getPlaceMode -exp_slack_driven -quiet
set_global timing_enable_path_group_priority $gpsPrivate::optSave_ctePGPriority
set_global timing_constraint_enable_group_path_resetting $gpsPrivate::optSave_ctePGResetting
getPlaceMode -quiet -tdgpAdjustNetWeightBySlack
get_ccopt_clock_trees *
getPlaceMode -exp_insert_guidance_clock_tree -quiet
getPlaceMode -exp_cluster_based_high_fanout_buffering -quiet
getPlaceMode -place_global_exp_incr_skp_preserve_mode_v2 -quiet
getPlaceMode -quiet -place_global_exp_netlist_balance_flow
getPlaceMode -quiet -timingEffort
getAnalysisMode -quiet -honorClockDomains
getPlaceMode -honorUserPathGroup -quiet
getAnalysisMode -quiet -honorClockDomains
set delaycal_use_default_delay_limit 101
set delaycal_default_net_delay 0
set delaycal_default_net_load 0
set delaycal_default_net_load_ignore_for_ilm 0
getAnalysisMode -clkSrcPath -quiet
getAnalysisMode -clockPropagation -quiet
getAnalysisMode -checkType -quiet
buildTimingGraph
getDelayCalMode -ignoreNetLoad -quiet
getDelayCalMode -ignoreNetLoad -quiet
setDelayCalMode -ignoreNetLoad true -quiet
get_global timing_enable_path_group_priority
get_global timing_constraint_enable_group_path_resetting
set_global timing_enable_path_group_priority false
set_global timing_constraint_enable_group_path_resetting false
getOptMode -allowPreCTSClkSrcPaths -quiet
set_global _is_ipo_interactive_path_groups 1
group_path -name in2reg_tmp.36380 -from {0x1814 0x1817} -to 0x1818 -ignore_source_of_trigger_arc
getOptMode -allowPreCTSClkSrcPaths -quiet
set_global _is_ipo_interactive_path_groups 1
group_path -name in2out_tmp.36380 -from {0x181b 0x181e} -to 0x181f -ignore_source_of_trigger_arc
set_global _is_ipo_interactive_path_groups 1
group_path -name reg2reg_tmp.36380 -from 0x1821 -to 0x1822
set_global _is_ipo_interactive_path_groups 1
group_path -name reg2out_tmp.36380 -from 0x1825 -to 0x1826
setPathGroupOptions reg2reg_tmp.36380 -effortLevel high
reset_path_group -name reg2out_tmp.36380
set_global _is_ipo_interactive_path_groups 0
reset_path_group -name in2reg_tmp.36380
set_global _is_ipo_interactive_path_groups 0
reset_path_group -name in2out_tmp.36380
set_global _is_ipo_interactive_path_groups 0
reset_path_group -name reg2reg_tmp.36380
set_global _is_ipo_interactive_path_groups 0
setDelayCalMode -ignoreNetLoad false
set delaycal_use_default_delay_limit 1000
set delaycal_default_net_delay 1000ps
set delaycal_default_net_load 0.5pf
set delaycal_default_net_load_ignore_for_ilm 0
all_setup_analysis_views
getPlaceMode -place_global_exp_ignore_low_effort_path_groups -quiet
getPlaceMode -exp_slack_driven -quiet
getPlaceMode -quiet -cong_repair_commit_clock_net_route_attr
getPlaceMode -enableDbSaveAreaPadding -quiet
getPlaceMode -quiet -wireLenOptEffort
setPlaceMode -reset -improveWithPsp
getPlaceMode -quiet -debugGlobalPlace
getPlaceMode -congRepair -quiet
getPlaceMode -fp -quiet
getPlaceMode -user -rplaceIncrNPClkGateAwareMode
getPlaceMode -user -congRepairMaxIter
getPlaceMode -quiet -congRepairPDClkGateMode4
setPlaceMode -rplaceIncrNPClkGateAwareMode 4
getPlaceMode -quiet -expCongRepairPDOneLoop
setPlaceMode -congRepairMaxIter 1
getPlaceMode -quickCTS -quiet
get_proto_model -type_match {flex_module flex_instgroup} -committed -name -tcl
getPlaceMode -congRepairForceTrialRoute -quiet
getPlaceMode -user -congRepairForceTrialRoute
setPlaceMode -congRepairForceTrialRoute true
::goMC::is_advanced_metrics_collection_enabled
congRepair
::goMC::is_advanced_metrics_collection_enabled
::goMC::is_advanced_metrics_collection_enabled
::goMC::is_advanced_metrics_collection_enabled
setPlaceMode -reset -congRepairForceTrialRoute
getPlaceMode -quiet -congRepairPDClkGateMode4
setPlaceMode -reset -rplaceIncrNPClkGateAwareMode
setPlaceMode -reset -congRepairMaxIter
getPlaceMode -congRepairCleanupPadding -quiet
getPlaceMode -quiet -wireLenOptEffort
all_setup_analysis_views
getPlaceMode -exp_slack_driven -quiet
set_global timing_enable_path_group_priority $gpsPrivate::optSave_ctePGPriority
set_global timing_constraint_enable_group_path_resetting $gpsPrivate::optSave_ctePGResetting
getPlaceMode -place_global_exp_incr_skp_preserve_mode_v2 -quiet
getPlaceMode -quiet -place_global_exp_netlist_balance_flow
getPlaceMode -quiet -timingEffort
getPlaceMode -tdgpDumpStageTiming -quiet
getPlaceMode -quiet -tdgpAdjustNetWeightBySlack
getPlaceMode -trimView -quiet
getOptMode -quiet -viewOptPolishing
getOptMode -quiet -fastViewOpt
spInternalUse deleteViewOptManager
spInternalUse tdgp clearSkpData
setAnalysisMode -clkSrcPath true -clockPropagation sdcControl
getPlaceMode -exp_slack_driven -quiet
setExtractRCMode -engine preRoute
setPlaceMode -reset -relaxSoftBlockageMode
setPlaceMode -reset -ignoreScan
setPlaceMode -reset -repairPlace
getPlaceMode -quiet -NMPsuppressInfo
setvar spgSpeedupBuildVSM 0
getPlaceMode -macroPlaceMode -quiet
getPlaceMode -exp_slack_driven -quiet
getPlaceMode -enableDistPlace -quiet
getPlaceMode -place_global_ignore_spare -quiet
getPlaceMode -tdgpMemFlow -quiet
setPlaceMode -reset -resetCombineRFLevel
getPlaceMode -enableDistPlace -quiet
getPlaceMode -quiet -clusterMode
getPlaceMode -quiet -place_global_exp_solve_unbalance_path
getPlaceMode -enableDistPlace -quiet
setPlaceMode -reset -expHiddenFastMode
getPlaceMode -tcg2Pass -quiet
getPlaceMode -quiet -wireLenOptEffort
getPlaceMode -fp -quiet
getPlaceMode -fastfp -quiet
getPlaceMode -doRPlace -quiet
getPlaceMode -RTCPlaceDesignFlow -quiet
getPlaceMode -quickCTS -quiet
set spgFlowInInitialPlace 0
getPlaceMode -user -maxRouteLayer
spInternalUse TDGP resetIgnoreNetLoad
getPlaceMode -place_global_exp_balance_pipeline -quiet
getDesignMode -quiet -flowEffort
report_message -end_cmd
um::create_snapshot -name final -auto min
um::pop_snapshot_stack
um::create_snapshot -name place_design
getPlaceMode -exp_slack_driven -quiet
saveDesign ./db/03_placement
report_timing -max_paths 100 -late -view {view1} > $rpt_dir_post_placement/timing_setup_post_placement.rpt
report_timing -max_paths 100 -early -view {view1} > $rpt_dir_post_placement/timing_hold_post_placement.rpt
report_area -detail > ./reports/post_placement/area_post_placement.rpt
report_power -outfile ./reports/post_placement/power_post_placement.rpt
create_ccopt_clock_tree_spec -file ccopt_new.spec -keep_all_sdc_clocks -views view1
get_ccopt_clock_trees
ccopt_check_and_flatten_ilms_no_restore
set_ccopt_property cts_is_sdc_clock_root -pin clk true
create_ccopt_clock_tree -name clk -source clk -no_skew_group
set_ccopt_property clock_period -pin clk 15.5
create_ccopt_skew_group -name clk/sdc1 -sources clk -auto_sinks
set_ccopt_property include_source_latency -skew_group clk/sdc1 true
set_ccopt_property extracted_from_clock_name -skew_group clk/sdc1 clk
set_ccopt_property extracted_from_constraint_mode_name -skew_group clk/sdc1 sdc1
set_ccopt_property extracted_from_delay_corners -skew_group clk/sdc1 delay1
check_ccopt_clock_tree_convergence
get_ccopt_property auto_design_state_for_ilms
ccopt_design
saveDesign ./db/04_cts
optDesign -postCTS
optDesign -postCTS -hold
saveDesign ./db/05_post_cts_opt
ccopt_pro -enable_drv_fixing true -enable_drv_fixing_by_rebuffering true -enable_refine_place true -enable_routing_eco true -enable_skew_fixing true -enable_skew_fixing_by_rebuffering true -enable_timing_update true
saveDesign ./db/06_cts_drc_fixed
report_timing -max_paths 100 -late -view {view1} > $rpt_dir_post_cts/timing_setup_post_cts.rpt
report_timing -max_paths 100 -early -view {view1} > $rpt_dir_post_cts/timing_hold_post_cts.rpt
report_area -detail > ./reports/post_cts/area_post_cts.rpt
report_power -outfile ./reports/post_cts/power_post_cts.rpt
setNanoRouteMode -quiet -timingEngine {}
setNanoRouteMode -quiet -routeWithSiPostRouteFix true
setNanoRouteMode -quiet -drouteStartIteration default
setNanoRouteMode -quiet -routeTopRoutingLayer default
setNanoRouteMode -quiet -routeBottomRoutingLayer default
setNanoRouteMode -quiet -drouteEndIteration default
setNanoRouteMode -quiet -routeWithTimingDriven true
setNanoRouteMode -quiet -routeWithSiDriven true
routeDesign -globalDetail
saveDesign ./db/07_routed
report_timing -max_paths 100 -late -view {view1} > $rpt_dir_post_routing/timing_setup_post_routing.rpt
report_timing -max_paths 100 -early -view {view1} > $rpt_dir_post_routing/timing_hold_post_routing.rpt
report_area -detail > ./reports/post_routing/area_post_routing.rpt
report_power -outfile ./reports/post_routing/power_post_routing.rpt
reportWire > ./reports/post_routing/wire_post_routing.rpt
reportRoute > ./reports/post_routing/route_post_routing.rpt
streamOut ./gds/cac_high_util.gds -mapFile streamOut.map -libName DesignLib -units 2000 -mode ALL
