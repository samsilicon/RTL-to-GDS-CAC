# --- SDC for Collision Avoidance Car (Optimal) ---

# 1. Clock Definition
# We are defining a clock with a 15ns period (approx 66MHz).
# This is a moderate clock speed, providing a balance between
# performance and area optimization.
create_clock -name "clk" -period 15 [get_ports clk]

# 2. Input Port Constraints
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
set_output_delay 0.2 -clock [get_clocks clk] [get_ports {acceleration[*]}]
set_output_delay 0.2 -clock [get_clocks clk] [get_ports {steering[*]}]
set_output_delay 0.2 -clock [get_clocks clk] [get_ports {indicators[*]}]
set_output_delay 0.2 -clock [get_clocks clk] [get_ports {current_speed_out[*]}]
set_output_delay 0.2 -clock [get_clocks clk] [get_ports {distance_travelled_out[*]}]
set_output_delay 0.2 -clock [get_clocks clk] [get_ports {total_power_consumed_out[*]}]

# 4. Output Load Constraints
set_load 1 [get_ports {acceleration[*]}]
set_load 1 [get_ports {steering[*]}]
set_load 1 [get_ports {indicators[*]}]
set_load 1 [get_ports {current_speed_out[*]}]
set_load 1 [get_ports {distance_travelled_out[*]}]
set_load 1 [get_ports {total_power_consumed_out[*]}]
