
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

reg [7:0] shift_reg; // output인 data_reg로 load하기 전 저장하는 reg
reg [2:0] sample_cnt; // bit sample을 세는 카운터, 8이 되면 작동
reg [3:0] bit_cnt;
reg [1:0] state, next_state;
reg inc_bit_cnt, clr_bit_cnt;
reg inc_sample_cnt, clr_sample_cnt;
reg shift, load;

initial begin
    load = 0;
    error1 = 1'b0;
    error2 = 1'b0;
    not_ready_out = 1'b1; // 준비가 안됨
    data_reg = 8'b00000000;
end

always @(*) begin
    not_ready_out = 0;
    clr_sample_cnt = 0;
    clr_bit_cnt = 0;
    inc_sample_cnt = 0;
    // inc_bit_cnt = 0; 사용 x shift랑 같이
    shift = 0;
    error1 = 0;
    error2 = 0;
    load = 0;
    next_state = state;
    
    case (state)
        idle: begin
            // **** TODO **** //
            if (serial_in == 0) begin
                next_state = starting;
            end 
            // ************** // 
        end
        starting: begin
            // **** TODO **** //
            if (sample_cnt < 3) begin
                if (serial_in == 1) next_state = idle; // noise라 판단
                else inc_sample_cnt = 1;
            end else if (sample_cnt == 3) begin
             next_state = receiving;
            end
            // ************** // 
        end
        receiving: begin
            // **** TODO **** //
            if (sample_cnt == 3) begin // sample_cnt == 3
                if (bit_cnt < 8) begin
                    shift = 1;
                end else begin // bit_cnt == 8
                    next_state = idle;
                    not_ready_out = 1;
                    load = 1;
                    clr_bit_cnt = 1;
                    clr_sample_cnt = 1;
                end
             end else begin// sample_cnt != 3
                inc_sample_cnt = 1 ;
             end
            // ************** // 
        end
        default: next_state = idle;
    endcase
end

always @(posedge sample_clk or negedge rstn) begin
    
    $display ( "////////////////////");
    $display("UART rx: %b", serial_in);
    $display("rx state:%b", state);
    $display("rx bit_cnt:%b", bit_cnt);
    $display ( "////////////////////");
    
    if(!rstn) begin
        state <= idle;
        // **** TODO **** //
        sample_cnt <= 3'b000;
        bit_cnt <= 4'b0000;
        load = 0;
        // ************** // 
    end
    else begin
        state <= next_state;
        // **** TODO **** //
        if (inc_sample_cnt) begin
            sample_cnt = sample_cnt + 1; // sample cnt 3 되는 순간 다음 clk은 receiving state 돌입되어 있음
        end
        
        if (shift) begin
            shift_reg = {serial_in, shift_reg[7:1]};
            bit_cnt = bit_cnt + 1;
        end
       
        if (load) begin
            if (!serial_in) error2 = 1;
            if (not_ready_in) error1 = 1;
            if (!error1 && !error2) data_reg <= shift_reg; // bit_cnt == 8이면 shift_reg는 data로만 이루어짐
        end  
        
        if (clr_sample_cnt) begin
            sample_cnt = 0;
        end
        
        if (clr_bit_cnt) begin
            bit_cnt = 0;
        end
        // ************** // 
    end
end

endmodule
