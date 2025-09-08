module receiver (
    input clk,
    input rst_n,
    input baud_tick,
    input rx_in,
    output reg [7:0] rx_data,
    output reg rx_data_valid
);

    parameter IDLE = 0;
    parameter START_BIT = 1;
    parameter DATA_BITS = 2;
    parameter STOP_BIT = 3;

    reg [2:0] state;
    reg [3:0] bit_count;
    reg [7:0] data_buffer;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            rx_data_valid <= 0;
            bit_count <= 0;
            data_buffer <= 0;
        end else begin
            case (state)
                IDLE: begin
                    rx_data_valid <= 0;
                    if (!rx_in) begin 
                        state <= START_BIT;
                    end
                end
                START_BIT: begin
                    if (baud_tick) begin
                
                        if (!rx_in) begin
                            state <= DATA_BITS;
                            bit_count <= 0;
                        end else begin 
                            state <= IDLE;
                        end
                    end
                end
                DATA_BITS: begin
                    if (baud_tick) begin
                        data_buffer[bit_count] <= rx_in;
                        if (bit_count == 7) begin
                            state <= STOP_BIT;
                        end else begin
                            bit_count <= bit_count + 1;
                        end
                    end
                end
                STOP_BIT: begin
                    if (baud_tick) begin
                        if (rx_in) begin
                            rx_data <= data_buffer;
                            rx_data_valid <= 1;
                        end
                        state <= IDLE;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule
