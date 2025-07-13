#!/usr/bin/env python3

from migen import *
from litex.gen import *

from platforms import vsd_mini_fpga  # VSD Mini FPGA platform
from litex.soc.integration.soc_core import *
from litex.soc.integration.builder import *

# ✅ Simple Clock/Reset Generator
class MiniCRG(Module):
    def __init__(self, clk):
        self.clock_domains.cd_sys = ClockDomain()
        self.comb += self.cd_sys.clk.eq(clk)

# ✅ Minimal SERV SoC: ROM only, UART enabled
class MinimalServSoC(SoCCore):
    def __init__(self):
        platform = vsd_mini_fpga.Platform()
        clk_freq = int(12e6)

        clk = platform.request("clk12")
        platform.add_period_constraint(clk, 1e9 / clk_freq)
        self.submodules.crg = MiniCRG(clk)

        SoCCore.__init__(self, platform, clk_freq,
            cpu_type="serv",
            integrated_rom_init="firmware.hex",  # Your compiled code
            integrated_rom_size=0x0800,          # 2 KB ROM
            integrated_main_ram_size=0,          # ❌ NO RAM
            with_uart=True,                      # ✅ UART enabled
            ident="Minimal SERV SoC - ROM only"
        )

# ✅ Build the SoC
def main():
    soc = MinimalServSoC()
    builder = Builder(soc, output_dir="build", compile_software=False)
    builder.build(run=True)

if __name__ == "__main__":
    main()
