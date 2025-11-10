VDF Project Part 1 & 2 (Complete)

VDF Project Part 1: RTL to GDSII (Synthesis & Verification)

This project documents the first part of a complete VLSI design flow, taking a Register-Transfer Level (RTL) design for a "Collision Avoidance Car" (CAC) through
synthesis, verification, and test insertion. The final output of this stage is a set of verified, scan-inserted, gate-level netlists ready for physical design (Place & Route).
This flow was performed using the Cadence EDA toolchain.

Project Design: Collision Avoidance Car (CAC)

The design is a synchronous digital controller that acts as the "brain" for a self-driving car. 
It uses a Finite State Machine (FSM) to process sensor data and control the vehicle's acceleration, steering, and indicators. 
The system also calculates and tracks key metrics like current speed, total distance, and power consumption.

RTL File: RTL/cac.v

Tools Used
Synthesis & DFT: Cadence Genus
Simulation: Cadence NCLaunch & SimVision
Code Coverage: Cadence Incisive Metrics Center (IMC)
Equivalence Checking: Cadence Conformal
Static Timing Analysis: Cadence Tempus
Part 1 Design Flow: Summary of Steps
This project followed the 6 key steps of a standard RTL-to-GDS front-end flow.

1. Design Specification
A formal specification was written to define the functionality, inputs, outputs, and assumptions for the Collision Avoidance Car.
Deliverable: DOC/cac_specification.md

2. Functional Verification
The RTL design was simulated using NCLaunch against a series of testbenches to verify its logical correctness.
Code coverage reports were generated using IMC to analyze how much of the design was tested.

3. Logic Synthesis
The golden RTL (cac.v) was synthesized into gate-level netlists using Genus. 
This was done three times to analyze the area/timing trade-off:
Min Area: Synthesized with a loose 30ns clock to get the smallest possible cell area (787 cells).
Min Time: Synthesized with an aggressive 4.74ns clock (with added constraints) to find the design's maximum performance, resulting in a slight negative slack (-19ps).
Medium (Balanced): Synthesized with a realistic 15ns clock to get a balanced design.

4. Formal Equivalence Checking (LEC)
The Conformal tool was used to mathematically prove that the logic of all three synthesized netlists was identical to the original RTL.
All three netlists successfully PASSED the equivalence check.
A failure analysis was also performed by manually creating a cac_netlist_bad.v (e.g., changing an AND gate to an OR gate, disconnecting a wire).
LEC successfully FAILED this check and pinpointed the exact location of the error, as documented in the fail_cec logs.

5. Static Timing Analysis (STA)
The Tempus tool was used to perform a "fair race" comparison of the three netlists. All three designs were analyzed against the same 15ns medium_c constraint file.
min_area Result: FAILED (Slack: -1.825ns). Proved that optimizing for area made the design too slow.
min_time Result: PASSED (Large Positive Slack). Proved that optimizing for speed made the design easily meet the target.
medium_c Result: PASSED (Near-Zero Slack). Proved the tool built a design that perfectly met the target.

6. Test Insertion (DFT)
The Genus tool was used to perform "scan synthesis" on all three netlist variants. A single scan chain was inserted into each design to make it testable after manufacturing.
Deliverables: The final, scan-inserted netlists (e.g., DFT/medium_c/reports/cac_netlist_medium_c_scan.v) and their corresponding SDC files.


7. Directory Structure (Part1):

/CAC_Project/
│
├── RTL/
│   └── cac.v                 (The golden RTL design file)
│
├── LIB/
│   ├── slow.lib              (Technology timing library)
│   └── slow.v                (Verilog model of the library for LEC)
│
├── TEST_BENCH/
│   ├── Test1/                (Testbench 1, coverage reports)
│   ├── Test2/                (Testbench 2)
│   └── Test3/                (Testbench 3)
│
├── SYNTHESIS/
│   ├── min_area/             (Results for Area-Optimized Synthesis)
│   ├── min_time/             (Results for Timing-Optimized Synthesis)
│   └── medium_c/             (Results for Balanced Synthesis)
│
├── EQUIVALENCE_CHECKING/
│   ├── min_area/             (LEC results for min_area)
│   ├── min_time/             (LEC results for min_time)
│   ├── normalc/              (LEC results for medium_c)
│   └── fail_cec/             (LEC results for failure analysis)
│
├── STA_BEFORE_DFT/
│   ├── min_area/             (Pre-DFT timing analysis for min_area)
│   ├── min_time/             (Pre-DFT timing analysis for min_time)
│   └── medium_c/             (Pre-DFT timing analysis for medium_c)
│
├── DFT/
│   ├── min_area/             (Scan-inserted netlist for min_area)
│   ├── min_time/             (Scan-inserted netlist for min_time)
│   └── medium_c/             (Scan-inserted netlist for medium_c)
│
├── STA_AFTER_DFT/
│   ├── min_area/             (Post-DFT timing analysis for min_area)
│   ├── min_time/             (Post-DFT timing analysis for min_time)
│   └── medium_c/             (Post-DFT timing analysis for medium_c)
│
└── DOC/
    ├── cac_specification.md  (Design specification)
    └── project_conclusion.md (Final conclusion)




