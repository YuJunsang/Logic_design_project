
module UART_Transmitter (
    output serial_out,
    input [7:0] data_bus,
    input b_ready,
    input load_data,
    input t_init,
    input clk,
    input rstn
);

parameter idle = 2'b00;
parameter waiting = 2'b01;
parameter sending = 2'b10;

reg [7:0] data_reg;
reg [8:0] shift_reg;
reg load_shift;
reg [1:0] state, next_state;
reg [3:0] bit_cnt;
reg clear;
reg shift;
reg start;

assign serial_out = shift_reg[0];

always @(*) begin
    load_shift = 0;
    clear = 0;
    shift = 0;
    start = 0;
    next_state = state;
    case(state)
        idle: begin
            // **** TODO **** //


            // ************** // 
        end
        waiting: begin
            // **** TODO **** //


            // ************** // 
        end
        sending: begin
            // **** TODO **** //


            // ************** // 
        end
        default: next_state = idle;
    endcase
end

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        state <= idle;
    end
    else begin
        state <= next_state;
    end
end

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        // **** TODO **** //


        // ************** // 
    end
    else begin
        // **** TODO **** //


        // ************** // 
    end
end

endmodule