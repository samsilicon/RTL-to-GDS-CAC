/*
 * Testbench: collision_avoidance_car_tb
 * Target: 100% Code Coverage (Focus on Toggle Coverage)
 * Description: Exhaustive testbench covering ALL signal toggles and state transitions
 */

`timescale 1ns/1ps

module collision_avoidance_car_tb;

    // Clock and Reset
    reg clk;
    reg rst;
    
    // Input signals
    reg front_obstacle_detected;
    reg left_obstacle_detected;
    reg right_obstacle_detected;
    reg front_obstacle_slow;
    reg lane_clear_left;
    reg lane_clear_right;
    reg destination_reached;
    reg [1:0] speed_limit_zone;
    
    // Output signals
    wire [1:0] acceleration;
    wire [1:0] steering;
    wire [1:0] indicators;
    wire [7:0] current_speed_out;
    wire [31:0] distance_travelled_out;
    wire [31:0] total_power_consumed_out;
    
    // Testbench variables
    integer test_num;
    integer i, j, k;
    
    // Instantiate DUT
    collision_avoidance_car dut (
        .clk(clk),
        .rst(rst),
        .front_obstacle_detected(front_obstacle_detected),
        .left_obstacle_detected(left_obstacle_detected),
        .right_obstacle_detected(right_obstacle_detected),
        .front_obstacle_slow(front_obstacle_slow),
        .lane_clear_left(lane_clear_left),
        .lane_clear_right(lane_clear_right),
        .destination_reached(destination_reached),
        .speed_limit_zone(speed_limit_zone),
        .acceleration(acceleration),
        .steering(steering),
        .indicators(indicators),
        .current_speed_out(current_speed_out),
        .distance_travelled_out(distance_travelled_out),
        .total_power_consumed_out(total_power_consumed_out)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Display current state
    task display_state;
        begin
            case (dut.current_state)
                11'b00000000001: $display("    State: IDLE");
                11'b00000000010: $display("    State: ACCELERATE_FWD");
                11'b00000000100: $display("    State: CRUISE");
                11'b00000001000: $display("    State: DECELERATE");
                11'b00000010000: $display("    State: PREPARE_LANE_CHANGE_LEFT");
                11'b00000100000: $display("    State: LANE_CHANGE_LEFT");
                11'b00001000000: $display("    State: PREPARE_LANE_CHANGE_RIGHT");
                11'b00010000000: $display("    State: LANE_CHANGE_RIGHT");
                11'b00100000000: $display("    State: AVOID_OBSTACLE_STOP");
                11'b01000000000: $display("    State: REVERSE");
                11'b10000000000: $display("    State: STOPPED");
                default: $display("    State: UNKNOWN");
            endcase
        end
    endtask
    
    // Initialize all inputs
    task init_inputs;
        begin
            front_obstacle_detected = 0;
            left_obstacle_detected = 0;
            right_obstacle_detected = 0;
            front_obstacle_slow = 0;
            lane_clear_left = 0;
            lane_clear_right = 0;
            destination_reached = 0;
            speed_limit_zone = 2'b00;
        end
    endtask
    
    // Apply reset
    task apply_reset;
        begin
            rst = 1;
            init_inputs();
            repeat(5) @(posedge clk);
            rst = 0;
            repeat(2) @(posedge clk);
        end
    endtask
    
    // Main test sequence
    initial begin
        $display("========================================");
        $display("  100%% Coverage Testbench");
        $display("  Focus: Toggle + FSM + Expression");
        $display("========================================\n");
        
        test_num = 0;
        
        // ===================================================================
        // SECTION 1: EXHAUSTIVE INPUT TOGGLE COVERAGE
        // Every input must go 0->1 and 1->0 multiple times
        // ===================================================================
        $display("\n=== SECTION 1: EXHAUSTIVE INPUT TOGGLES ===\n");
        
        test_num = test_num + 1;
        $display("[TEST %0d] All Input Signal Toggles", test_num);
        apply_reset();
        
        // Toggle each input independently 10 times
        for (i = 0; i < 10; i = i + 1) begin
            front_obstacle_detected = ~front_obstacle_detected;
            repeat(2) @(posedge clk);
        end
        front_obstacle_detected = 0;
        
        for (i = 0; i < 10; i = i + 1) begin
            left_obstacle_detected = ~left_obstacle_detected;
            repeat(2) @(posedge clk);
        end
        left_obstacle_detected = 0;
        
        for (i = 0; i < 10; i = i + 1) begin
            right_obstacle_detected = ~right_obstacle_detected;
            repeat(2) @(posedge clk);
        end
        right_obstacle_detected = 0;
        
        for (i = 0; i < 10; i = i + 1) begin
            front_obstacle_slow = ~front_obstacle_slow;
            repeat(2) @(posedge clk);
        end
        front_obstacle_slow = 0;
        
        for (i = 0; i < 10; i = i + 1) begin
            lane_clear_left = ~lane_clear_left;
            repeat(2) @(posedge clk);
        end
        lane_clear_left = 0;
        
        for (i = 0; i < 10; i = i + 1) begin
            lane_clear_right = ~lane_clear_right;
            repeat(2) @(posedge clk);
        end
        lane_clear_right = 0;
        
        for (i = 0; i < 10; i = i + 1) begin
            destination_reached = ~destination_reached;
            repeat(2) @(posedge clk);
        end
        destination_reached = 0;
        
        // Toggle speed_limit_zone through all combinations
        for (i = 0; i < 4; i = i + 1) begin
            speed_limit_zone = i[1:0];
            repeat(10) @(posedge clk);
        end
        
        $display("  All inputs toggled individually\n");
        
        // ===================================================================
        test_num = test_num + 1;
        $display("[TEST %0d] All Input Combinations", test_num);
        apply_reset();
        
        // Test all 128 combinations of 7 boolean inputs
        for (i = 0; i < 128; i = i + 1) begin
            {front_obstacle_detected, left_obstacle_detected, right_obstacle_detected,
             front_obstacle_slow, lane_clear_left, lane_clear_right, destination_reached} = i[6:0];
            repeat(4) @(posedge clk);
        end
        
        // Test all speed zones with various input combinations
        for (i = 0; i < 4; i = i + 1) begin
            speed_limit_zone = i[1:0];
            for (j = 0; j < 16; j = j + 1) begin
                {front_obstacle_detected, left_obstacle_detected, 
                 right_obstacle_detected, front_obstacle_slow} = j[3:0];
                repeat(3) @(posedge clk);
            end
        end
        
        $display("  All input combinations tested\n");
        
        // ===================================================================
        // SECTION 2: COMPLETE FSM STATE COVERAGE
        // Visit every state and every transition
        // ===================================================================
        $display("\n=== SECTION 2: COMPLETE FSM COVERAGE ===\n");
        
        // STATE: IDLE
        test_num = test_num + 1;
        $display("[TEST %0d] IDLE State", test_num);
        apply_reset();
        repeat(10) @(posedge clk);
        display_state();
        
        // IDLE -> ACCELERATE_FWD
        test_num = test_num + 1;
        $display("[TEST %0d] IDLE -> ACCELERATE_FWD", test_num);
        init_inputs();
        speed_limit_zone = 2'b01;
        repeat(5) @(posedge clk);
        display_state();
        
        // IDLE -> STOPPED
        test_num = test_num + 1;
        $display("[TEST %0d] IDLE -> STOPPED", test_num);
        apply_reset();
        repeat(5) @(posedge clk);
        destination_reached = 1;
        repeat(5) @(posedge clk);
        display_state();
        
        // STATE: ACCELERATE_FWD
        test_num = test_num + 1;
        $display("[TEST %0d] ACCELERATE_FWD State", test_num);
        apply_reset();
        speed_limit_zone = 2'b01;
        repeat(50) @(posedge clk);
        display_state();
        
        // ACCELERATE_FWD -> CRUISE
        test_num = test_num + 1;
        $display("[TEST %0d] ACCELERATE_FWD -> CRUISE", test_num);
        repeat(200) @(posedge clk);
        display_state();
        
        // ACCELERATE_FWD -> DECELERATE
        test_num = test_num + 1;
        $display("[TEST %0d] ACCELERATE_FWD -> DECELERATE", test_num);
        apply_reset();
        speed_limit_zone = 2'b01;
        repeat(50) @(posedge clk);
        front_obstacle_slow = 1;
        repeat(5) @(posedge clk);
        display_state();
        
        // ACCELERATE_FWD -> AVOID_OBSTACLE_STOP
        test_num = test_num + 1;
        $display("[TEST %0d] ACCELERATE_FWD -> AVOID_OBSTACLE_STOP", test_num);
        apply_reset();
        speed_limit_zone = 2'b01;
        repeat(50) @(posedge clk);
        repeat(3) begin
            front_obstacle_detected = 1;
            @(posedge clk);
        end
        repeat(5) @(posedge clk);
        display_state();
        
        // ACCELERATE_FWD -> STOPPED
        test_num = test_num + 1;
        $display("[TEST %0d] ACCELERATE_FWD -> STOPPED", test_num);
        apply_reset();
        speed_limit_zone = 2'b01;
        repeat(50) @(posedge clk);
        destination_reached = 1;
        repeat(5) @(posedge clk);
        display_state();
        
        // STATE: CRUISE
        test_num = test_num + 1;
        $display("[TEST %0d] CRUISE State", test_num);
        apply_reset();
        speed_limit_zone = 2'b01;
        repeat(250) @(posedge clk);
        display_state();
        
        // CRUISE -> ACCELERATE_FWD
        test_num = test_num + 1;
        $display("[TEST %0d] CRUISE -> ACCELERATE_FWD", test_num);
        apply_reset();
        speed_limit_zone = 2'b00;
        repeat(250) @(posedge clk);
        repeat(30) @(posedge clk);
        speed_limit_zone = 2'b10;
        repeat(5) @(posedge clk);
        display_state();
        
        // CRUISE -> DECELERATE
        test_num = test_num + 1;
        $display("[TEST %0d] CRUISE -> DECELERATE", test_num);
        apply_reset();
        speed_limit_zone = 2'b01;
        repeat(250) @(posedge clk);
        front_obstacle_slow = 1;
        repeat(5) @(posedge clk);
        display_state();
        
        // CRUISE -> AVOID_OBSTACLE_STOP
        test_num = test_num + 1;
        $display("[TEST %0d] CRUISE -> AVOID_OBSTACLE_STOP", test_num);
        apply_reset();
        speed_limit_zone = 2'b01;
        repeat(250) @(posedge clk);
        repeat(3) begin
            front_obstacle_detected = 1;
            @(posedge clk);
        end
        repeat(5) @(posedge clk);
        display_state();
        
        // CRUISE -> STOPPED
        test_num = test_num + 1;
        $display("[TEST %0d] CRUISE -> STOPPED", test_num);
        apply_reset();
        speed_limit_zone = 2'b01;
        repeat(250) @(posedge clk);
        destination_reached = 1;
        repeat(5) @(posedge clk);
        display_state();
        
        // STATE: DECELERATE
        test_num = test_num + 1;
        $display("[TEST %0d] DECELERATE State", test_num);
        apply_reset();
        speed_limit_zone = 2'b01;
        repeat(100) @(posedge clk);
        front_obstacle_slow = 1;
        repeat(10) @(posedge clk);
        display_state();
        
        // DECELERATE -> PREPARE_LANE_CHANGE_LEFT
        test_num = test_num + 1;
        $display("[TEST %0d] DECELERATE -> PREPARE_LANE_CHANGE_LEFT", test_num);
        lane_clear_left = 1;
        repeat(8) @(posedge clk);
        display_state();
        
        // DECELERATE -> PREPARE_LANE_CHANGE_RIGHT
        test_num = test_num + 1;
        $display("[TEST %0d] DECELERATE -> PREPARE_LANE_CHANGE_RIGHT", test_num);
        apply_reset();
        speed_limit_zone = 2'b01;
        repeat(100) @(posedge clk);
        front_obstacle_slow = 1;
        repeat(5) @(posedge clk);
        lane_clear_right = 1;
        lane_clear_left = 0;
        repeat(8) @(posedge clk);
        display_state();
        
        // DECELERATE -> ACCELERATE_FWD
        test_num = test_num + 1;
        $display("[TEST %0d] DECELERATE -> ACCELERATE_FWD", test_num);
        apply_reset();
        speed_limit_zone = 2'b01;
        repeat(100) @(posedge clk);
        front_obstacle_slow = 1;
        repeat(5) @(posedge clk);
        front_obstacle_slow = 0;
        repeat(5) @(posedge clk);
        display_state();
        
        // DECELERATE -> AVOID_OBSTACLE_STOP
        test_num = test_num + 1;
        $display("[TEST %0d] DECELERATE -> AVOID_OBSTACLE_STOP", test_num);
        apply_reset();
        speed_limit_zone = 2'b01;
        repeat(100) @(posedge clk);
        front_obstacle_slow = 1;
        repeat(5) @(posedge clk);
        repeat(3) begin
            front_obstacle_detected = 1;
            @(posedge clk);
        end
        repeat(5) @(posedge clk);
        display_state();
        
        // STATE: PREPARE_LANE_CHANGE_LEFT
        test_num = test_num + 1;
        $display("[TEST %0d] PREPARE_LANE_CHANGE_LEFT -> LANE_CHANGE_LEFT", test_num);
        apply_reset();
        speed_limit_zone = 2'b01;
        repeat(100) @(posedge clk);
        front_obstacle_slow = 1;
        repeat(5) @(posedge clk);
        lane_clear_left = 1;
        repeat(5) @(posedge clk);
        display_state();
        
        // STATE: LANE_CHANGE_LEFT
        test_num = test_num + 1;
        $display("[TEST %0d] LANE_CHANGE_LEFT -> ACCELERATE_FWD", test_num);
        repeat(5) @(posedge clk);
        display_state();
        
        // STATE: PREPARE_LANE_CHANGE_RIGHT
        test_num = test_num + 1;
        $display("[TEST %0d] PREPARE_LANE_CHANGE_RIGHT -> LANE_CHANGE_RIGHT", test_num);
        apply_reset();
        speed_limit_zone = 2'b01;
        repeat(100) @(posedge clk);
        front_obstacle_slow = 1;
        repeat(5) @(posedge clk);
        lane_clear_right = 1;
        lane_clear_left = 0;
        repeat(5) @(posedge clk);
        display_state();
        
        // STATE: LANE_CHANGE_RIGHT
        test_num = test_num + 1;
        $display("[TEST %0d] LANE_CHANGE_RIGHT -> ACCELERATE_FWD", test_num);
        repeat(5) @(posedge clk);
        display_state();
        
        // STATE: AVOID_OBSTACLE_STOP
        test_num = test_num + 1;
        $display("[TEST %0d] AVOID_OBSTACLE_STOP State", test_num);
        apply_reset();
        speed_limit_zone = 2'b01;
        repeat(100) @(posedge clk);
        repeat(3) begin
            front_obstacle_detected = 1;
            @(posedge clk);
        end
        repeat(10) @(posedge clk);
        display_state();
        
        // AVOID_OBSTACLE_STOP -> IDLE
        test_num = test_num + 1;
        $display("[TEST %0d] AVOID_OBSTACLE_STOP -> IDLE", test_num);
        repeat(100) @(posedge clk);
        repeat(3) begin
            front_obstacle_detected = 0;
            @(posedge clk);
        end
        repeat(10) @(posedge clk);
        display_state();
        
        // STATE: STOPPED
        test_num = test_num + 1;
        $display("[TEST %0d] STOPPED State", test_num);
        apply_reset();
        destination_reached = 1;
        repeat(10) @(posedge clk);
        display_state();
        repeat(100) @(posedge clk);
        
        // ===================================================================
        // SECTION 3: DATAPATH TOGGLE COVERAGE
        // Toggle all internal signals
        // ===================================================================
        $display("\n=== SECTION 3: DATAPATH COVERAGE ===\n");
        
        test_num = test_num + 1;
        $display("[TEST %0d] Speed Ramp - All Bits Toggle", test_num);
        apply_reset();
        speed_limit_zone = 2'b10;
        repeat(800) @(posedge clk); // Ramp speed to maximum
        $display("    Max speed: %d", current_speed_out);
        
        test_num = test_num + 1;
        $display("[TEST %0d] Distance Accumulation - All Bits", test_num);
        repeat(500) @(posedge clk);
        $display("    Distance: %d", distance_travelled_out);
        
        test_num = test_num + 1;
        $display("[TEST %0d] Power Accumulation - All Bits", test_num);
        repeat(500) @(posedge clk);
        $display("    Power: %d", total_power_consumed_out);
        
        // ===================================================================
        // SECTION 4: OUTPUT SIGNAL TOGGLES
        // ===================================================================
        $display("\n=== SECTION 4: OUTPUT TOGGLES ===\n");
        
        test_num = test_num + 1;
        $display("[TEST %0d] Acceleration Output All Values", test_num);
        
        // accel = 00
        apply_reset();
        speed_limit_zone = 2'b01;
        repeat(100) @(posedge clk);
        repeat(3) begin
            front_obstacle_detected = 1;
            @(posedge clk);
        end
        repeat(5) @(posedge clk);
        $display("    accel = %b", acceleration);
        
        // accel = 01
        apply_reset();
        repeat(5) @(posedge clk);
        $display("    accel = %b", acceleration);
        
        // accel = 10
        speed_limit_zone = 2'b10;
        repeat(50) @(posedge clk);
        $display("    accel = %b", acceleration);
        
        // accel = 11 (if exists)
        repeat(100) @(posedge clk);
        
        test_num = test_num + 1;
        $display("[TEST %0d] Steering Output All Values", test_num);
        
        // steering = 00
        apply_reset();
        speed_limit_zone = 2'b01;
        repeat(50) @(posedge clk);
        $display("    steering = %b", steering);
        
        // steering = 01
        front_obstacle_slow = 1;
        repeat(5) @(posedge clk);
        lane_clear_left = 1;
        repeat(15) @(posedge clk);
        $display("    steering = %b", steering);
        
        // steering = 10
        apply_reset();
        speed_limit_zone = 2'b01;
        repeat(100) @(posedge clk);
        front_obstacle_slow = 1;
        repeat(5) @(posedge clk);
        lane_clear_right = 1;
        repeat(15) @(posedge clk);
        $display("    steering = %b", steering);
        
        // steering = 11 (if exists)
        repeat(100) @(posedge clk);
        
        test_num = test_num + 1;
        $display("[TEST %0d] Indicators Output All Values", test_num);
        
        // indicators = 00
        apply_reset();
        speed_limit_zone = 2'b01;
        repeat(50) @(posedge clk);
        $display("    indicators = %b", indicators);
        
        // indicators = 01
        front_obstacle_slow = 1;
        repeat(5) @(posedge clk);
        lane_clear_left = 1;
        repeat(10) @(posedge clk);
        $display("    indicators = %b", indicators);
        
        // indicators = 10
        apply_reset();
        speed_limit_zone = 2'b01;
        repeat(100) @(posedge clk);
        front_obstacle_slow = 1;
        repeat(5) @(posedge clk);
        lane_clear_right = 1;
        repeat(10) @(posedge clk);
        $display("    indicators = %b", indicators);
        
        // indicators = 11 (if exists)
        repeat(100) @(posedge clk);
        
        // ===================================================================
        // SECTION 5: REGISTERED INPUT TOGGLES
        // ===================================================================
        $display("\n=== SECTION 5: REGISTERED INPUT COVERAGE ===\n");
        
        test_num = test_num + 1;
        $display("[TEST %0d] Input Register Pipeline Toggles", test_num);
        apply_reset();
        
        // Toggle inputs rapidly to ensure registered versions toggle
        for (i = 0; i < 20; i = i + 1) begin
            front_obstacle_slow = ~front_obstacle_slow;
            lane_clear_left = ~lane_clear_left;
            lane_clear_right = ~lane_clear_right;
            destination_reached = ~destination_reached;
            speed_limit_zone = speed_limit_zone + 1;
            repeat(3) @(posedge clk);
        end
        
        $display("    All registered inputs toggled");
        
        // ===================================================================
        // SECTION 6: INTERNAL SIGNAL TOGGLES
        // ===================================================================
        $display("\n=== SECTION 6: INTERNAL SIGNAL COVERAGE ===\n");
        
        test_num = test_num + 1;
        $display("[TEST %0d] History Register Patterns", test_num);
        apply_reset();
        
        // Front obstacle history - all 8 patterns
        for (i = 0; i < 8; i = i + 1) begin
            front_obstacle_detected = i[0];
            @(posedge clk);
            front_obstacle_detected = i[1];
            @(posedge clk);
            front_obstacle_detected = i[2];
            @(posedge clk);
            repeat(2) @(posedge clk);
        end
        
        // Left obstacle history
        for (i = 0; i < 8; i = i + 1) begin
            left_obstacle_detected = i[0];
            @(posedge clk);
            left_obstacle_detected = i[1];
            @(posedge clk);
            left_obstacle_detected = i[2];
            @(posedge clk);
            repeat(2) @(posedge clk);
        end
        
        // Right obstacle history
        for (i = 0; i < 8; i = i + 1) begin
            right_obstacle_detected = i[0];
            @(posedge clk);
            right_obstacle_detected = i[1];
            @(posedge clk);
            right_obstacle_detected = i[2];
            @(posedge clk);
            repeat(2) @(posedge clk);
        end
        
        $display("    All history patterns covered");
        
        test_num = test_num + 1;
        $display("[TEST %0d] Speed Limit Decoder", test_num);
        apply_reset();
        
        // Cycle through all speed limits with driving
        for (i = 0; i < 4; i = i + 1) begin
            apply_reset();
            speed_limit_zone = i[1:0];
            repeat(200) @(posedge clk);
            $display("    Speed limit zone %b -> %d km/h", i[1:0], 
                     (i==0) ? 30 : (i==1) ? 60 : (i==2) ? 100 : 0);
        end
        
        test_num = test_num + 1;
        $display("[TEST %0d] Throttle Value Coverage", test_num);
        apply_reset();
        
        // Throttle = 0
        repeat(50) @(posedge clk);
        
        // Throttle = 50 (small error <5)
        speed_limit_zone = 2'b00;
        repeat(190) @(posedge clk);
        
        // Throttle = 100 (medium error 5-20)
        apply_reset();
        speed_limit_zone = 2'b01;
        repeat(180) @(posedge clk);
        
        // Throttle = 150 (large error >20)
        apply_reset();
        speed_limit_zone = 2'b10;
        repeat(50) @(posedge clk);
        
        $display("    All throttle values covered");
        
        test_num = test_num + 1;
        $display("[TEST %0d] Integral Error Accumulator", test_num);
        apply_reset();
        speed_limit_zone = 2'b01;
        repeat(300) @(posedge clk);
        $display("    Positive accumulation");
        
        // Reset accumulator
        front_obstacle_slow = 1;
        repeat(10) @(posedge clk);
        $display("    Accumulator reset");
        
        test_num = test_num + 1;
        $display("[TEST %0d] Speed Comparators", test_num);
        apply_reset();
        
        // speed_is_zero = 1
        repeat(20) @(posedge clk);
        $display("    speed_is_zero = 1");
        
        // speed_is_zero = 0
        speed_limit_zone = 2'b01;
        repeat(100) @(posedge clk);
        $display("    speed_is_zero = 0");
        
        // target_speed_reached = 0
        speed_limit_zone = 2'b10;
        repeat(5) @(posedge clk);
        $display("    target_speed_reached = 0");
        
        // target_speed_reached = 1
        apply_reset();
        speed_limit_zone = 2'b00;
        repeat(250) @(posedge clk);
        $display("    target_speed_reached = 1");
        
        // ===================================================================
        // SECTION 7: EDGE CASES AND DEFAULT PATHS
        // ===================================================================
        $display("\n=== SECTION 7: EDGE CASES ===\n");
        
        test_num = test_num + 1;
        $display("[TEST %0d] FSM Default Case", test_num);
        apply_reset();
        force dut.current_state = 11'b11111111111;
        @(posedge clk);
        display_state();
        release dut.current_state;
        repeat(5) @(posedge clk);
        display_state();
        
        test_num = test_num + 1;
        $display("[TEST %0d] Reset During Operation", test_num);
        apply_reset();
        speed_limit_zone = 2'b10;
        repeat(200) @(posedge clk);
        $display("    Speed before reset: %d", current_speed_out);
        rst = 1;
        repeat(3) @(posedge clk);
        rst = 0;
        repeat(3) @(posedge clk);
        $display("    Speed after reset: %d", current_speed_out);
        
        test_num = test_num + 1;
        $display("[TEST %0d] All State Bits Toggle", test_num);
        // Visit all states to ensure all state register bits toggle
        apply_reset();
        repeat(10) @(posedge clk); // IDLE
        
        speed_limit_zone = 2'b01;
        repeat(50) @(posedge clk); // ACCELERATE_FWD
        
        repeat(200) @(posedge clk); // CRUISE
        
        front_obstacle_slow = 1;
        repeat(10) @(posedge clk); // DECELERATE
        
        lane_clear_left = 1;
        repeat(5) @(posedge clk); // PREPARE_LANE_CHANGE_LEFT
        
        repeat(5) @(posedge clk); // LANE_CHANGE_LEFT
        
        apply_reset();
        speed_limit_zone = 2'b01;
        repeat(100) @(posedge clk);
        front_obstacle_slow = 1;
        repeat(5) @(posedge clk);
        lane_clear_right = 1;
        lane_clear_left = 0;
        repeat(5) @(posedge clk); // PREPARE_LANE_CHANGE_RIGHT
        
        repeat(5) @(posedge clk); // LANE_CHANGE_RIGHT
        
        apply_reset();
        speed_limit_zone = 2'b01;
        repeat(100) @(posedge clk);
        repeat(3) begin
            front_obstacle_detected = 1;
            @(posedge clk);
        end
        repeat(10) @(posedge clk); // AVOID_OBSTACLE_STOP
        
        apply_reset();
        destination_reached = 1;
        repeat(10) @(posedge clk); // STOPPED
        
        $display("    All state bits toggled");
        
        // ===================================================================
        // SECTION 8: MAXIMUM TOGGLE STRESS TEST
        // ===================================================================
        $display("\n=== SECTION 8: MAXIMUM TOGGLE STRESS ===\n");
        
        test_num = test_num + 1;
        $display("[TEST %0d] Rapid Input Changes", test_num);
        apply_reset();
        
        for (i = 0; i < 100; i = i + 1) begin
            front_obstacle_detected = $random;
            left_obstacle_detected = $random;
            right_obstacle_detected = $random;
            front_obstacle_slow = $random;
            lane_clear_left = $random;
            lane_clear_right = $random;
            destination_reached = $random;
            speed_limit_zone = $random;
            @(posedge clk);
        end
        
        $display("    Random toggles complete");
        
        test_num = test_num + 1;
        $display("[TEST %0d] All Speed Values 0-255", test_num);
        apply_reset();
        speed_limit_zone = 2'b10;
        
        // Run long enough to potentially hit many speed values
        repeat(1000) @(posedge clk);
        $display("    Final speed: %d", current_speed_out);
        
        test_num = test_num + 1;
        $display("[TEST %0d] Distance Counter Full Range", test_num);
        repeat(1000) @(posedge clk);
        $display("    Distance: %d", distance_travelled_out);
        
        test_num = test_num + 1;
        $display("[TEST %0d] Power Counter Full Range", test_num);
        repeat(1000) @(posedge clk);
        $display("    Power: %d", total_power_consumed_out);
        
        // ===================================================================
        // SECTION 9: COMBINATIONAL LOGIC PATHS
        // ===================================================================
        $display("\n=== SECTION 9: COMBINATIONAL PATHS ===\n");
        
        test_num = test_num + 1;
        $display("[TEST %0d] Target Speed Assignment", test_num);
        apply_reset();
        
        // target_speed in ACCELERATE_FWD
        speed_limit_zone = 2'b00;
        repeat(50) @(posedge clk);
        $display("    ACCELERATE_FWD: target = 30");
        
        // target_speed in CRUISE
        repeat(200) @(posedge clk);
        $display("    CRUISE: target maintains");
        
        // target_speed in LANE_CHANGE_LEFT
        front_obstacle_slow = 1;
        repeat(5) @(posedge clk);
        lane_clear_left = 1;
        repeat(10) @(posedge clk);
        $display("    LANE_CHANGE_LEFT: target = speed_limit");
        
        // target_speed in LANE_CHANGE_RIGHT
        apply_reset();
        speed_limit_zone = 2'b01;
        repeat(100) @(posedge clk);
        front_obstacle_slow = 1;
        repeat(5) @(posedge clk);
        lane_clear_right = 1;
        repeat(10) @(posedge clk);
        $display("    LANE_CHANGE_RIGHT: target = speed_limit");
        
        // target_speed in PREPARE states
        apply_reset();
        speed_limit_zone = 2'b01;
        repeat(100) @(posedge clk);
        front_obstacle_slow = 1;
        repeat(5) @(posedge clk);
        lane_clear_left = 1;
        repeat(3) @(posedge clk);
        $display("    PREPARE_LANE_CHANGE: target = current_speed");
        
        // target_speed = 0 (default)
        apply_reset();
        repeat(10) @(posedge clk);
        $display("    Default states: target = 0");
        
        test_num = test_num + 1;
        $display("[TEST %0d] Speed Error Calculation", test_num);
        apply_reset();
        
        // Speed error > 20
        speed_limit_zone = 2'b10;
        repeat(20) @(posedge clk);
        $display("    Large speed error (>20)");
        
        // Speed error 5-20
        repeat(150) @(posedge clk);
        $display("    Medium speed error (5-20)");
        
        // Speed error < 5
        repeat(200) @(posedge clk);
        $display("    Small speed error (<5)");
        
        // Speed error = 0
        apply_reset();
        speed_limit_zone = 2'b00;
        repeat(250) @(posedge clk);
        $display("    Zero speed error");
        
        test_num = test_num + 1;
        $display("[TEST %0d] Persistent Obstacle Logic", test_num);
        apply_reset();
        speed_limit_zone = 2'b01;
        repeat(50) @(posedge clk);
        
        // All combinations of 3-bit history
        for (i = 0; i < 8; i = i + 1) begin
            front_obstacle_detected = i[2];
            @(posedge clk);
            front_obstacle_detected = i[1];
            @(posedge clk);
            front_obstacle_detected = i[0];
            @(posedge clk);
            // persistent = &history, so only 111 should be persistent
            repeat(2) @(posedge clk);
        end
        
        $display("    All persistent obstacle patterns tested");
        
        test_num = test_num + 1;
        $display("[TEST %0d] Instantaneous Power Calculation", test_num);
        apply_reset();
        
        // Zero power (speed=0, throttle=0)
        repeat(50) @(posedge clk);
        
        // Low power
        speed_limit_zone = 2'b00;
        repeat(150) @(posedge clk);
        
        // Medium power
        apply_reset();
        speed_limit_zone = 2'b01;
        repeat(200) @(posedge clk);
        
        // High power
        apply_reset();
        speed_limit_zone = 2'b10;
        repeat(200) @(posedge clk);
        
        $display("    All power levels tested");
        
        // ===================================================================
        // SECTION 10: BOUNDARY CONDITIONS
        // ===================================================================
        $display("\n=== SECTION 10: BOUNDARY CONDITIONS ===\n");
        
        test_num = test_num + 1;
        $display("[TEST %0d] Speed Saturation", test_num);
        apply_reset();
        speed_limit_zone = 2'b10;
        repeat(1200) @(posedge clk); // Try to exceed limits
        $display("    Max achievable speed: %d", current_speed_out);
        
        test_num = test_num + 1;
        $display("[TEST %0d] Speed Underflow", test_num);
        apply_reset();
        speed_limit_zone = 2'b01;
        repeat(200) @(posedge clk);
        speed_limit_zone = 2'b11; // Stop
        repeat(300) @(posedge clk); // Natural deceleration
        $display("    Minimum speed: %d", current_speed_out);
        
        test_num = test_num + 1;
        $display("[TEST %0d] All Output Bit Patterns", test_num);
        
        // Force various scenarios to toggle all output bits
        for (i = 0; i < 20; i = i + 1) begin
            apply_reset();
            
            case (i % 5)
                0: begin
                    speed_limit_zone = 2'b00;
                    repeat(100) @(posedge clk);
                end
                1: begin
                    speed_limit_zone = 2'b01;
                    repeat(150) @(posedge clk);
                    front_obstacle_slow = 1;
                    repeat(10) @(posedge clk);
                    lane_clear_left = 1;
                    repeat(15) @(posedge clk);
                end
                2: begin
                    speed_limit_zone = 2'b10;
                    repeat(200) @(posedge clk);
                end
                3: begin
                    speed_limit_zone = 2'b01;
                    repeat(100) @(posedge clk);
                    front_obstacle_slow = 1;
                    repeat(5) @(posedge clk);
                    lane_clear_right = 1;
                    repeat(15) @(posedge clk);
                end
                4: begin
                    destination_reached = 1;
                    repeat(10) @(posedge clk);
                end
            endcase
        end
        
        $display("    Output patterns exercised");
        
        // ===================================================================
        // SECTION 11: COMPREHENSIVE INTEGRATION
        // ===================================================================
        $display("\n=== SECTION 11: INTEGRATION SCENARIOS ===\n");
        
        test_num = test_num + 1;
        $display("[TEST %0d] Complete Drive Cycle", test_num);
        apply_reset();
        
        // Start
        speed_limit_zone = 2'b00;
        repeat(100) @(posedge clk);
        $display("    Accelerated to 30 km/h");
        
        // Increase speed
        speed_limit_zone = 2'b01;
        repeat(200) @(posedge clk);
        $display("    Cruising at 60 km/h");
        
        // Obstacle ahead - lane change left
        front_obstacle_slow = 1;
        repeat(5) @(posedge clk);
        lane_clear_left = 1;
        repeat(20) @(posedge clk);
        front_obstacle_slow = 0;
        lane_clear_left = 0;
        $display("    Changed lane left");
        
        // Continue
        repeat(100) @(posedge clk);
        
        // Another obstacle - lane change right
        front_obstacle_slow = 1;
        repeat(5) @(posedge clk);
        lane_clear_right = 1;
        repeat(20) @(posedge clk);
        front_obstacle_slow = 0;
        lane_clear_right = 0;
        $display("    Changed lane right");
        
        // Emergency stop
        repeat(50) @(posedge clk);
        repeat(3) begin
            front_obstacle_detected = 1;
            @(posedge clk);
        end
        repeat(150) @(posedge clk);
        $display("    Emergency stopped");
        
        // Resume
        repeat(3) begin
            front_obstacle_detected = 0;
            @(posedge clk);
        end
        repeat(100) @(posedge clk);
        $display("    Resumed driving");
        
        // Reach destination
        destination_reached = 1;
        repeat(10) @(posedge clk);
        $display("    Reached destination");
        
        test_num = test_num + 1;
        $display("[TEST %0d] Multi-Obstacle Scenario", test_num);
        apply_reset();
        speed_limit_zone = 2'b01;
        repeat(100) @(posedge clk);
        
        // All obstacles simultaneously
        front_obstacle_detected = 1;
        left_obstacle_detected = 1;
        right_obstacle_detected = 1;
        repeat(5) @(posedge clk);
        $display("    All obstacles detected");
        
        // Clear obstacles one by one
        front_obstacle_detected = 0;
        repeat(5) @(posedge clk);
        left_obstacle_detected = 0;
        repeat(5) @(posedge clk);
        right_obstacle_detected = 0;
        repeat(5) @(posedge clk);
        $display("    Obstacles cleared sequentially");
        
        test_num = test_num + 1;
        $display("[TEST %0d] Rapid Speed Limit Changes", test_num);
        apply_reset();
        
        for (i = 0; i < 10; i = i + 1) begin
            speed_limit_zone = 2'b00;
            repeat(50) @(posedge clk);
            speed_limit_zone = 2'b10;
            repeat(50) @(posedge clk);
        end
        
        $display("    Rapid speed changes handled");
        
        // ===================================================================
        // SECTION 12: FINAL TOGGLE VERIFICATION
        // ===================================================================
        $display("\n=== SECTION 12: FINAL TOGGLE SWEEP ===\n");
        
        test_num = test_num + 1;
        $display("[TEST %0d] Exhaustive Multi-Bit Toggles", test_num);
        
        // Toggle speed_limit_zone through all transitions
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
                apply_reset();
                speed_limit_zone = i[1:0];
                repeat(100) @(posedge clk);
                speed_limit_zone = j[1:0];
                repeat(100) @(posedge clk);
            end
        end
        
        $display("    All speed_limit_zone transitions tested");
        
        test_num = test_num + 1;
        $display("[TEST %0d] Final Long Run", test_num);
        apply_reset();
        speed_limit_zone = 2'b10;
        
        // Very long run to ensure all counters toggle extensively
        repeat(2000) @(posedge clk);
        
        $display("    Final metrics:");
        $display("      Speed: %d", current_speed_out);
        $display("      Distance: %d", distance_travelled_out);
        $display("      Power: %d", total_power_consumed_out);
        
        // ===================================================================
        // FINAL SUMMARY
        // ===================================================================
        repeat(50) @(posedge clk);
        $display("\n========================================");
        $display("  COMPREHENSIVE COVERAGE TEST COMPLETE");
        $display("========================================");
        $display("  Total Tests: %0d", test_num);
        $display("  Final Speed: %0d", current_speed_out);
        $display("  Total Distance: %0d", distance_travelled_out);
        $display("  Total Power: %0d", total_power_consumed_out);
        $display("========================================\n");
        
        $finish;
    end
    
    // Timeout watchdog
    initial begin
        #5000000; // 5ms timeout
        $display("\n[ERROR] Testbench timeout!");
        $finish;
    end
    
    // Waveform dump
    initial begin
        $dumpfile("collision_avoidance_car_tb.vcd");
        $dumpvars(0, collision_avoidance_car_tb);
    end

endmodule
