# --- My Collision Avoidance Car Pin File ---
# E = East, N = North, W = West, S = South
#
# --- Inputs ---
Pin: clk E
Pin: rst E
Pin: front_obstacle_detected N
Pin: left_obstacle_detected W
Pin: right_obstacle_detected E
Pin: front_obstacle_slow N
Pin: lane_clear_left W
Pin: lane_clear_right E
Pin: destination_reached N
Pin: speed_limit_zone[0] N
Pin: speed_limit_zone[1] N

# --- Outputs ---
Pin: acceleration[0] S
Pin: acceleration[1] S
Pin: steering[0] S
Pin: steering[1] S
Pin: indicators[0] S
Pin: indicators[1] S
Pin: current_speed_out S
Pin: distance_travelled_out S
Pin: total_power_consumed_out S

# --- DFT Pins ---
Pin: scan_en E
Pin: test_mode E
Pin: DFT_sdi_1 E
Pin: DFT_sdo_1 W
