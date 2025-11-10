# --- 0. Create Report Directories ---
set rpt_dir    "./reports"
file mkdir $rpt_dir/pre_placement
file mkdir $rpt_dir/post_placement
file mkdir $rpt_dir/post_cts
file mkdir $rpt_dir/post_cts_opt
file mkdir $rpt_dir/post_routing

set rpt_dir_pre_placement "./reports/pre_placement"
set db_dir     "./db"


# --- 1. Set Global Init Variables ---
set init_lef_file [list ../IN/lef/gsclib090_translated_ref.lef]
set init_verilog "../IN/netlist/cac_netlist_medium_c_scan.v"
set init_top_cell "collision_avoidance_car"
set init_io_file "cac_pins.io"
set init_pwr_net "VDD"
set init_gnd_net "VSS"
set init_mmmc_file "./scripts/cac_mmmc.view"


# --- 2. Initialize the Design ---
init_design
setDesignMode -process 90 -flowEffort standard

# --- 2b. Define Scan Chain ---
specifyScanChain scan1 -start DFT_sdi_1 -stop DFT_sdo_1


# --- 3. Floorplanning ---
echo "********** Starting Floorplan **********"
floorPlan -site gsclib090site -r 1.0 0.8 10 10 10 10 


# --- 4. Power Network Design ---
echo "********** Starting Power Network Design **********"

addRing -skip_via_on_wire_shape Noshape -skip_via_on_pin Standardcell -center 1 \
        -stacked_via_top_layer Metal9 -type core_rings -jog_distance 0.435 -threshold 0.435 \
        -nets {VSS VDD} -follow core -stacked_via_bottom_layer Metal1 \
        -layer {bottom Metal8 top Metal8 right Metal9 left Metal9} -width 1.25 -spacing 0.4

addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit Metal9 -max_same_layer_jog_length 0.88 \
          -padcore_ring_bottom_layer_limit Metal7 -number_of_sets 10 -skip_via_on_pin Standardcell \
          -stacked_via_top_layer Metal9 -padcore_ring_top_layer_limit Metal9 -spacing 0.4 \
          -merge_stripes_value 0.435 -layer Metal8 -block_ring_bottom_layer_limit Metal7 \
          -width 0.44 -nets {VDD VSS} -stacked_via_bottom_layer Metal1

globalNetConnect VDD -type pgpin -pin VDD -override -verbose -netlistOverride
globalNetConnect VSS -type pgpin -pin VSS -override -verbose -netlistOverride

sroute -nets {VDD VSS} -allowLayerChange 1 -layerChangeRange {Metal1 Metal9}

saveDesign $db_dir/02_power_plan
echo "********** Floorplan and Power Plan COMPLETED **********"


# --- 5. "Before starting Physical Design" Reports ---
echo "********** Generating Pre-Placement Reports **********"

checkDesign -physicalLibrary
checkDesign -timingLibrary
checkDesign -netlist

report_timing -max_paths 100 -late -view {view1} > $rpt_dir_pre_placement/timing_setup_pre_placement.rpt
report_timing -max_paths 100 -early -view {view1} > $rpt_dir_pre_placement/timing_hold_pre_placement.rpt
report_timing -retime path_slew_propagation -max_path 50 -nworst 50 > $rpt_dir_pre_placement/timing_pba_pre_placement.rpt

report_area -detail > $rpt_dir_pre_placement/area_pre_placement.rpt
report_power -outfile $rpt_dir_pre_placement/power_pre_placement.rpt

echo "********** Pre-Placement Reports Generated in $rpt_dir_pre_placement **********"


# --- 6. Placement ---
echo "********** Starting Placement **********"

setPlaceMode -fp false
placeDesign

saveDesign $db_dir/03_placement
echo "********** Placement COMPLETED **********"


# --- 7. "After Placement" Reports ---
echo "********** Generating Post-Placement Reports **********"

set rpt_dir_post_placement "./reports/post_placement"

report_timing -max_paths 100 -late -view {view1} > $rpt_dir_post_placement/timing_setup_post_placement.rpt
report_timing -max_paths 100 -early -view {view1} > $rpt_dir_post_placement/timing_hold_post_placement.rpt
report_area -detail > $rpt_dir_post_placement/area_post_placement.rpt
report_power -outfile $rpt_dir_post_placement/power_post_placement.rpt

