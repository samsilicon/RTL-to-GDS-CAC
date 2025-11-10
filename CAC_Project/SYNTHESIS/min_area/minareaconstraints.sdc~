# --- SDC for Collision Avoidance Car (Minimum Area) ---

# 1. Clock Definition
# We are defining a clock with a 30ns period (approx 33MHz).
# This is a slow clock, which gives the tool flexibility to use smaller,
# slower gates to optimize for area.
create_clock -name "clk" -period 30 [get_ports clk]

# 2. Input Port Constraints
# This tells the tool how much time data takes to arrive at the chip's input pins
# relative to the clock edge. We'll use a standard value for all inputs.
set_input_delay 0.4 -clock [get_clocks clk] [get_ports rst]
set_input_delay 0.4 -clock [get_clocks clk] [get_ports front_obstacle_detected]
set_input_delay 0.4 -clock [get_clocks clk] [get_ports left_obstacle_detected]
set_input_delay 0.4 -clock [get_clocks clk] [get_ports right_obstacle_detected]
set_input_delay 0.4 -clock [get_clocks clk] [get_ports front_obstacle_slow]
set_input_delay 0.4 -clock [get_clocks clk] [get_ports lane_clear_left]
set_input_delay 0.4 -clock [get_clocks clk] [get_ports lane_clear_right]
set_input_delay 0.4 -clock [get_clocks clk] [get_ports destination_reached]
set_input_delay 0.4 -clock [get_clocks clk] [get_ports {speed_limit_zone[*]}]

# 3. Output Port Constraints
# This tells the tool how much time the signal has to be stable at the output
# pin before the next external component captures it.
set_output_delay 0.2 -clock [get_clocks clk] [get_ports {acceleration[*]}]
set_output_delay 0.2 -clock [get_clocks clk] [get_ports {steering[*]}]
set_output_delay 0.2 -clock [get_clocks clk] [get_ports {indicators[*]}]
set_output_delay 0.2 -clock [get_clocks clk] [get_ports {current_speed_out[*]}]
set_output_delay 0.2 -clock [get_clocks clk] [get_ports {distance_travelled_out[*]}]
set_output_delay 0.2 -clock [get_clocks clk] [get_ports {total_power_consumed_out[*]}]

# 4. Output Load Constraints
# This defines the external capacitance on our output ports. We'll assume
# each output drives a standard load.
set_load 1 [get_ports {acceleration[*]}]
set_load 1 [get_ports {steering[*]}]
set_load 1 [get_ports {indicators[*]}]
set_load 1 [get_ports {current_speed_out[*]}]
set_load 1 [get_ports {distance_travelled_out[*]}]
set_load 1 [get_ports {total_power_consumed_out[*]}]
