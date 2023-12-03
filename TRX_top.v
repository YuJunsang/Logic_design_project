
module TRX_top(
        output [3:0] rx_data_out,
        output rx_err_uncorrectable,
        output rx_err_correctable,
        input rx_serial_in,
        input rx_not_ready_in,
        
        output tx_serial_out,
        output tx_clk,
        input [3:0] tx_data_in,
        input tx_btn1,
        input tx_btn2,
        input tx_b_ready,
        input tx_load_data,
        input tx_t_init,
        
        input clk,
        input rstn
    );
    
    Receiver_Unit I_Receiver_Unit (
        .data_dec(rx_data_out),
        .err_uncorrectable(rx_err_uncorrectable),
        .err_correctable(rx_err_correctable),
        .serial_in(rx_serial_in), 
        .clk_in(clk), 
        .rstn(rstn), 
        .not_ready_in(rx_not_ready_in)
        );
        
    Transmitter_Unit I_Transmitter_Unit (
        .serial_out(tx_serial_out), 
        .clk_tx(tx_clk),
        .data_hex(tx_data_in), 
        .btn1(tx_btn1),
        .btn2(tx_btn2),
        .clk_in(clk),
        .rstn(rstn),
        .b_ready(tx_b_ready),
        .load_data(tx_load_data),
        .t_init(tx_t_init)
        );
    
endmodule
