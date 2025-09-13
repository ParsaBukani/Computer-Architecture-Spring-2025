# Single-Cycle RISC-V Processor

_Computer Architecture — University of Tehran_

This project implements a **Single-Cycle processor** for the **RISC-V architecture**, supporting a selected set of RISC instructions across multiple types. The design includes datapath and control unit implementation in Verilog, along with functional testing through a custom program. The processor executes integer operations, memory accesses, branches, and jumps in a single-cycle execution model.


## Tasks

1.  **Instruction Set Support**
    -   **R-Type**: `add`, `sub`, `and`, `or`, `slt`  
    -   **I-Type**: `lw`, `addi`, `ori`, `slti`, `jalr`  
    -   **S-Type**: `sw`  
    -   **J-Type**: `jal`  
    -   **B-Type**: `beq`, `bne`  
    -   **U-Type**: `lui`  

2.  **Datapath and Control Unit**
    -   Verilog implementation of a **single-cycle datapath** supporting the above instructions.  
    -   Control unit design for instruction decoding and signal generation.  
    -   Structural integration of datapath components and control logic.  

3.  **Program Execution & Verification**
    -   A test program is developed to find the **largest element** in an array of 20 signed 32-bit integers.  
    -   Program is assembled for RISC-V and executed on the processor to validate functionality.  
    -   Simulation of datapath and control unit in Verilog.   


## License

This project is licensed under the **MIT License**.


## Acknowledgements

Developed under the supervision of **Dr. Saeed Safari**