VDF Project Part 2: RTL-to-GDSII (Physical Design)

1. Project Objective
This project documents the complete back-end (physical design) flow, taking a pre-synthesized, scan-inserted Verilog netlist of a Collision Avoidance Car (CAC) design to a final GDSII layout.
The primary goal is to use Cadence Innovus to execute the entire physical design flow twice and analyze the trade-offs in Performance, Power, and Area (PPA) based on floorplan density.

Run 1: Low Utilization (0.5)

Run 2: High Utilization (0.8)

This project was completed as part of the VDF (VLSI Design Flow) course, building upon the "front-end" (synthesis, STA, DFT) work from Part I.

2. Tools & Libraries
Physical Design: Cadence Innovus 20.1
Technology: 90nm Generic Standard Cell Library

Inputs:
Timing Library (.lib)
Physical Library (.lef)
Synthesized Netlist (.v)
Timing Constraints (.sdc)
Pin Assignment (.io)

3. Methodology: The Physical Design Flow
The run_low_util.tcl and run_high_util.tcl scripts automate the entire physical design flow as required by the project PDF.
Initialization: The design is loaded with the LEF, netlist, and I/O pin file. A Multi-Mode Multi-Corner (MMMC) view is created to load the SDC timing constraints and .lib files.
Floorplanning: The core die area is defined. This is the key step where utilization is set to 0.5 (for the low-util run) or 0.8 (for the high-util run).
Power Network Design (PND): Power rings (addRing) and stripes (addStripe) for VDD and VSS are created. globalNetConnect and sroute are used to connect the standard cell power pins to this grid.
Placement: All standard cells from the netlist are placed onto the floorplan rows using placeDesign.
Clock-Tree Synthesis (CTS): The ccopt_design command is used to build the clock tree, inserting buffers and inverters to balance the clock path to all flip-flops.
Post-CTS Optimization: optDesign -postCTS is run to fix setup, hold, and DRC violations introduced during CTS.
Routing: routeDesign (NanoRoute) is used to perform global and detailed routing, physically connecting all the signal nets with metal wires.
GDSII Generation: The final streamOut command is used to generate the GDSII file, which is the final layout blueprint for manufacturing.

4. How to Run
Create Directories: Create the IN/, RUN_low_util/, and RUN_high_util/ directories as shown in the structure above.
Copy Files:
Place the slow.lib and .lef files into the IN/lib/ and IN/lef/ directories.
Copy cac_netlist_medium_c_scan.v and cac_constraints_medium_c_scan.sdc from your Part 1 DFT/medium_c/reports/ directory into the IN/netlist/ and IN/sdc/ directories.
Create the cac_pins.io file and place it in both RUN_low_util/ and RUN_high_util/.

5. Directory Structure (Part2):

/
|-- IN/
|   |-- lib/
|   |   -- slow.lib                # Timing library
|   |-- lef/
|   |   -- gsclib090_translated_ref.lef # Physical library
|   |-- netlist/
|   |   -- cac_netlist_medium_c_scan.v  # Netlist from Part 1 (DFT/medium_c/reports/)
|   |-- sdc/
|       -- cac_constraints_medium_c_scan.sdc # SDC from Part 1 (DFT/medium_c/reports/)
|
|-- RUN_low_util/
|   |-- cac_pins.io               # I/O pin placement file
|   |-- db/                       # Saved design databases (.dat)
|   |-- gds/                      # Final GDSII layout (cac_low_util.gds)
|   |-- logs/                     # Tool log files (run_low_util.log)
|   |-- reports/
|   |   |-- pre_placement/
|   |   |-- post_placement/
|   |   |-- post_cts/
|   |   |-- post_routing/
|   |-- scripts/
|       |-- cac_mmmc.view           # MMMC setup for medium constraints
|       |-- run_low_util.tcl        # Main script for 0.5 utilization
|
|-- RUN_high_util/
|   |-- cac_pins.io
|   |-- db/
|   |-- gds/                      # Final GDSII layout (cac_high_util.gds)
|   |-- logs/
|   |-- reports/
|   |-- scripts/
|       |-- cac_mmmc.view
|       |-- run_high_util.tcl       # Main script for 0.8 utilization
|
`-- README_Part2.md
..
