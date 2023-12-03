
module UART_Receiver(
    output reg [7:0] data_reg,
    output reg not_ready_out, error1, error2,
    input serial_in,
    input not_ready_in,
    input sample_clk,
    input rstn
    );

parameter idle = 2'b00;
parameter starting = 2'b01;
parameter receiving = 2'b10;

reg [7:0] shift_reg;
reg [3:0] sample_cnt;
reg [4:0] bit_cnt;
reg [1:0] state, next_state;
reg inc_bit_cnt, clr_bit_cnt;
reg inc_sample_cnt, clr_sample_cnt;
reg shift, load;

always @(*) begin
    not_ready_out = 0;
    clr_sample_cnt = 0;
    clr_bit_cnt = 0;
    inc_sample_cnt = 0;
    inc_bit_cnt = 0;
    shift = 0;
    error1 = 0;
    error2 = 0;
    load = 0;
    next_state = state;
    
    case (state)
        idle: begin
            // **** TODO **** //


            // ************** // 
        end
        starting: begin
            // **** TODO **** //


            // ************** // 
        end
        receiving: begin
            // **** TODO **** //


            // ************** // 
        end
        default: next_state = idle;
    endcase
end

always @(posedge sample_clk or negedge rstn) begin
    if(!rstn) begin
        state <= idle;
        // **** TODO **** //


        // ************** // 
    end
    else begin
        state <= next_state;
        // **** TODO **** //


        // ************** // 
    end
end

endmodule

