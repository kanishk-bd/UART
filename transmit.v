module transmit(
	input wire clk , 
	input wire rst_n,
	input wire baud_tick, 
	input wire [7:0] tx_data ,  
	output wire tx_out, 
	output wire tx_busy

);
// These are like constanst ( # define used in c )
parameter IDLE = 2'b00;
parameter START_BIT = 2'b01;
parameter DATA_BIT = 2'b10;
parameter STOP_BIT = 2'b11;

reg [7:0] data_reg;
reg [2:0] bit_counter;
reg [1:0] state;
reg tx_out_reg;
reg tx_busy_rg;

always @ ( posedge clk or negedge rst_n ) begin
	if(!rst_n) begin
		state <= IDLE;
		// send bit to output(transmit)
		tx_out_reg <= 1'b1; // line idle  = high
		tx_busy_reg <= 1'b0;
		bit_counter <= 4'd0;
		shift_reg <=8'd0;
	end
	else if(baud_tick)begin 
		case (state)
			IDLE: begin
				// idle means ready to transmit 
				tx_out_reg <= 1'b1;
				tx_busy_reg <= 1'b0;
				if(tx_start) begin
					state <= START_BIT;
					shift_reg <= tx_data;
					txt_busy_reg <= 1'b1;
				end 
			end
			START_BIT : begin
			// send start bit 0 . 
			tx_out_reg <= 1'b0;    // start bit is low
			state      <= DATA_BITS;
			// change state to data bit 
			bit_counter <= 4'd0;
			// counter increment to 0 to send 0th bit 
				end 
			DATA_BITS: begin
			tx_out_reg <= shift_reg[0];                 // put out
			shift_reg  <= {1'b0, shift_reg[7:1]};       // logical right shift
			if (bit_counter == 4'd7) begin
  			state <= STOP_BIT;
			end else begin
  			bit_counter <= bit_counter + 1;
			end
			STOP_BIT: begin 
			tx_out_reg  <= 1'b1;  // stop bit high
			state       <= IDLE;
			tx_busy_reg <= 1'b0;
			end
		end 


// Output assigns to wire (pins)
    assign tx_out  = tx_out_reg;
    assign tx_busy = tx_busy_reg;

endmodule
			















