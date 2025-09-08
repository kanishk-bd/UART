module baudrate (
    input wire clk,
    input wire rst_n,
    output wire baud_tick
);

parameter CLK_FREQ = 50_000_000; // System clock frequency (e.g., 50 MHz)
parameter BAUD_RATE = 9600;     // Desired baud rate (e.g., 9600 bps)

localparam COUNT_MAX = (CLK_FREQ / BAUD_RATE) - 1;

reg [31:0] counter;
reg baud_tick_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        baud_tick_reg <= 0;
    end else begin
        if (counter == COUNT_MAX) begin
            counter <= 0;
            baud_tick_reg <= 1;
        end else begin
            counter <= counter + 1;
            baud_tick_reg <= 0;
        end
    end
end

assign baud_tick = baud_tick_reg;
endmodule
