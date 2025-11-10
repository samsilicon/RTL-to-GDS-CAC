# --- Synthesis Script for Balanced/Optimal (CAC Project) ---

# Set the paths for the library and RTL files
set_attr lib_search_path ../../LIB/
set_attr hdl_search_path ../../RTL/

# Specify the technology library to use
set_attr library slow.lib

# Read your Verilog design file
read_hdl cac.v

# Elaborate the design to create a technology-independent netlist
elaborate

# Read the Synopsys Design Constraints (SDC) file for this run
read_sdc optimalconstraints.sdc

# Synthesize the design, mapping it to the library gates
synthesize -to_mapped -effort medium

# --- Reporting ---
# Create a dedicated directory for the output reports
exec mkdir -p ./reports

# Write out the final gate-level netlist
write_hdl > ./reports/cac_netlist_optimal.v

# Write out the SDC file for the next stages (Place & Route)
write_sdc > ./reports/cac_constraints_optimal.sdc

# Generate synthesis reports
report gates > ./reports/cac_cell_report_optimal.rep
report timing > ./reports/cac_timing_report_optimal.rep
report area > ./reports/cac_area_report_optimal.rep
report power > ./reports/cac_power_report_optimal.rep

# (Optional) Show the graphical user interface
gui_show
