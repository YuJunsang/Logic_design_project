/////////유의미한지는 모르겠지만 ^*^///////

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
reg [3:0] sample_cnt;
reg [4:0] bit_cnt;
reg [1:0] state, next_state;
//reg inc_bit_cnt, clr_bit_cnt;
//reg inc_sample_cnt, clr_sample_cnt;
reg shift, load;

initial begin
    load = 0;
    error1 = 1'b0;
    error2 = 1'b0;
    not_ready_out = 1'b1; // 준비가 안됨
    data_reg = 8'b00000000;
end

always @(*) begin
    next_state = state;
    
    case (state)
        idle: begin
            // **** TODO **** //
            if (serial_in == 0) next_state = starting;
            else next_state = idle;
            // ************** // 
        end
        starting: begin
            // **** TODO **** //
                if (sample_cnt == 3'b011 && serial_in == 0) next_state = receiving;
                else if (serial_in == 1) next_state = idle; // noise라 판단
                else next_state = starting;
            // ************** // 
        end
        receiving: begin
            // **** TODO **** //
                if (load) begin
                    next_state = idle;
                    load = 0;
                end else next_state = receiving;
            // ************** // 
        end
        default: next_state = idle;
    endcase
end

always @(posedge sample_clk or negedge rstn) begin
    $display("UART tx/clk: %b", serial_in);
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
        if (state == idle) begin
        end 
        
        else if (state == starting) begin
            sample_cnt = sample_cnt + 3'b001; // sample cnt 3 되는 순간 다음 clk은 receiving state 돌입되어 있음
        end
        
        else begin // state == receiving
            sample_cnt = sample_cnt + 3'b001; // sample_cnt 3->4에서 시작
            if (sample_cnt == 3) begin // 8번 돈 후 data[0]부터 shift
                bit_cnt = bit_cnt + 4'b1; 
                if (bit_cnt == 4'b1001) begin // bit_cnt = 9일 때 stop_bit(1) 받음
                    not_ready_out = 1'b0; // 준비완료
                    load = 1; // 다음 clk에서 idle 상태로 가있음
                    if (!serial_in) error2 = 1'b1;
                    if (not_ready_in) error1 = 1'b1;
                    if (!error1 && !error2) data_reg <= shift_reg; // bit_cnt == 8이면 shift_reg는 data로만 이루어짐
                end else begin // bit <= 8이면 shift_reg에 저장
                    shift_reg = {serial_in, shift_reg[7:1]};
                end
            end
        end  
        // ************** // 
    end
end

endmodule



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

initial load = 0;
initial error1 = 1'b0;
initial error2 = 1'b0;
initial not_ready_out = 1'b1;

always @(*) begin
    next_state = state;
    
    case (state)
        idle: begin
            // **** TODO **** //
            if (serial_in == 0) next_state <= starting;
            else next_state <= idle;
            // ************** // 
        end
        starting: begin
            // **** TODO **** //
                if (sample_cnt == 3'b011 && serial_in == 0) next_state <= receiving;
                else if (serial_in == 1) next_state <= idle;
                else next_state <= starting;
            // ************** // 
        end
        receiving: begin
            // **** TODO **** //
                if (load) begin
                    next_state <= idle;
                    load = 0;
                end else next_state <= receiving;
            // ************** // 
        end
        default: next_state = idle;
    endcase
end

always @(posedge sample_clk or negedge rstn) begin
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
        if (state == idle) begin
        
        end else if (state == starting) begin
            sample_cnt = sample_cnt + 1;
        end else begin // state == receiving
            sample_cnt = sample_cnt + 1;
            if (bit_cnt == 9) begin 
                if (!serial_in) error2 = 1'b1;
                if (not_ready_in) error1 = 1'b1;
                if (!error1 && !error2) data_reg <= shift_reg;
                not_ready_out = 1'b0;
                load = 1;
                
            end else if (sample_cnt == 3'b011) begin
                shift_reg <= {serial_in, shift_reg[7:1]};
                bit_cnt = bit_cnt + 1;
                
            end 
        
        end
                
        // ************** // 
    end
end

endmodule
