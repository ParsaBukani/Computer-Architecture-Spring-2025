# Maze in Rat — Intelligent Pathfinding with Memory

_Computer Architecture — University of Tehran_

This project implements a **hardware maze solver** composed of two main modules: **Memory Maze** for storing the environment and **Intelligent Rat** for navigation. The rat explores the maze using a **track-back algorithm** with movement priorities and stores successful paths in a FIFO buffer for future runs. The design is written in Verilog and tested through simulation and control signals.

<p align="center">

<img width="750" height="459" alt="Image" src="https://github.com/user-attachments/assets/a8762b81-4003-45a6-ab25-635f446ef125" />
</p>


## Tasks

1.  **Memory Maze Module**
    -   A **16×16 memory** represents the maze map:
        -   `1` → Wall
        -   `0` → Free space
    -   The starting point is located at the bottom-left `(0,0)` and the exit at the top-right `(15,15)`.
    -   The maze map is loaded from an external file at startup.
    -   Synchronous read/write operations are performed with clock input.
        
2.  **Intelligent Rat Module**
    -   Navigation is based on movement priorities: **Up → Right → Left → Down**.
    -   A **track-back algorithm** with a 2-bit stack enables exploration and backtracking:
        -   **Push** operations store forward moves into the stack.
        -   **Pop** operations allow the rat to backtrack at dead ends.
        
    -   Control signals include:
        -   **RST**: Resets registers, clears stack/FIFO, and returns to start.
        -   **Start**: Begins the pathfinding process and saves the discovered path. 
        -   **Run**: Replays the stored path step by step from FIFO.
        -   **Fail**: Active if no path exists between start and exit.
        -   **Done**: Active when a valid path is found.
        -   **Move**: Encodes step-by-step movement sequence.
            
3.  **Verification & Testing**
    
    -   Simulation performed in Verilog.
    -   Custom maze inputs tested for functional verification.
    -   The rat’s movement trace compared against the expected solution path.

## Project Report
_A detailed **Project Report** with design diagrams, simulation results, and analysis is available here: [Project_Report.pdf](https://github.com/ParsaBukani/Computer-Architecture-Spring-2025/blob/main/Maze%20in%20Rat/Project%20Report.pdf)_

## License

This project is licensed under the **MIT License**.

## Acknowledgements
Developed under the supervision of **Dr. Saeed Safari**  

