module mfp_dual_port_ram
# (
    parameter ADDR_WIDTH    = 6,
    parameter DATA_WIDTH    = 32,
    parameter INIT_FILENAME = ""
)
(
    input                         clk,
    input      [ADDR_WIDTH - 1:0] read_addr,
    input      [ADDR_WIDTH - 1:0] write_addr,
    input      [DATA_WIDTH - 1:0] write_data,
    input                         write_enable,
    output reg [DATA_WIDTH - 1:0] read_data
);

    reg [DATA_WIDTH - 1:0] ram [(1 << ADDR_WIDTH) - 1:0];

    always @ (posedge clk)
    begin
        if (write_enable)
            ram [write_addr] <= write_data;

        read_data <= ram [read_addr];
    end

    `ifdef MFP_INITIALIZE_MEMORY_FROM_TXT_FILE_FOR_SYNTHESIS

        // Unfortunately neither Xilinx Vivado nor Altera Quartus II
        // support parametrization for synthesizable $readmem

        initial $readmemh ("ram_reset_init.txt", ram);

    `elsif MFP_INITIALIZE_MEMORY_FROM_TXT_FILE_FOR_SIMULATION

        initial $readmemh (INIT_FILENAME, ram);

    `endif

endmodule
