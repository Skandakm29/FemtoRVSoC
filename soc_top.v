// soc_top.v - Top-level SoC with PicoRV32, BRAM, SimpleUART, and HFOSC

`include "simpleuart.v"
`include "picorv32.v"
`include "bram.v"

module soc_top(
    output wire uarttx,
    input wire  hw_clk,
    output wire led_red,
    output wire led_blue,
    output wire led_green
);

    // High-Frequency Oscillator (12 MHz)
    wire int_osc;
    SB_HFOSC #(.CLKHF_DIV("0b10")) hfosc_inst (
        .CLKHFPU(1'b1),
        .CLKHFEN(1'b1),
        .CLKHF(int_osc)
    );

    wire clk = int_osc;
    wire resetn;
    reg [7:0] reset_cnt = 0;
    assign resetn = &reset_cnt;

    always @(posedge clk) begin
        reset_cnt <= reset_cnt + !resetn;
    end

    reg [7:0] debug_led_reg;

    always @(posedge clk) begin
        if (!resetn) begin
            debug_led_reg <= 8'h00;
        end else if (uart_sel && mem_valid && |mem_wstrb) begin
            debug_led_reg <= mem_wdata[7:0]; // Capture UART byte written
        end
    end

    SB_RGBA_DRV RGB_DRIVER (
        .RGBLEDEN(1'b1),
        .RGB0PWM (debug_led_reg[0]),
        .RGB1PWM (debug_led_reg[1]),
        .RGB2PWM (debug_led_reg[2]),
        .CURREN  (1'b1),
        .RGB0    (led_green),
        .RGB1    (led_blue),
        .RGB2    (led_red)
    );
    defparam RGB_DRIVER.RGB0_CURRENT = "0b000001";
    defparam RGB_DRIVER.RGB1_CURRENT = "0b000001";
    defparam RGB_DRIVER.RGB2_CURRENT = "0b000001";

    // PicoRV32 memory bus
    wire        mem_valid;
    wire        mem_instr;
    wire        mem_ready;
    wire [31:0] mem_addr;
    wire [31:0] mem_wdata;
    wire [3:0]  mem_wstrb;
    wire [31:0] mem_rdata;

    // BRAM signals
    wire bram_sel = (mem_addr[31:28] == 4'h0); // 0x00000000 - 0x0FFFFFFF
    wire bram_ready;
    wire [31:0] bram_rdata;

    // UART signals
    wire uart_sel = (mem_addr[31:24] == 8'h02); // 0x02000000 - UART
    wire uart_ready;
    wire [31:0] uart_rdata;

    // Memory mux
    assign mem_ready = bram_sel ? bram_ready :
                       uart_sel ? uart_ready : 1'b0;
    assign mem_rdata = bram_sel ? bram_rdata :
                       uart_sel ? uart_rdata : 32'h0000_0000;

    // Instantiate PicoRV32
    picorv32 #(
        .ENABLE_MUL(0),
        .ENABLE_DIV(0),
        .ENABLE_FAST_MUL(0),
        .TWO_STAGE_SHIFT(1),
        .ENABLE_COUNTERS(0),
        .ENABLE_COUNTERS64(0),
        .MASKED_IRQ(32'h0000_0000),
        .LATCHED_IRQ(32'h0000_0000),
        .PROGADDR_RESET(32'h0000_0000),
        .STACKADDR(32'h0000_1000)
    ) cpu (
        .clk(clk),
        .resetn(resetn),
        .mem_valid(mem_valid),
        .mem_instr(mem_instr),
        .mem_ready(mem_ready),
        .mem_addr(mem_addr),
        .mem_wdata(mem_wdata),
        .mem_wstrb(mem_wstrb),
        .mem_rdata(mem_rdata),
        .pcpi_valid(),
        .pcpi_insn(),
        .pcpi_rs1(),
        .pcpi_rs2(),
        .pcpi_wr(),
        .pcpi_rd(),
        .pcpi_wait(),
        .pcpi_ready(),
        .irq(32'b0),
        .eoi()
    );

    // Instantiate BRAM
    bram #(
        .MEM_SIZE_BYTES(4096)  // 4 KB
    ) bram_i (
        .clk(clk),
        .resetn(resetn),
        .valid(bram_sel && mem_valid),
        .instr(mem_instr),
        .addr(mem_addr),
        .wdata(mem_wdata),
        .wstrb(mem_wstrb),
        .rdata(bram_rdata),
        .ready(bram_ready)
    );

    // Instantiate SimpleUART
    simpleuart #(
        .DEFAULT_DIV(104) // 115200 baud @ 12MHz
    ) uart_i (
        .clk(clk),
        .resetn(resetn),
        .ser_tx(uarttx),
        .ser_rx(1'b1), // if unused
        .reg_div_we(mem_wstrb),
        .reg_div_di(mem_wdata),
        .reg_div_do(),
        .reg_dat_we(uart_sel && mem_valid && |mem_wstrb),
        .reg_dat_re(uart_sel && mem_valid && !mem_wstrb),
        .reg_dat_di(mem_wdata),
        .reg_dat_do(uart_rdata),
        .reg_dat_wait(uart_ready)
    );

endmodule