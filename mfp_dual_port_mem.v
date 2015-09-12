module mfp_dual_port_mem
# (
    parameter ADDR_WIDTH = 6,
    parameter DATA_WIDTH = 8
)
(
    input                         clk,
    input      [ADDR_WIDTH - 1:0] read_addr,
    input      [ADDR_WIDTH - 1:0] write_addr,
    input      [DATA_WIDTH - 1:0] write_data,
    input                         write_enable,
    output reg [DATA_WIDTH - 1:0] read_data
);

    reg [DATA_WIDTH - 1:0] mem [(1 << ADDR_WIDTH) - 1:0];

    always @ (posedge clk)
    begin
        if (write_enable)
            mem [write_addr] <= write_data;

        read_data <= mem [read_addr];
    end

endmodule
