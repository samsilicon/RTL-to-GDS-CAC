// SDC for Collision Avoidance Car (Minimum Time - Final Calculated for Slight Negative Slack)

// 1. Keep the aggressive clock period.
create_clock -name "clk" -period 4.5 [get_ports clk]

// 2. Keep realistic clock characteristics.
set_clock_transition -rise 0.4 [get_clocks clk]
set_clock_transition -fall 0.4 [get_clocks clk]
set_clock_latency 0.25 [get_clocks clk]
set_clock_uncertainty -setup 0.4 [get_clocks clk]

// 3. Apply calculated I/O pressure to achieve a target of ~-5ps slack.
set_input_delay 2.427 -clock [get_clocks clk] [get_ports rst]
set_input_delay 2.427 -clock [get_clocks clk] [get_ports front_obstacle_detected]
set_input_delay 2.427 -clock [get_clocks clk] [get_ports left_obstacle_detected]
set_input_delay 2.427 -clock [get_clocks clk] [get_ports right_obstacle_detected]
set_input_delay 2.427 -clock [get_clocks clk] [get_ports front_obstacle_slow]
set_input_delay 2.427 -clock [get_clocks clk] [get_ports lane_clear_left]
set_input_delay 2.427 -clock [get_clocks clk] [get_ports lane_clear_right]
set_input_delay 2.427 -clock [get_clocks clk] [get_ports destination_reached]
set_input_delay 2.427 -clock [get_clocks clk] [get_ports {speed_limit_zone[*]}]

set_output_delay 2.427 -clock [get_clocks clk] [get_ports {acceleration[*]}]
set_output_delay 2.427 -clock [get_clocks clk] [get_ports {steering[*]}]
set_output_delay 2.427 -clock [get_clocks clk] [get_ports {indicators[*]}]
set_output_delay 2.427 -clock [get_clocks clk] [get_ports {current_speed_out[*]}]
set_output_delay 2.427 -clock [get_clocks clk] [get_ports {distance_travelled_out[*]}]
set_output_delay 2.427 -clock [get_clocks clk] [get_ports {total_power_consumed_out[*]}]

// 4. Maintain a hostile environment for realism.
set_driving_cell -lib_cell BUFX1 [all_inputs]
set_load 4 [all_outputs]
