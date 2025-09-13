
# Stack-Based Multi-Cycle Processor

_Computer Architecture — University of Tehran_

This project implements a **stack-based, multi-cycle processor** with an internal operand stack and an **8-bit data path** over a **5-bit address space**. The instruction set supports arithmetic and logic operations, memory access, and control flow. Instructions are executed through a multi-cycle FSM, where operands are managed via stack push and pop operations.

<p align="center">
    
<img width="1024" height="1024" alt="Image" src="https://github.com/user-attachments/assets/b8cf5e30-3e28-41a2-ad5f-5b9c3e0c7f75" />

</p>


## Tasks

1.  **Instruction Set**
    -   Arithmetic/Logic: `ADD`, `SUB`, `AND`, `NOT`  
    -   Memory Access: `PUSH`, `POP`  
    -   Control Flow: `JMP`, `JZ`

2.  **Datapath & Controller**
    -   Multi-cycle datapath with unified memory, ALU, stack, and control FSM.  
    -   Operand handling performed entirely through the stack.

3.  **Program & Testing**
    -   An assembly program computes the **sum of a 4-element array** starting at memory address 25.  
    -   The program is assembled, loaded into memory, and executed to verify processor functionality through simulation.

## Project Report
_A detailed **Project Report** with design diagrams, simulation results, and analysis is available here: [Project_Report.pdf](https://github.com/ParsaBukani/Computer-Architecture-Spring-2025/blob/main/Stack-Based%20Multi-Cycle%20Processor/Content/Project%20Report.pdf)_

## License

This project is licensed under the **MIT License**.


## Acknowledgements

Developed under the supervision of **Dr. Saeed Safari**

