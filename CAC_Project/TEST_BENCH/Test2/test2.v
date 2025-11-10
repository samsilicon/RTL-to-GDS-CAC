/*
 * Testbench: collision_avoidance_car_tb
 * Target: 100% Toggle Coverage
 * Strategy: Force every single bit to toggle 0->1 and 1->0 multiple times
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
        $display("  ULTRA TOGGLE COVERAGE TESTBENCH");
        $display("========================================\n");
        
        test_num = 0;
        
        // ===================================================================
        // MEGA TEST 1: EXHAUSTIVE INPUT TOGGLE STORM
        // Toggle every input signal 50+ times in all combinations
        // ===================================================================
        test_num = test_num + 1;
        $display("[TEST %0d] Input Toggle Storm - 50x Each", test_num);
        apply_reset();
        
        for (i = 0; i < 50; i = i + 1) begin
            front_obstacle_detected = ~front_obstacle_detected;
            @(posedge clk);
            front_obstacle_detected = ~front_obstacle_detected;
            @(posedge clk);
        end
        
        for (i = 0; i < 50; i = i + 1) begin
            left_obstacle_detected = ~left_obstacle_detected;
            @(posedge clk);
            left_obstacle_detected = ~left_obstacle_detected;
            @(posedge clk);
        end
        
        for (i = 0; i < 50; i = i + 1) begin
            right_obstacle_detected = ~right_obstacle_detected;
            @(posedge clk);
            right_obstacle_detected = ~right_obstacle_detected;
            @(posedge clk);
        end
        
        for (i = 0; i < 50; i = i + 1) begin
            front_obstacle_slow = ~front_obstacle_slow;
            @(posedge clk);
            front_obstacle_slow = ~front_obstacle_slow;
            @(posedge clk);
        end
        
        for (i = 0; i < 50; i = i + 1) begin
            lane_clear_left = ~lane_clear_left;
            @(posedge clk);
            lane_clear_left = ~lane_clear_left;
            @(posedge clk);
        end
        
        for (i = 0; i < 50; i = i + 1) begin
            lane_clear_right = ~lane_clear_right;
            @(posedge clk);
            lane_clear_right = ~lane_clear_right;
            @(posedge clk);
        end
        
        for (i = 0; i < 50; i = i + 1) begin
            destination_reached = ~destination_reached;
            @(posedge clk);
            destination_reached = ~destination_reached;
            @(posedge clk);
        end
        
        // Speed limit zone - cycle through all 4 values 50 times
        for (i = 0; i < 50; i = i + 1) begin
            speed_limit_zone = 2'b00; repeat(3) @(posedge clk);
            speed_limit_zone = 2'b01; repeat(3) @(posedge clk);
            speed_limit_zone = 2'b10; repeat(3) @(posedge clk);
            speed_limit_zone = 2'b11; repeat(3) @(posedge clk);
        end
        
        $display("  Completed 50x toggle cycles\n");
        
        // ===================================================================
        // MEGA TEST 2: ALL 256 INPUT COMBINATIONS
        // Test all possible 8-bit input patterns
        // ===================================================================
        test_num = test_num + 1;
        $display("[TEST %0d] All 256 Input Combinations x5", test_num);
        
        for (k = 0; k < 5; k = k + 1) begin
            for (i = 0; i < 256; i = i + 1) begin
                {front_obstacle_detected, left_obstacle_detected, right_obstacle_detected,
                 front_obstacle_slow, lane_clear_left, lane_clear_right, 
                 destination_reached, speed_limit_zone[0]} = i[7:0];
                speed_limit_zone[1] = i[0];
                repeat(2) @(posedge clk);
            end
        end
        
        $display("  All 256 combinations tested 5 times\n");
        
        // ===================================================================
        // MEGA TEST 3: SPEED COUNTER FULL RANGE (0-255)
        // Run multiple cycles to hit all speed values
        // ===================================================================
        test_num = test_num + 1;
        $display("[TEST %0d] Speed Counter Full Range", test_num);
        
        // Cycle 1: Ramp to max
        apply_reset();
        speed_limit_zone = 2'b10;
        repeat(1500) @(posedge clk);
        $display("  Cycle 1 max speed: %d", current_speed_out);
        
        // Cycle 2: Decel to zero
        speed_limit_zone = 2'b11;
        repeat(500) @(posedge clk);
        $display("  Cycle 2 min speed: %d", current_speed_out);
        
        // Cycle 3: Medium speed
        apply_reset();
        speed_limit_zone = 2'b00;
        repeat(300) @(posedge clk);
        $display("  Cycle 3 speed: %d", current_speed_out);
        
        // Cycle 4: Another ramp
        speed_limit_zone = 2'b01;
        repeat(400) @(posedge clk);
        $display("  Cycle 4 speed: %d", current_speed_out);
        
        // Cycle 5: Max speed again
        speed_limit_zone = 2'b10;
        repeat(800) @(posedge clk);
        $display("  Cycle 5 speed: %d", current_speed_out);
        
        $display("  Speed toggled through full range\n");
        
        // ===================================================================
        // MEGA TEST 4: DISTANCE COUNTER FULL RANGE (32-bit)
        // Run very long to toggle high-order bits
        // ===================================================================
        test_num = test_num + 1;
        $display("[TEST %0d] Distance Counter Full Range", test_num);
        apply_reset();
        speed_limit_zone = 2'b10;
        
        repeat(3000) @(posedge clk);
        $display("  Distance after 3000 cycles: %d", distance_travelled_out);
        
        repeat(3000) @(posedge clk);
        $display("  Distance after 6000 cycles: %d", distance_travelled_out);
        
        $display("  Distance counter exercised\n");
        
        // ===================================================================
        // MEGA TEST 5: POWER COUNTER FULL RANGE (32-bit)
        // ===================================================================
        test_num = test_num + 1;
        $display("[TEST %0d] Power Counter Full Range", test_num);
        
        repeat(3000) @(posedge clk);
        $display("  Power after 9000 total cycles: %d", total_power_consumed_out);
        
        $display("  Power counter exercised\n");
        
        // ===================================================================
        // MEGA TEST 6: ALL STATE REGISTER BITS
        // Visit all 11 states multiple times to toggle all state bits
        // ===================================================================
        test_num = test_num + 1;
        $display("[TEST %0d] State Register Bit Toggles - 10x Each State", test_num);
        
        for (k = 0; k < 10; k = k + 1) begin
            // IDLE
            apply_reset();
            repeat(5) @(posedge clk);
            
            // ACCELERATE_FWD
            speed_limit_zone = 2'b01;
            repeat(30) @(posedge clk);
            
            // CRUISE
            repeat(150) @(posedge clk);
            
            // DECELERATE
            front_obstacle_slow = 1;
            repeat(10) @(posedge clk);
            
            // PREPARE_LANE_CHANGE_LEFT
            lane_clear_left = 1;
            repeat(5) @(posedge clk);
            
            // LANE_CHANGE_LEFT
            repeat(5) @(posedge clk);
            
            // Back to ACCELERATE_FWD
            front_obstacle_slow = 0;
            lane_clear_left = 0;
            repeat(20) @(posedge clk);
            
            // PREPARE_LANE_CHANGE_RIGHT
            front_obstacle_slow = 1;
            repeat(5) @(posedge clk);
            lane_clear_right = 1;
            repeat(5) @(posedge clk);
            
            // LANE_CHANGE_RIGHT
            repeat(5) @(posedge clk);
            
            // AVOID_OBSTACLE_STOP
            front_obstacle_slow = 0;
            lane_clear_right = 0;
            repeat(20) @(posedge clk);
            repeat(3) begin
                front_obstacle_detected = 1;
                @(posedge clk);
            end
            repeat(10) @(posedge clk);
            
            // Back to IDLE
            repeat(3) begin
                front_obstacle_detected = 0;
                @(posedge clk);
            end
            repeat(50) @(posedge clk);
            
            // STOPPED
            apply_reset();
            destination_reached = 1;
            repeat(10) @(posedge clk);
        end
        
        $display("  All states visited 10 times\n");
        
        // ===================================================================
        // MEGA TEST 7: REGISTERED INPUT TOGGLES
        // Toggle inputs and ensure registered versions toggle
        // ===================================================================
        test_num = test_num + 1;
        $display("[TEST %0d] Registered Input Toggles - 100x", test_num);
        apply_reset();
        
        for (i = 0; i < 100; i = i + 1) begin
            front_obstacle_slow = ~front_obstacle_slow;
            lane_clear_left = ~lane_clear_left;
            lane_clear_right = ~lane_clear_right;
            destination_reached = ~destination_reached;
            speed_limit_zone = speed_limit_zone + 1;
            repeat(2) @(posedge clk);
        end
        
        $display("  Registered inputs toggled 100 times\n");
        
        // ===================================================================
        // MEGA TEST 8: OBSTACLE HISTORY REGISTERS
        // All 512 combinations (3x 3-bit registers = 9 bits)
        // ===================================================================
        test_num = test_num + 1;
        $display("[TEST %0d] Obstacle History All Patterns", test_num);
        apply_reset();
        
        // All combinations of front/left/right over 3 cycles
        for (i = 0; i < 512; i = i + 1) begin
            front_obstacle_detected = i[0];
            left_obstacle_detected = i[3];
            right_obstacle_detected = i[6];
            @(posedge clk);
            front_obstacle_detected = i[1];
            left_obstacle_detected = i[4];
            right_obstacle_detected = i[7];
            @(posedge clk);
            front_obstacle_detected = i[2];
            left_obstacle_detected = i[5];
            right_obstacle_detected = i[8];
            @(posedge clk);
        end
        
        $display("  All 512 history patterns tested\n");
        
        // ===================================================================
        // MEGA TEST 9: OUTPUT SIGNAL TOGGLES
        // Force all output values multiple times
        // ===================================================================
        test_num = test_num + 1;
        $display("[TEST %0d] Output Signal Toggles - 20x Each Value", test_num);
        
        for (k = 0; k < 20; k = k + 1) begin
            // acceleration = 2'b00
            apply_reset();
            speed_limit_zone = 2'b01;
            repeat(100) @(posedge clk);
            repeat(3) begin
                front_obstacle_detected = 1;
                @(posedge clk);
            end
            repeat(10) @(posedge clk);
            
            // acceleration = 2'b01
            apply_reset();
            repeat(10) @(posedge clk);
            
            // acceleration = 2'b10
            speed_limit_zone = 2'b10;
            repeat(50) @(posedge clk);
            
            // steering = 2'b01
            front_obstacle_slow = 1;
            repeat(5) @(posedge clk);
            lane_clear_left = 1;
            repeat(15) @(posedge clk);
            
            // steering = 2'b00
            apply_reset();
            speed_limit_zone = 2'b01;
            repeat(50) @(posedge clk);
            
            // steering = 2'b10
            front_obstacle_slow = 1;
            repeat(5) @(posedge clk);
            lane_clear_right = 1;
            repeat(15) @(posedge clk);
            
            // indicators = 2'b01
            apply_reset();
            speed_limit_zone = 2'b01;
            repeat(100) @(posedge clk);
            front_obstacle_slow = 1;
            repeat(5) @(posedge clk);
            lane_clear_left = 1;
            repeat(10) @(posedge clk);
            
            // indicators = 2'b10
            apply_reset();
            speed_limit_zone = 2'b01;
            repeat(100) @(posedge clk);
            front_obstacle_slow = 1;
            repeat(5) @(posedge clk);
            lane_clear_right = 1;
            repeat(10) @(posedge clk);
            
            // indicators = 2'b00
            apply_reset();
            speed_limit_zone = 2'b01;
            repeat(50) @(posedge clk);
        end
        
        $display("  All outputs toggled 20 times\n");
        
        // ===================================================================
        // MEGA TEST 10: RESET TOGGLE
        // Toggle reset many times
        // ===================================================================
        test_num = test_num + 1;
        $display("[TEST %0d] Reset Toggle - 50x", test_num);
        
        for (i = 0; i < 50; i = i + 1) begin
            apply_reset();
            speed_limit_zone = 2'b01;
            repeat(100) @(posedge clk);
        end
        
        $display("  Reset toggled 50 times\n");
        
        // ===================================================================
        // MEGA TEST 11: THROTTLE VALUE PATHS
        // Hit all throttle calculation paths
        // ===================================================================
        test_num = test_num + 1;
        $display("[TEST %0d] Throttle Value Toggles - 20x Each", test_num);
        
        for (k = 0; k < 20; k = k + 1) begin
            // Throttle = 0
            apply_reset();
            repeat(50) @(posedge clk);
            
            // Throttle = 50
            speed_limit_zone = 2'b00;
            repeat(180) @(posedge clk);
            
            // Throttle = 100
            apply_reset();
            speed_limit_zone = 2'b01;
            repeat(160) @(posedge clk);
            
            // Throttle = 150
            apply_reset();
            speed_limit_zone = 2'b10;
            repeat(50) @(posedge clk);
        end
        
        $display("  All throttle values tested 20 times\n");
        
        // ===================================================================
        // MEGA TEST 12: SPEED COMPARATORS
        // Toggle speed_is_zero and target_speed_reached
        // ===================================================================
        test_num = test_num + 1;
        $display("[TEST %0d] Speed Comparator Toggles - 30x", test_num);
        
        for (k = 0; k < 30; k = k + 1) begin
            // speed_is_zero = 1
            apply_reset();
            repeat(20) @(posedge clk);
            
            // speed_is_zero = 0
            speed_limit_zone = 2'b01;
            repeat(100) @(posedge clk);
            
            // target_speed_reached = 1
            repeat(150) @(posedge clk);
            
            // target_speed_reached = 0
            speed_limit_zone = 2'b10;
            repeat(10) @(posedge clk);
        end
        
        $display("  Comparators toggled 30 times\n");
        
        // ===================================================================
        // MEGA TEST 13: INTEGRAL ERROR ACCUMULATOR
        // Toggle accumulator and reset paths
        // ===================================================================
        test_num = test_num + 1;
        $display("[TEST %0d] Integral Accumulator Toggles - 25x", test_num);
        
        for (k = 0; k < 25; k = k + 1) begin
            apply_reset();
            speed_limit_zone = 2'b01;
            
            // Accumulate
            repeat(250) @(posedge clk);
            
            // Reset accumulator
            front_obstacle_slow = 1;
            repeat(10) @(posedge clk);
            front_obstacle_slow = 0;
        end
        
        $display("  Accumulator toggled 25 times\n");
        
        // ===================================================================
        // MEGA TEST 14: EXTREME LONG RUN
        // Run for 10000+ cycles to ensure high-order bits toggle
        // ===================================================================
        test_num = test_num + 1;
        $display("[TEST %0d] Extreme Long Run - 10000 Cycles", test_num);
        apply_reset();
        speed_limit_zone = 2'b10;
        
        for (i = 0; i < 10; i = i + 1) begin
            repeat(1000) @(posedge clk);
            $display("  Progress: %d000 cycles, Speed=%d, Dist=%d, Power=%d", 
                     i+1, current_speed_out, distance_travelled_out, total_power_consumed_out);
        end
        
        $display("  Long run complete\n");
        
        // ===================================================================
        // MEGA TEST 15: RANDOM CHAOS
        // Completely random inputs for toggle diversity
        // ===================================================================
        test_num = test_num + 1;
        $display("[TEST %0d] Random Chaos - 5000 Cycles", test_num);
        apply_reset();
        
        for (i = 0; i < 5000; i = i + 1) begin
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
        
        $display("  Random chaos complete\n");
        
        // ===================================================================
        // MEGA TEST 16: SPECIFIC BIT PATTERNS
        // Target specific bit patterns for stubborn toggles
        // ===================================================================
        test_num = test_num + 1;
        $display("[TEST %0d] Specific Bit Patterns", test_num);
        
        // Walking ones
        for (i = 0; i < 8; i = i + 1) begin
            apply_reset();
            {front_obstacle_detected, left_obstacle_detected, right_obstacle_detected,
             front_obstacle_slow, lane_clear_left, lane_clear_right, 
             destination_reached, speed_limit_zone[0]} = (1 << i);
            repeat(50) @(posedge clk);
        end
        
        // Walking zeros
        for (i = 0; i < 8; i = i + 1) begin
            apply_reset();
            {front_obstacle_detected, left_obstacle_detected, right_obstacle_detected,
             front_obstacle_slow, lane_clear_left, lane_clear_right, 
             destination_reached, speed_limit_zone[0]} = ~(1 << i);
            repeat(50) @(posedge clk);
        end
        
        // Checkerboard patterns
        apply_reset();
        {front_obstacle_detected, left_obstacle_detected, right_obstacle_detected,
         front_obstacle_slow, lane_clear_left, lane_clear_right, 
         destination_reached, speed_limit_zone[0]} = 8'b10101010;
        repeat(100) @(posedge clk);
        
        {front_obstacle_detected, left_obstacle_detected, right_obstacle_detected,
         front_obstacle_slow, lane_clear_left, lane_clear_right, 
         destination_reached, speed_limit_zone[0]} = 8'b01010101;
        repeat(100) @(posedge clk);
        
        $display("  Bit patterns complete\n");
        
        // ===================================================================
        // MEGA TEST 17: FINAL MARATHON
        // One more super long run with varying conditions
        // ===================================================================
        test_num = test_num + 1;
        $display("[TEST %0d] Final Marathon - 5000 Cycles", test_num);
        
        for (i = 0; i < 50; i = i + 1) begin
            apply_reset();
            speed_limit_zone = i % 3;
            repeat(100) @(posedge clk);
        end
        
        $display("  Marathon complete\n");
        
        // ===================================================================
        // FINAL SUMMARY
        // ===================================================================
        repeat(100) @(posedge clk);
        $display("\n========================================");
        $display("  ULTRA TOGGLE TEST COMPLETE");
        $display("========================================");
        $display("  Total Tests: %0d", test_num);
        $display("  Final Speed: %0d", current_speed_out);
        $display("  Total Distance: %0d", distance_travelled_out);
        $display("  Total Power: %0d", total_power_consumed_out);
        $display("  Total Cycles: ~35000+");
        $display("========================================\n");
        
        $finish;
    end
    
    // Timeout
    initial begin
        #10000000; // 10ms
        $display("\n[TIMEOUT]");
        $finish;
    end
    
    // Waveform
    initial begin
        $dumpfile("collision_avoidance_car_tb.vcd");
        $dumpvars(0, collision_avoidance_car_tb);
    end

endmodule
