# === Top‑level settings ===
TOP         = soc_top
DEVICE      = up5k
PACKAGE     = sg48
FREQ        = 12
PCF         = soc.pcf

# === RISC-V Toolchain Settings ===
CC          = riscv32-unknown-elf-gcc
OBJCOPY     = riscv32-unknown-elf-objcopy
CFLAGS      = -nostdlib -Os -march=rv32i -mabi=ilp32 -T linker.ld

FIRMWARE_ELF = firmware.elf
FIRMWARE_HEX = firmware.hex

# === Build RISC-V Firmware Only ===
risc: $(FIRMWARE_HEX)

$(FIRMWARE_ELF): main.c linker.ld
	$(CC) $(CFLAGS) -o $@ main.c

$(FIRMWARE_HEX): $(FIRMWARE_ELF)
	$(OBJCOPY) -O verilog $< $@

# === RTL Sources ===
SRCS = \
	soc_top.v \
# === Build Targets ===
all: $(TOP).bin

# Ensure firmware.hex is built before synthesis
$(TOP).json: $(SRCS) $(PCF) $(FIRMWARE_HEX)
	@echo "Running Yosys synthesis..."
	yosys -p " \
		read_verilog -lib +/ice40/cells_sim.v; \
		read_verilog -sv $(SRCS); \
		hierarchy -top $(TOP); \
		synth_ice40 -top $(TOP) -json $@ \
	" 2>&1 | tee yosys.log

$(TOP).asc: $(TOP).json
	@echo "Running place and route with nextpnr..."
	nextpnr-ice40 --$(DEVICE) --package $(PACKAGE) \
		--json $< --pcf $(PCF) --asc $@ --freq $(FREQ)

$(TOP).bin: $(TOP).asc
	@echo "Packing bitstream with icepack..."
	icepack $< $@

# === Flash to FPGA ===
flash: $(TOP).bin
	@echo "Flashing bitstream to FPGA..."
	iceprog $(TOP).bin

# === UART Terminal (9600 baud) ===
terminal:
	sudo picocom -b 115200 /dev/ttyUSB0 --imap lfcrlf,crcrlf --omap delbs,crlf

# === Clean Build Files ===
clean:
	rm -f $(TOP).json $(TOP).asc $(TOP).bin yosys.log \
	      firmware.elf firmware.hex

.PHONY: all risc flash terminal clean
