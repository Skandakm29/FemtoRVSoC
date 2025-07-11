# Minimal SERV SoC for iCE40UP5K (VSD Mini)

This project implements a minimal RISC-V SoC using the [SERV core](https://github.com/olofk/serv), the world's smallest RISC-V CPU, on the Lattice iCE40UP5K FPGA via the VSD Mini FPGA board. The SoC is built using [LiteX](https://github.com/enjoy-digital/litex) and [Migen](https://github.com/m-labs/migen).

## Features

- SERV: Bit-serial RISC-V CPU (RV32I)
- LiteX SoC: Custom SoCCore with minimal peripherals
- 12 MHz internal oscillator using SB_HFOSC (wired to Pin 20)
- Memory-mapped LED and UART output
- Firmware loaded from ROM (`firmware.hex`)
- Minimal RAM using register-based implementation
- Fits within the LUT and BRAM constraints of iCE40UP5K

## Board Configuration

- FPGA: Lattice iCE40UP5K
- Board: VSD Mini FPGA Board  
- Package: SG48
- Toolchain: Yosys + NextPNR + IceStorm
- Clock: 12 MHz internal oscillator (Pin 20)
- UART TX/RX: Pin 14 (TX), Pin 15 (RX)
- Reset Pin: Pin 23 (active-high)

## Architecture Overview

1. LiteX and Migen define the SoC structure.
2. A custom `MiniCRG` module connects the internal oscillator to the system clock domain.
3. Memory is implemented using a small synchronous RAM (register-based).
4. The SERV CPU runs firmware (in `firmware.hex`) that performs simple tasks like LED blinking or UART transmission.
5. UART output is enabled and accessible via memory-mapped CSR registers.

## Build Instructions

1. Set up the LiteX environment and install the required toolchain (refer to the [LiteX setup guide](https://github.com/enjoy-digital/litex)).
2. Clone this repository or use the provided `soc.py` script.
3. Place the `firmware.hex` file (generated from RISC-V C/assembly code) in the project directory.
4. Build the design:

```bash
python3 soc.py
