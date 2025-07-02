module bram #(
    parameter MEM_SIZE_BYTES = 4096
) (
    input clk,
    input resetn,
    input valid,
    input instr,
    input [31:0] addr,
    input [31:0] wdata,
    input [3:0]  wstrb,
    output [31:0] rdata,
    output ready
);

    localparam MEM_WORDS = MEM_SIZE_BYTES / 4;

    reg [31:0] mem [0:MEM_WORDS-1];
    reg [31:0] rdata_reg;
    reg ready_reg;

    assign rdata = rdata_reg;
    assign ready = ready_reg;

    wire [31:0] word_addr = addr[31:2];

    // === Preload Firmware ===
    initial begin
        $readmemh("firmware.hex", mem);
    end

    always @(posedge clk) begin
        ready_reg <= 0;
        if (valid && !ready_reg) begin
            ready_reg <= 1;
            rdata_reg <= mem[word_addr];
            if (wstrb[0]) mem[word_addr][ 7: 0] <= wdata[ 7: 0];
            if (wstrb[1]) mem[word_addr][15: 8] <= wdata[15: 8];
            if (wstrb[2]) mem[word_addr][23:16] <= wdata[23:16];
            if (wstrb[3]) mem[word_addr][31:24] <= wdata[31:24];
        end
    end

endmodule
