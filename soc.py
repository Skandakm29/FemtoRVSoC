#!/usr/bin/env python3

from migen import *
from litex.gen import *

from platforms import vsd_mini_fpga  # Your board platform
from litex.soc.integration.soc_core import SoCMini
from litex.soc.integration.builder import Builder
from litex.soc.cores.gpio import GPIOOut  # ✅ Import GPIO
from litex.soc.cores import uart

#  Clock Reset Generator
class MiniCRG(Module):
    def __init__(self, clk):
        self.clock_domains.cd_sys = ClockDomain()
        self.comb += self.cd_sys.clk.eq(clk)

#  Minimal FemtoRV SoC
class MinimalFemtoRVSoC(SoCMini):
    def __init__(self):
        platform = vsd_mini_fpga.Platform()
        clk_freq = int(12e6)

        #  Request and constrain clock
        clk = platform.request("clk12")
        platform.add_period_constraint(clk, 1e9 / clk_freq)
        self.submodules.crg = MiniCRG(clk)

        #  SoC Configuration
        SoCMini.__init__(self, platform, clk_freq,
            cpu_type="femtorv",
            cpu_variant="quark",
            integrated_rom_init="firmware/riscv_logo.bram.hex",
            integrated_rom_size=0x0800,  # 2 KB ROM
            integrated_main_ram_size=0,  # No RAM
        )

        self.add_uart(name="serial")  # ✅ Add UART for console prints

        # ✅ Add RGB LEDs as GPIO Outputs
        led_pads = [
            platform.request("led_red"),
            platform.request("led_green"),
            platform.request("led_blue")
        ]
        self.submodules.leds = GPIOOut(Cat(*led_pads))  # Create GPIO from list
        self.add_csr("leds")  # Expose CSR for firmware control

# 🔨 Build Entry
def main():
    soc = MinimalFemtoRVSoC()
    builder = Builder(soc,
        output_dir="build",
        compile_software=False,
        csr_csv="build/gateware/csr.csv"  # For CSR address access
    )
    builder.build(run=True)

if __name__ == "__main__":
    main()
