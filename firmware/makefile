# firmware/Makefile
CROSS = riscv32-unknown-elf
CFLAGS = -Os -nostdlib -march=rv32i -mabi=ilp32 -Wall
LDFLAGS = -Ttext=0x00000000 -nostartfiles -Wl,--no-check-sections -Wl,-Bstatic

all: firmware.hex

firmware.elf: main.c
	$(CROSS)-gcc $(CFLAGS) $(LDFLAGS) -o $@ $<

firmware.hex: firmware.elf
	$(CROSS)-objcopy -O verilog $< $@

clean:
	rm -f firmware.elf firmware.hex
