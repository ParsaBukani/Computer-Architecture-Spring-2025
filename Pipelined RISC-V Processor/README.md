# Pipelined RISC-V Processor

_Computer Architecture — University of Tehran_

This project implements a **pipelined processor** for the **RISC-V architecture**, supporting a selected subset of instructions across multiple formats. The design follows a classic pipeline structure with hazard detection and resolution mechanisms to ensure correct execution. Datapath and controller are described in Verilog, and the processor is validated by running a test program.


## Tasks

1.  **Instruction Set Support**
    -   **R-Type**: `add`, `sub`, `and`, `or`, `slt`  
    -   **I-Type**: `lw`, `addi`, `ori`, `slti`, `jalr`  
    -   **S-Type**: `sw`  
    -   **J-Type**: `jal`  
    -   **B-Type**: `beq`, `bne`  
    -   **U-Type**: `lui`  

2.  **Pipeline Design**
    -   Multi-stage pipeline including **IF, ID, EX, MEM, WB**.  
    -   Hazard detection and resolution strategies implemented to handle **data hazards** and **control hazards**.  
    -   Integration of datapath components and control logic for smooth instruction flow.

3.  **Program & Testing**
    -   A test program is written to find the **largest element** in an array of 20 signed 32-bit integers.  
    -   The program is assembled for RISC-V and executed on the processor.  
    -   Simulation verifies correct pipeline behavior, hazard handling, and program output.

## Project Report
_A detailed **Project Report** with design diagrams, simulation results, and analysis is available here: [Project_Report.pdf](https://github.com/ParsaBukani/Computer-Architecture-Spring-2025/blob/main/Pipelined%20RISC-V%20Processor/Content/Project%20Report.pdf)_

## License

This project is licensed under the **MIT License**.


## Acknowledgements

Developed under the supervision of **Dr. Saeed Safari**

