# picoEdgeSoC

 A low-power RISC-V SoC tailored for Edge AI applications, built for the iCE40UP5K FPGA.

##  Status
>  Work in Progress  
This repository is currently under active development. Major components are being implemented and tested.

##  Objective
To build a compact, low-power System-on-Chip (SoC) based on the RISC-V architecture that supports UART communication, memory-mapped IO, and minimal peripherals, optimized for Edge AI deployment on small FPGAs like the VSD Squadron Mini (iCE40UP5K).

## Features (Planned)
-  PicoRV32 RISC-V Core
-  AXI4-Lite or Wishbone interconnect
-  UART (using `simpleuart.v`)
-  On-chip BRAM for instructions/data
- ⚡ Ultra low power profile targeting iCE40 FPGAs

## Development Setup
- FPGA: iCE40UP5K (VSD Squadron Mini)
- Toolchain: Yosys, NextPNR, OpenFPGALoader
- Language: Verilog, C (firmware)
- Optional: GTKWave, PulseView for debugging

##  Current Progress
- [x] PicoRV32 Core integrated
- [x] UART bridge connected
- [ ] Instruction memory from BRAM
- [ ] Memory-mapped IO devices
- [ ] UART test via firmware `hello.c`


