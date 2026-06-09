`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.06.2026 09:40:23
// Design Name: 
// Module Name: ALU
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

// alu_top.v - Main 8-bit ALU Module (Positional Order Baseline)
module ALU(
    input  [7:0] A,          // Position 1
    input  [7:0] B,          // Position 2
    input        carry_in,   // Position 3
    input  [2:0] SEL,        // Position 4
    output reg [7:0] Result, // Position 5
    output reg       carry_out, // Position 6
    output           zero_flag  // Position 7
);

    // Internal wires for combinational sub-modules
    wire [7:0] sum, diff, out_and, out_or, out_xor, out_not, out_shl, out_shr;
    wire       sum_carry, diff_carry;

    // 1. Arithmetic Operations Logic
    assign {sum_carry, sum}  = A + B + carry_in;
    assign {diff_carry, diff} = A - B - carry_in;

    // 2. Logical Operations Logic
    assign out_and = A & B;
    assign out_or  = A | B;
    assign out_xor = A ^ B;
    assign out_not = ~A;

    // 3. Shifter Operations Logic
    assign out_shl = A << 1;
    assign out_shr = A >> 1;

    // Output Routing Multiplexer (Purely Combinational)
    always @(*) begin
        case (SEL)
            3'b000: begin // ADD
                Result    = sum;
                carry_out = sum_carry;
            end
            3'b001: begin // SUB
                Result    = diff;
                carry_out = diff_carry;
            end
            3'b010: begin // AND
                Result    = out_and;
                carry_out = 1'b0;
            end
            3'b011: begin // OR
                Result    = out_or;
                carry_out = 1'b0;
            end
            3'b100: begin // XOR
                Result    = out_xor;
                carry_out = 1'b0;
            end
            3'b101: begin // NOT
                Result    = out_not;
                carry_out = 1'b0;
            end
            3'b110: begin // Shift Left
                Result    = out_shl;
                carry_out = A[7]; // MSB passes to carry
            end
            3'b111: begin // Shift Right
                Result    = out_shr;
                carry_out = A[0]; // LSB passes to carry
            end
            default: begin
                Result    = 8'b00000000;
                carry_out = 1'b0;
            end
        endcase
    end

    // Zero Flag Assignment
    assign zero_flag = (Result == 8'b00000000) ? 1'b1 : 1'b0;

endmodule


