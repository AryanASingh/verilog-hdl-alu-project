# 8-Bit ALU (Arithmetic Logic Unit)

An 8-bit Arithmetic Logic Unit implemented in Verilog HDL. Supports addition, subtraction, logical operations (AND, OR, XOR, NOT), and shift operations (SHL, SHR).

![Language](https://img.shields.io/badge/Language-Verilog%20HDL-blue) ![Tool](https://img.shields.io/badge/Tool-Xilinx%20Vivado-orange) ![Status](https://img.shields.io/badge/Status-Completed-brightgreen) ![Domain](https://img.shields.io/badge/Domain-VLSI%20Design-purple)

---

## RTL Schematic

<img width="1159" height="581" alt="RTL Schematic" src="https://github.com/user-attachments/assets/d78d2b8f-d471-451f-8300-7ce88446f3d0" />

---

## Simulation Waveform

<img width="1457" height="325" alt="Simulation Waveform" src="https://github.com/user-attachments/assets/8f5bbdd5-eccd-4056-95ef-f77ad6033a43" />

---

## Implementation Report

<img width="1251" height="667" alt="Implementation Report" src="https://github.com/user-attachments/assets/2be1bec9-913c-4863-8950-c77928f3be18" />

---

## DRC Report

<img width="1271" height="522" alt="DRC Report" src="https://github.com/user-attachments/assets/a230a917-4335-443c-83ef-9540ec3b2922" />

---

## Power Report

<img width="865" height="485" alt="Power Report" src="https://github.com/user-attachments/assets/ac924c98-e735-4422-891d-ee2bdcbbb291" />

---

## Features

- **Operations** controlled by 3-bit SEL signal:

| SEL | Operation | Expression |
|-----|-----------|------------|
| 000 | ADD | A + B + Cin |
| 001 | SUB | A - B - Cin |
| 010 | AND | A & B |
| 011 | OR | A \| B |
| 100 | XOR | A ^ B |
| 101 | NOT | ~A |
| 110 | SHL | A << 1 |
| 111 | SHR | A >> 1 |

- Purely combinational design using `always @(*)`
- Modular sub-modules for each operation
- Outputs: 8-bit Result, Carry/Borrow flag, Zero flag
- Comprehensive testbench with 5 test vectors

---

## Port Specification

| Port | Width | Direction | Description |
|------|-------|-----------|-------------|
| A[7:0] | 8-bit | Input | Operand A |
| B[7:0] | 8-bit | Input | Operand B |
| carry_in | 1-bit | Input | Carry / Borrow input |
| SEL[2:0] | 3-bit | Input | Operation selector (opcode) |
| Result[7:0] | 8-bit | Output | Computed result |
| carry_out | 1-bit | Output | Carry / Borrow output |
| zero_flag | 1-bit | Output | High when Result = 0 |

---

## Project Structure

```
verilog-hdl-alu-project/
├── src/
│   ├── ALU.v         # Top-level ALU module
│   └── ALU2_tb.v     # Testbench (5 test vectors)
└── README.md
```

---

## Verilog Source — ALU.v

```verilog
`timescale 1ns / 1ps

module ALU(
    input  [7:0] A,
    input  [7:0] B,
    input        carry_in,
    input  [2:0] SEL,
    output reg [7:0] Result,
    output reg   carry_out,
    output       zero_flag
);

    wire [7:0] sum, diff, out_and, out_or, out_xor, out_not, out_shl, out_shr;
    wire       sum_carry, diff_carry;

    // Arithmetic
    assign {sum_carry,  sum}  = A + B + carry_in;
    assign {diff_carry, diff} = A - B - carry_in;

    // Logical
    assign out_and = A & B;
    assign out_or  = A | B;
    assign out_xor = A ^ B;
    assign out_not = ~A;

    // Shift
    assign out_shl = A << 1;
    assign out_shr = A >> 1;

    // Output MUX
    always @(*) begin
        case (SEL)
            3'b000: begin Result = sum;     carry_out = sum_carry;  end
            3'b001: begin Result = diff;    carry_out = diff_carry; end
            3'b010: begin Result = out_and; carry_out = 1'b0;       end
            3'b011: begin Result = out_or;  carry_out = 1'b0;       end
            3'b100: begin Result = out_xor; carry_out = 1'b0;       end
            3'b101: begin Result = out_not; carry_out = 1'b0;       end
            3'b110: begin Result = out_shl; carry_out = A[7];       end
            3'b111: begin Result = out_shr; carry_out = A[0];       end
            default: begin Result = 8'b00000000; carry_out = 1'b0; end
        endcase
    end

    assign zero_flag = (Result == 8'b00000000) ? 1'b1 : 1'b0;

endmodule
```

---

## Testbench — ALU2_tb.v

```verilog
`timescale 1ns / 1ps
module ALU2_tb;

    reg  [7:0] tb_A, tb_B;
    reg        tb_carry_in;
    reg  [2:0] tb_SEL;
    wire [7:0] tb_Result;
    wire       tb_carry_out, tb_zero_flag;

    ALU alu_instance (tb_A, tb_B, tb_carry_in, tb_SEL,
                      tb_Result, tb_carry_out, tb_zero_flag);

    initial begin
        tb_A = 8'b0; tb_B = 8'b0; tb_carry_in = 1'b0; tb_SEL = 3'b0; #20;

        // Test 1: ADD 0x0F + 0x0F = 0x1E
        tb_A = 8'b00001111; tb_B = 8'b00001111; tb_carry_in = 1'b0; tb_SEL = 3'b000; #20;

        // Test 2: SUB 0xFF - 0x01 = 0xFE
        tb_A = 8'b11111111; tb_B = 8'b00000001; tb_carry_in = 1'b0; tb_SEL = 3'b001; #20;

        // Test 3: NOT 0xAA = 0x55
        tb_A = 8'b10101010; tb_SEL = 3'b101; #20;

        // Test 4: SHL 0x01 = 0x02
        tb_A = 8'b00000001; tb_SEL = 3'b110; #20;

        // Test 5: SUB 0x05 - 0x05 = 0x00, zero_flag = 1
        tb_A = 8'b00000101; tb_B = 8'b00000101; tb_SEL = 3'b001; #20;

        $finish;
    end
endmodule
```

---

## Waveform Analysis — Test Results

| Operation | A | B | Cin | Result | Cout | Zero | Status |
|-----------|---|---|-----|--------|------|------|--------|
| ADD | 0x0F | 0x0F | 0 | 0x1E | 0 | 0 | ✅ PASS |
| SUB | 0xFF | 0x01 | 0 | 0xFE | 1 | 0 | ✅ PASS |
| NOT | 0xAA | — | — | 0x55 | 0 | 0 | ✅ PASS |
| SHL | 0x01 | — | — | 0x02 | 0 | 0 | ✅ PASS |
| SUB (Zero) | 0x05 | 0x05 | 0 | 0x00 | 0 | 1 | ✅ PASS |

---

## Power Summary

| Category | Value | Share |
|----------|-------|-------|
| Total On-Chip | 5.478 W | 100% |
| Dynamic | 5.384 W | 98% |
| Signals | 0.324 W | 6% |
| Logic | 0.188 W | 3% |
| I/O | 4.873 W | 91% |
| Device Static | 0.093 W | 2% |

> Junction Temp: 35.3°C | Thermal Margin: 49.7°C | Confidence: Low (no XDC constraints)

---

## DRC Violations

| Violation | Severity | Description |
|-----------|----------|-------------|
| NSTD-1 | 🔴 Critical | 30 ports using DEFAULT IOSTANDARD |
| UCIO-1 | 🔴 Critical | 30 ports have no LOC constraint |
| CFGBVS-1 | 🟡 Warning | CFGBVS / CONFIG_VOLTAGE not set for bank 0 |

**Resolution:** Add a `.xdc` constraints file specifying `IOSTANDARD`, `LOC`, and `CFGBVS` for all 30 ports.

---

## Technologies

| Tool | Purpose |
|------|---------|
| Verilog HDL | Hardware description language |
| Xilinx Vivado | Synthesis, simulation, implementation |
| ModelSim | Waveform simulation (alternative) |
| Git + GitHub | Version control |

---

## How to Run

```bash
# Clone the repo
git clone https://github.com/AryanASingh/verilog-hdl-alu-project.git

# In Vivado: Add src/ALU.v as Design Source
#            Add src/ALU2_tb.v as Simulation Source
# Run Behavioral Simulation → run 120ns

# OR using Icarus Verilog (free)
iverilog -o alu_sim src/ALU.v src/ALU2_tb.v
vvp alu_sim
```

---

## Future Improvements

- Add multiply and divide operations
- Signed arithmetic with overflow detection
- XDC constraints file for bitstream generation
- FPGA deployment on Basys3 / Nexys board
- Expand to 16-bit / 32-bit ALU for RISC core

---

## Author

**Aryan Singh**  
Electronics & Communication Engineering  
Maulana Azad National Institute of Technology, Bhopal  
TechGlobal Industrial Training Program | May–June 2026
