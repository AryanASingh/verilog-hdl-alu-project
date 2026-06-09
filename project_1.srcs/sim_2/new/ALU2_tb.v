`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.06.2026 10:08:39
// Design Name: 
// Module Name: ALU2_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module ALU2_tb;
    // Testbench Driver Registers
    reg [7:0] tb_A;
    reg [7:0] tb_B;
    reg       tb_carry_in;
    reg [2:0] tb_SEL;

    // Testbench Monitor Wires
    wire [7:0] tb_Result;
    wire       tb_carry_out;
    wire       tb_zero_flag;

    /* 
       METHOD 2 INSTANTIATION:
       Signals must strictly match the ALU port order:
       1: A, 2: B, 3: carry_in, 4: SEL, 5: Result, 6: carry_out, 7: zero_flag
    */
    ALU alu_instance (
        tb_A, 
        tb_B, 
        tb_carry_in, 
        tb_SEL, 
        tb_Result, 
        tb_carry_out, 
        tb_zero_flag
    );

    initial begin
        // Initialize Inputs
        tb_A = 8'b0; tb_B = 8'b0; tb_carry_in = 1'b0; tb_SEL = 3'b0;
        #20;
        
        // Test Case 1: ADD operation (A=15, B=15) -> Expected: 30
        tb_A = 8'b00001111; tb_B = 8'b00001111; tb_carry_in = 1'b0; tb_SEL = 3'b000;
        #20;
        
        // Test Case 2: SUB operation (A=255, B=1) -> Expected: 254
        tb_A = 8'b11111111; tb_B = 8'b00000001; tb_carry_in = 1'b0; tb_SEL = 3'b001;
        #20;

        // Test Case 3: NOT operation (A=170) -> Expected: 85 (Inverted)
        tb_A = 8'b10101010; tb_SEL = 3'b101;
        #20;
        
        // Test Case 4: Shift Left (A=1) -> Expected: 2
        tb_A = 8'b00000001; tb_SEL = 3'b110;
        #20;

        // Test Case 5: Zero Flag Test (A=5, B=5, SUB) -> Expected Result=0, Zero Flag=1
        tb_A = 8'b00000101; tb_B = 8'b00000101; tb_SEL = 3'b001;
        #20;

        $finish; // End simulation run
    end
endmodule