PACKAGES=libc libcompiler_rt libbase libfatfs liblitespi liblitedram libliteeth liblitesdcard liblitesata bios
PACKAGE_DIRS=/home/skanda/work/litex/litex/soc/software/libc /home/skanda/work/litex/litex/soc/software/libcompiler_rt /home/skanda/work/litex/litex/soc/software/libbase /home/skanda/work/litex/litex/soc/software/libfatfs /home/skanda/work/litex/litex/soc/software/liblitespi /home/skanda/work/litex/litex/soc/software/liblitedram /home/skanda/work/litex/litex/soc/software/libliteeth /home/skanda/work/litex/litex/soc/software/liblitesdcard /home/skanda/work/litex/litex/soc/software/liblitesata /home/skanda/work/litex/litex/soc/software/bios
LIBS=libc libcompiler_rt libbase libfatfs liblitespi liblitedram libliteeth liblitesdcard liblitesata
TRIPLE=riscv64-unknown-elf
CPU=femtorv
CPUFAMILY=riscv
CPUFLAGS=-march=rv32i2p0      -mabi=ilp32 -D__femtorv__ 
CPUENDIANNESS=little
CLANG=0
CPU_DIRECTORY=/home/skanda/work/litex/litex/soc/cores/cpu/femtorv
SOC_DIRECTORY=/home/skanda/work/litex/litex/soc
PICOLIBC_DIRECTORY=/home/skanda/.local/lib/python3.10/site-packages/pythondata_software_picolibc/data
PICOLIBC_FORMAT=integer
COMPILER_RT_DIRECTORY=/home/skanda/.local/lib/python3.10/site-packages/pythondata_software_compiler_rt/data
export BUILDINC_DIRECTORY
BUILDINC_DIRECTORY=/home/skanda/picoEdgeSoC/build/software/include
LIBC_DIRECTORY=/home/skanda/work/litex/litex/soc/software/libc
LIBCOMPILER_RT_DIRECTORY=/home/skanda/work/litex/litex/soc/software/libcompiler_rt
LIBBASE_DIRECTORY=/home/skanda/work/litex/litex/soc/software/libbase
LIBFATFS_DIRECTORY=/home/skanda/work/litex/litex/soc/software/libfatfs
LIBLITESPI_DIRECTORY=/home/skanda/work/litex/litex/soc/software/liblitespi
LIBLITEDRAM_DIRECTORY=/home/skanda/work/litex/litex/soc/software/liblitedram
LIBLITEETH_DIRECTORY=/home/skanda/work/litex/litex/soc/software/libliteeth
LIBLITESDCARD_DIRECTORY=/home/skanda/work/litex/litex/soc/software/liblitesdcard
LIBLITESATA_DIRECTORY=/home/skanda/work/litex/litex/soc/software/liblitesata
BIOS_DIRECTORY=/home/skanda/work/litex/litex/soc/software/bios
LTO=0
BIOS_CONSOLE_FULL=1