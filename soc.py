from migen import *
from litex.gen import *
from litex_boards.platforms import lattice_ice40up5k_evn
from litex.soc.integration.soc_core import *
from litex.soc.integration.builder import *
from litex.soc.interconnect import wishbone
from litex.build.generic_platform import Pins, IOStandard, Subsignal

# ✅ Minimal Clock Reset Generator
class MiniCRG(Module):
    def __init__(self, clk):
        self.clock_domains.cd_sys = ClockDomain()
        self.comb += self.cd_sys.clk.eq(clk)


class TinyRAM(Module):
    def __init__(self, size=1024):
        self.bus = wishbone.Interface()
        depth = size // 4  # 32-bit words

        mem = Memory(32, depth)
        port = mem.get_port(write_capable=True)

        self.submodules += port
        self.specials += mem

        # FSM to simulate ack behavior
        self.sync += [
            If(self.bus.stb & self.bus.cyc,
                port.adr.eq(self.bus.adr),
                port.dat_w.eq(self.bus.dat_w),
                port.we.eq(self.bus.we),
                self.bus.dat_r.eq(port.dat_r),
                self.bus.ack.eq(1)
            ).Else(
                self.bus.ack.eq(0)
            )
        ]



# ✅ Add basic IO
def configure_platform():
    platform = lattice_ice40up5k_evn.Platform()
    platform.add_extension([
        ("hw_clk", 0, Pins("20"), IOStandard("LVCMOS33")),
        ("reset",  0, Pins("23"), IOStandard("LVCMOS33")),
        ("uart", 0,
            Subsignal("tx", Pins("14")),
            Subsignal("rx", Pins("15")),
            IOStandard("LVCMOS33")
        ),
        ("led", 0, Pins("40"), IOStandard("LVCMOS33"))
    ])
    return platform


# ✅ Main SoC
class MinimalServSoC(SoCCore):
    def __init__(self):
        platform = configure_platform()
        clk_freq = int(12e6)
        clk = platform.request("hw_clk")
        platform.add_period_constraint(clk, 1e9 / clk_freq)

        self.submodules.crg = MiniCRG(clk)

        SoCCore.__init__(self, platform, clk_freq,
            cpu_type="serv",
            integrated_rom_init="firmware.hex",
            integrated_rom_size=0x0800,  # 2 KB ROM
            integrated_main_ram_size=0,  # 🔥 disable default
            with_uart=True,
            ident="Minimal SERV SoC - VSD Mini"
        )

        # ✅ Custom RAM
        self.submodules.ram = TinyRAM(size=1024)  # 1 KB
        self.bus.add_slave("ram", self.ram.bus, 0x00000000)


# 🚀 Build
def build():
    soc = MinimalServSoC()
    builder = Builder(soc, output_dir="build", compile_software=True)
    builder.build(run=True)


if __name__ == "__main__":
    build()