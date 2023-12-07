//////////////////

module UART_Transmitter (
    output serial_out,
    input [7:0] data_bus, // data_error injector에서 들어옴
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
reg [8:0] shift_reg; // shift_reg[0] 1로 초기화되었다가 start 진행되면 start_bit(0) 으로 바뀜
reg load_shift; // shift_reg에 data_reg 옮기기
reg [1:0] state, next_state;
reg [3:0] bit_cnt; // 전송된 비트수 세기 1001 되는 순간 idle 상태로 변환
reg clear; // 마지막 bit 전송 후 bit_cnt = 0으로 바꾸라는 신호
reg shift; // shift_reg를 shift하라는 의미
reg start; // shift_reg까지 마쳤을 때 tx 시작하라는 신호

assign serial_out = shift_reg[0];

initial begin
    clear = 0;
    start = 0;
    load_shift = 0; 
    shift_reg = 9'b111111111;
    bit_cnt = 4'b0000;
end
    
always @(*) begin
    next_state = state;
    
    case(state)
        idle: begin
            // **** TODO **** //
            if (b_ready) next_state <= waiting;
            else next_state <= idle;
            // ************** // 
        end
        waiting: begin
            // **** TODO **** //
            if (t_init && start) begin
                next_state <= sending;
                start = 0;
            end else next_state <= waiting;
            // ************** // 
        end
        sending: begin
            // **** TODO **** //
            if (clear) begin 
                next_state <= idle;
                clear = 0;
            end else next_state <= sending;
            // ************** // 
        end
        default: next_state = idle;
    endcase
end

always @(posedge clk or negedge rstn) begin
    $display("UART_tx/clk : %b", shift_reg[0]);
    if(!rstn) begin
        // **** TODO **** //
        state <= idle;
        data_reg <= 8'b00000000;
        shift_reg <= 9'b111111111;
        bit_cnt <= 4'b0000;
        clear = 0;
        start = 0;
        load_shift = 0;
     end 
     else begin
         state <= next_state;
         // state와 상관없이 data_input => data_reg
         if (load_data) begin 
            data_reg <= data_bus;
            load_shift = 1; // data_reg가 input data 받았다는 signal
         end
         
        
        case (state)
            idle: begin 
                shift_reg[0] <= 1'b1;
            end
        
            waiting: begin
                if (load_shift) start = 1; // transmission 가능
            end
           
            sending: begin 
                if (bit_cnt == 4'b1001) begin
                    clear = 1; // 다음 clk에서는 sending => idle 상태로
                    bit_cnt <= 4'b0000;
                end
                else if (bit_cnt == 4'b0000) begin // cnt = 0일 때 start_bit(0) 출력
                    shift_reg <= {data_reg, 1'b0};
                    bit_cnt = bit_cnt + 4'b0001;
                end
                else begin // cnt = 1 ~ 8일 때 MSB에 stop_bit(1) 삽입
                    shift_reg <= {1'b1, shift_reg[8:1]};
                    bit_cnt = bit_cnt + 4'b0001;
                end
            end
         endcase
     end
    // ************** // 
end

endmodule

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


// (앞 부분은 동일하게 유지됩니다.)

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        state <= idle;
        // 초기화 또는 리셋 시 필요한 값들 초기화
        data_reg <= 8'b00000000;
        shift_reg <= 9'b111111111;
        bit_cnt <= 4'b0000;
        clear <= 0;
        start <= 0;
    end
    else begin
        case (state)
            idle: begin
                // idle 상태에서의 동작 처리
                if (b_ready)
                    next_state = waiting;
                else
                    next_state = idle;
            end
            waiting: begin
                // waiting 상태에서의 동작 처리
                if (t_init && start) begin
                    next_state = sending;
                    start <= 0;
                end
                else
                    next_state = waiting;
            end
            sending: begin
                // sending 상태에서의 동작 처리
                if (clear) begin 
                    next_state = idle;
                    clear <= 0;
                end
                else
                    next_state = sending;
            end
            default: next_state = idle;
        endcase
    end
end

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        // Reset 조건 처리
    end
    else begin
        // state == idle 일 때의 동작 처리
        if (state == idle) begin
            // idle 상태에서의 동작 처리
            shift_reg[0] <= 1'b1; 
            bit_cnt <= 4'b0000;
        end
        // state == waiting 일 때의 동작 처리
        else if (state == waiting) begin
            // waiting 상태에서의 동작 처리
            // (load_shift 및 load_data 처리)
        end
        // state == sending 일 때의 동작 처리
        else begin 
            // sending 상태에서의 동작 처리
            // (clear 및 bit_cnt 처리, shift_reg shift 처리)
        end
    end
end

// 나머지 코드는 그대로 유지됩니다.



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
reg [8:0] shift_reg; // shift_reg[0] 1로 초기화되었다가 start 진행되면 start_bit(0) 으로 바뀜
reg load_shift; // shift_reg에 data_reg 옮기기
reg [1:0] state, next_state;
reg [3:0] bit_cnt; // 전송된 비트수 세기 1001 되는 순간 idle 상태로 변환
reg clear; // 마지막 bit 전송 후 bit_cnt = 0으로 바꾸라는 신호
reg shift; // shift_reg를 shift하라는 의미
reg start; // shift_reg까지 마쳤을 때 tx 시작하라는 신호

assign serial_out = shift_reg[0];

initial clear = 0;
initial start = 0;
always @(*) begin
    load_shift = 0;
    shift = 0;
    next_state = state;
    case(state)
        idle: begin
            // **** TODO **** //
            if (b_ready) next_state <= waiting;
            else next_state <= idle;
            // ************** // 
        end
        waiting: begin
            // **** TODO **** //
            if (t_init && start) begin
                next_state <= sending;
                start = 0;
            end else next_state <= waiting;
            // ************** // 
        end
        sending: begin
            // **** TODO **** //
            if (clear) begin 
                next_state <= idle;
                clear = 0;
            end else next_state <= sending;
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
        state <= idle;
        data_reg <= 8'b00000000;
        shift_reg <= 9'b111111111;
        bit_cnt <= 4'b0000;
        clear = 0;
        start = 0;
     end else begin
        // state== idle
        if (state == idle) begin
             shift_reg[0] <= 1'b1; 
             bit_cnt <= 4'b0000;
        
        // state== waiting
        end else if (state == waiting) begin
            if (load_shift) begin // data_reg => shift_reg
                shift_reg <= {data_reg, 1'b0};
                start = 1; // sending 준비완료
            end else if (load_data) begin // data_input => data_reg
                data_reg <= data_bus;
                load_shift = 1; // data_reg가 input data 받았다는 signal
            end else load_shift = 0; // data_input => data_reg not ready
            
        // state== sending 
        end else begin 
            if (bit_cnt == 4'b1001) begin
                clear = 1; // sending => idle 상태로
                bit_cnt <= 4'b0000;
            end
            else if (bit_cnt == 4'b0001)begin
                shift_reg <= {1'b1, shift_reg[8:1]};
                bit_cnt = bit_cnt + 1;
            end else begin// bit_cnt < 9
                bit_cnt = bit_cnt + 1;
                shift_reg <= shift_reg >> 1; // 1 right_shift 
            end
        end
    // ************** // 
    end
end

endmodule
