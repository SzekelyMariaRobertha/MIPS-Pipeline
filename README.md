# MIPS-Pipeline
This MIPS pipeline project is designed to implement a simple MIPS processor using a five-stage pipeline. The processor will be able to execute basic arithmetic and logic instructions. This project is implemented in VHDL and can be synthesized using any FPGA board or simulator.

## Requirements
Vivado: 2016. 4 (for generating a bitstream)
Basys 3 Digilent board (optional)


## Usage
### Requirements
The project requires the following modules to be implemented in Verilog:

Register File: This module stores the values of the registers used by the processor.
ALU (Arithmetic and Logic Unit): This module performs the arithmetic and logic operations required by the processor.
Control Unit: This module generates control signals for the different stages of the pipeline.
Data Memory: This module stores the data that is accessed by the processor.


### Implementation
Pipeline Stages:
The MIPS processor pipeline consists of five stages:

Instruction Fetch (IF)
Instruction Decode (ID)
Execute (EX)
Memory Access (MEM)
Write Back (WB)
The pipeline stages work as follows:

Instruction Fetch (IF): The instruction to be executed is fetched from memory.
Instruction Decode (ID): The instruction is decoded and the operands are extracted.
Execute (EX): The arithmetic or logic operation is performed on the operands.
Memory Access (MEM): If the instruction accesses memory, the data is retrieved or stored in memory.
Write Back (WB): The result of the operation is written back to the register file.

Schema
<div allign="center">
    <img src="https://user-images.githubusercontent.com/93877610/232552860-d0dea2ea-9999-4b54-9eec-db6bb44382d5.jpg" width="800" height="500">
</div>

### Testing
The project can be tested using testbenches designed to provide inputs to the processor and check the outputs. The testbenches can be used to test different types of instructions and edge cases to ensure the correct behavior of the processor.

I chose to test it on Basys 3 Digilent board and fot that I implemented a program in which I will try to go through the elements of an array from memory. It will compute the double of the first 10 numbers and store it back in memory at the same address. I will also calculate the sum of the double numbers and store it after the first 9 numbers, in memory.

<div allign="center">
    <img src="https://user-images.githubusercontent.com/93877610/232553840-944ff960-15f0-46dc-8254-7d2378f0d18c.jpg" width="200" height="300">

To be noted that the program that was uploaded on my microprocessor is written in binary code, after being translated from ASSEMBLY. 
</div>

