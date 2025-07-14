#!/usr/bin/env python3

from migen import *
from litex.gen import *

from platforms import vsd_mini_fpga  # Replace with your actual board platform
from litex.soc.integration.soc_core import SoCMini
from litex.soc.integration.builder import Builder

# ⏱ Clock Reset Generator
class MiniCRG(Module):
    def __init__(self, clk):
        self.clock_domains.cd_sys = ClockDomain()
        self.comb += self.cd_sys.clk.eq(clk)

# 💻 Minimal FemtoRV SoC
class MinimalFemtoRVSoC(SoCMini):
    def __init__(self):
        platform = vsd_mini_fpga.Platform()
        clk_freq = int(12e6)

        # ⏱ Request and constrain clock
        clk = platform.request("clk12")
        platform.add_period_constraint(clk, 1e9 / clk_freq)
        self.submodules.crg = MiniCRG(clk)

        # 🧠 SoC Configuration
        SoCMini.__init__(self, platform, clk_freq,
            cpu_type="femtorv",
            cpu_variant="quark",  # You can also try "petitbateau"
            integrated_rom_init="firmware/firmware.hex",
            integrated_rom_size=0x0800,  # 2 KB
            integrated_main_ram_size=0,  # No RAM
            with_uart=True,              # ✅ CSR-based UART
            with_timer=False             # ❌ No timer
        )

# 🔨 Build Entry
def main():
    soc = MinimalFemtoRVSoC()
    builder = Builder(soc,
        output_dir="build",
        compile_software=False,
        csr_csv="build/gateware/csr.csv"  # ✅ Generate UART base address here
    )
    builder.build(run=True)

if __name__ == "__main__":
    main()
