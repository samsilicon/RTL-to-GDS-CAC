`timescale 1ns / 1ps
/*
 * Module: collision_avoidance_car (CEC) - V8 Final Corrected Version
 * Project: VDF RTL-to-GDS Flow
 * Description: Corrected signal types for combinational logic outputs to
 * resolve VLOGPT-86 synthesis errors.
 * Verilog: 2001 Standard
 */
module collision_avoidance_car (
    // Inputs
    input wire clk,
    input wire rst,
    input wire front_obstacle_detected,
    input wire left_obstacle_detected,
    input wire right_obstacle_detected,
    input wire front_obstacle_slow,
    input wire lane_clear_left,
    input wire lane_clear_right,
    input wire destination_reached,
    input wire [1:0] speed_limit_zone,

    // Outputs - These are the final registered outputs
    output reg [1:0] acceleration,
    output reg [1:0] steering,
    output reg [1:0] indicators,
    output reg [7:0] current_speed_out,
    output reg [31:0] distance_travelled_out,
    output reg [31:0] total_power_consumed_out
);

    //--------------------------------------------------------------------------
    //--- CORRECTION: Changed from 'wire' to 'reg' ---
    // Signals assigned in an 'always' block must be of type 'reg'.
    //--------------------------------------------------------------------------
    reg [1:0] next_acceleration;
    reg [1:0] next_steering;
    reg [1:0] next_indicators;

    //--------------------------------------------------------------------------
    // Input Register Stage
    //--------------------------------------------------------------------------
    reg front_obstacle_slow_reg;
    reg lane_clear_left_reg;
    reg lane_clear_right_reg;
    reg destination_reached_reg;
    reg [1:0] speed_limit_zone_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            front_obstacle_slow_reg <= 1'b0;
            lane_clear_left_reg     <= 1'b0;
            lane_clear_right_reg    <= 1'b0;
            destination_reached_reg <= 1'b0;
            speed_limit_zone_reg    <= 2'b0;
        end else begin
            front_obstacle_slow_reg <= front_obstacle_slow;
            lane_clear_left_reg     <= lane_clear_left;
            lane_clear_right_reg    <= lane_clear_right;
            destination_reached_reg <= destination_reached;
            speed_limit_zone_reg    <= speed_limit_zone;
        end
    end

    //--------------------------------------------------------------------------
    // State Machine Definition
    //--------------------------------------------------------------------------
    parameter STATE_WIDTH = 11;
    parameter IDLE                      = 11'b00000000001;
    parameter ACCELERATE_FWD            = 11'b00000000010;
    parameter CRUISE                    = 11'b00000000100;
    parameter DECELERATE                = 11'b00000001000;
    parameter PREPARE_LANE_CHANGE_LEFT  = 11'b00000010000;
    parameter LANE_CHANGE_LEFT          = 11'b00000100000;
    parameter PREPARE_LANE_CHANGE_RIGHT = 11'b00001000000;
    parameter LANE_CHANGE_RIGHT         = 11'b00010000000;
    parameter AVOID_OBSTACLE_STOP       = 11'b00100000000;
    parameter REVERSE                   = 11'b01000000000;
    parameter STOPPED                   = 11'b10000000000;

    reg [STATE_WIDTH-1:0] current_state, next_state;

    //--------------------------------------------------------------------------
    // Sensor Data Pipeline
    //--------------------------------------------------------------------------
    reg [2:0] front_obstacle_history, left_obstacle_history, right_obstacle_history;
    wire persistent_front_obstacle, persistent_left_obstacle, persistent_right_obstacle;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            front_obstacle_history <= 3'b0;
            left_obstacle_history  <= 3'b0;
            right_obstacle_history <= 3'b0;
        end else begin
            front_obstacle_history <= {front_obstacle_history[1:0], front_obstacle_detected};
            left_obstacle_history  <= {left_obstacle_history[1:0], left_obstacle_detected};
            right_obstacle_history <= {right_obstacle_history[1:0], right_obstacle_detected};
        end
    end

    assign persistent_front_obstacle = &front_obstacle_history;
    assign persistent_left_obstacle  = &left_obstacle_history;
    assign persistent_right_obstacle = &right_obstacle_history;

    //--------------------------------------------------------------------------
    // Data-Path Registers and Wires
    //--------------------------------------------------------------------------
    reg [7:0] current_speed;
    wire [7:0] target_speed;
    reg [31:0] distance_travelled;
    wire [7:0] speed_limit;
    wire [7:0] speed_error;
    wire signed [8:0] signed_speed_error;
    wire [7:0] throttle_value;
    wire speed_is_zero;
    wire target_speed_reached;
    reg signed [15:0] integral_error_accumulator;
    wire [15:0] instantaneous_power;
    reg [31:0] total_power_consumed;

    //--------------------------------------------------------------------------
    // Speed Limit Decoder
    //--------------------------------------------------------------------------
    assign speed_limit = (speed_limit_zone_reg == 2'b00) ? 8'd30 :
                         (speed_limit_zone_reg == 2'b01) ? 8'd60 :
                         (speed_limit_zone_reg == 2'b10) ? 8'd100:
                         8'd0;

    //--------------------------------------------------------------------------
    // Throttle Control Logic
    //--------------------------------------------------------------------------
    assign speed_error = (target_speed > current_speed) ? (target_speed - current_speed) : 8'd0;
    assign signed_speed_error = target_speed - current_speed;
    assign throttle_value = (acceleration == 2'b10 && speed_error > 20) ? 8'd150:
                            (acceleration == 2'b10 && speed_error > 5)  ? 8'd100:
                            (acceleration == 2'b10)                     ? 8'd50 :
                            8'd0;

    //--------------------------------------------------------------------------
    // Power Calculation Multiplier
    //--------------------------------------------------------------------------
    assign instantaneous_power = current_speed * throttle_value;

    //--------------------------------------------------------------------------
    // Main Data-Path ALU
    //--------------------------------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_speed <= 8'd0;
            distance_travelled <= 32'd0;
            total_power_consumed <= 32'd0;
            integral_error_accumulator <= 16'd0;
        end else begin
            if (acceleration[1]) begin
                current_speed <= current_speed + (throttle_value >> 4) + (integral_error_accumulator >> 8);
            end else if (!acceleration[1] && !acceleration[0] && current_speed > 0) begin
                current_speed <= current_speed - 2;
            end
            distance_travelled <= distance_travelled + current_speed;
            total_power_consumed <= total_power_consumed + instantaneous_power;
            if (current_state == CRUISE) begin
                integral_error_accumulator <= integral_error_accumulator + signed_speed_error;
            end else begin
                integral_error_accumulator <= 16'd0;
            end
        end
    end
    
    // Comparators
    assign speed_is_zero = (current_speed == 8'd0);
    assign target_speed_reached = (current_speed >= target_speed);

    //--------------------------------------------------------------------------
    // FSM State Register & Logic
    //--------------------------------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) current_state <= IDLE;
        else     current_state <= next_state;
    end

    always @(*) begin
        next_state = current_state;
        case (current_state)
            IDLE:           if (destination_reached_reg) next_state = STOPPED; else if (!persistent_front_obstacle) next_state = ACCELERATE_FWD;
            ACCELERATE_FWD: if (persistent_front_obstacle) next_state = AVOID_OBSTACLE_STOP; else if (front_obstacle_slow_reg) next_state = DECELERATE; else if (destination_reached_reg) next_state = STOPPED; else if (target_speed_reached) next_state = CRUISE;
            CRUISE:         if (persistent_front_obstacle) next_state = AVOID_OBSTACLE_STOP; else if (front_obstacle_slow_reg) next_state = DECELERATE; else if (destination_reached_reg) next_state = STOPPED; else if (!target_speed_reached) next_state = ACCELERATE_FWD;
            DECELERATE:     if (persistent_front_obstacle) next_state = AVOID_OBSTACLE_STOP; else if (lane_clear_left_reg && !persistent_left_obstacle) next_state = PREPARE_LANE_CHANGE_LEFT; else if (lane_clear_right_reg && !persistent_right_obstacle) next_state = PREPARE_LANE_CHANGE_RIGHT; else if (!front_obstacle_slow_reg) next_state = ACCELERATE_FWD;
            PREPARE_LANE_CHANGE_LEFT:  next_state = LANE_CHANGE_LEFT;
            LANE_CHANGE_LEFT:          next_state = ACCELERATE_FWD;
            PREPARE_LANE_CHANGE_RIGHT: next_state = LANE_CHANGE_RIGHT;
            LANE_CHANGE_RIGHT:         next_state = ACCELERATE_FWD;
            AVOID_OBSTACLE_STOP:       if (speed_is_zero && !persistent_front_obstacle) next_state = IDLE;
            STOPPED:                   next_state = STOPPED;
            default: next_state = IDLE;
        endcase
    end

    //--------------------------------------------------------------------------
    // FSM Output Logic (COMBINATIONAL)
    //--------------------------------------------------------------------------
    assign target_speed = 
        (current_state == ACCELERATE_FWD || current_state == LANE_CHANGE_LEFT || current_state == LANE_CHANGE_RIGHT) ? speed_limit :
        (current_state == PREPARE_LANE_CHANGE_LEFT || current_state == PREPARE_LANE_CHANGE_RIGHT) ? current_speed :
        8'd0;

    always @(*) begin
        next_acceleration = 2'b01;
        next_steering = 2'b00;
        next_indicators = 2'b00;

        case (current_state)
            ACCELERATE_FWD: next_acceleration = 2'b10;
            CRUISE:         next_acceleration = 2'b01;
            DECELERATE:     next_acceleration = 2'b00;
            PREPARE_LANE_CHANGE_LEFT:  next_indicators = 2'b01;
            LANE_CHANGE_LEFT:          begin next_acceleration = 2'b10; next_steering = 2'b01; next_indicators = 2'b01; end
            PREPARE_LANE_CHANGE_RIGHT: next_indicators = 2'b10;
            LANE_CHANGE_RIGHT:         begin next_acceleration = 2'b10; next_steering = 2'b10; next_indicators = 2'b10; end
            AVOID_OBSTACLE_STOP:       next_acceleration = 2'b00;
            STOPPED:                   next_acceleration = 2'b00;
        endcase
    end

    //--------------------------------------------------------------------------
    // Output Register Stage
    //--------------------------------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            acceleration <= 2'b01;
            steering     <= 2'b00;
            indicators   <= 2'b00;
            current_speed_out <= 8'd0;
            distance_travelled_out <= 32'd0;
            total_power_consumed_out <= 32'd0;
        end else begin
            acceleration <= next_acceleration;
            steering     <= next_steering;
            indicators   <= next_indicators;
            current_speed_out <= current_speed;
            distance_travelled_out <= distance_travelled;
            total_power_consumed_out <= total_power_consumed;
        end
    end

endmodule