echo "********** Post-Placement Reports Generated in $rpt_dir_post_placement **********"


# --- 8. Clock-Tree Synthesis (CTS) ---
echo "********** Starting Clock-Tree Synthesis (CTS) **********"

set_ccopt_mode -cts_buffer_cells {CLKBUFX3 CLKBUFX2 CLKBUFX8 CLKBUFX12 CLKBUFX16 CLKBUFX20 CLKINVX3 CLKINVX2 CLKINVX8 CLKINVX12 CLKINVX16}



create_ccopt_clock_tree_spec -file ccopt_new.spec -keep_all_sdc_clocks -views {view1}
source ccopt_new.spec
ccopt_design

saveDesign $db_dir/04_cts
echo "********** CTS COMPLETED **********"


# --- 9. Post-CTS Optimization ---
echo "********** Starting Post-CTS Optimization **********"

optDesign -postCTS        ;# Fixes setup violations
optDesign -postCTS -hold  ;# Fixes hold violations

saveDesign $db_dir/05_post_cts_opt
echo "********** Post-CTS Optimization COMPLETED **********"


# --- 10. Post-CTS DRC Fix ---
echo "********** Starting Post-CTS DRC Fix **********"
ccopt_pro -enable_drv_fixing true -enable_drv_fixing_by_rebuffering true -enable_refine_place true -enable_routing_eco true -enable_skew_fixing true -enable_skew_fixing_by_rebuffering true -enable_timing_update true

saveDesign $db_dir/06_cts_drc_fixed
echo "********** Post-CTS DRC Fix COMPLETED **********"


# --- 11. "After (CTS) Clock Tree Synthesis" Reports ---
echo "********** Generating Post-CTS Reports **********"

set rpt_dir_post_cts "./reports/post_cts"

report_timing -max_paths 100 -late -view {view1} > $rpt_dir_post_cts/timing_setup_post_cts.rpt
report_timing -max_paths 100 -early -view {view1} > $rpt_dir_post_cts/timing_hold_post_cts.rpt
report_area -detail > $rpt_dir_post_cts/area_post_cts.rpt
report_power -outfile $rpt_dir_post_cts/power_post_cts.rpt

echo "********** Post-CTS Reports Generated in $rpt_dir_post_cts **********"



# --- 12. Routing ---
echo "********** Starting Detailed Routing **********"

# --- THIS IS THE HOLD FIX ---
# We enable the timing-driven and SI-driven engines of the router itself.
# This will make the router fix the small hold violation.
setNanoRouteMode -quiet -timingEngine {}
setNanoRouteMode -quiet -routeWithSiPostRouteFix true
setNanoRouteMode -quiet -drouteStartIteration default
setNanoRouteMode -quiet -routeTopRoutingLayer default
setNanoRouteMode -quiet -routeBottomRoutingLayer default
setNanoRouteMode -quiet -drouteEndIteration default
setNanoRouteMode -quiet -routeWithTimingDriven true
setNanoRouteMode -quiet -routeWithSiDriven true

routeDesign -globalDetail

saveDesign $db_dir/07_routed
echo "********** Routing COMPLETED **********"


# --- 13. "After Detailed Routing" Reports ---
echo "********** Generating Post-Routing Reports **********"

set rpt_dir_post_routing "./reports/post_routing"

report_timing -max_paths 100 -late -view {view1} > $rpt_dir_post_routing/timing_setup_post_routing.rpt
report_timing -max_paths 100 -early -view {view1} > $rpt_dir_post_routing/timing_hold_post_routing.rpt
report_area -detail > $rpt_dir_post_routing/area_post_routing.rpt
report_power -outfile $rpt_dir_post_routing/power_post_routing.rpt
reportWire > $rpt_dir_post_routing/wire_post_routing.rpt
reportRoute > $rpt_dir_post_routing/route_post_routing.rpt

echo "********** Post-Routing Reports Generated in $rpt_dir_post_routing **********"


# --- 14. Final GDS ---
echo "********** Writing final GDSII File **********"

streamOut ./gds/cac_high_util.gds -mapFile streamOut.map -libName DesignLib -units 2000 -mode ALL

echo "********** GDS File Generated in ./gds/ folder **********"
echo "********** SCRIPT FINISHED **********"


