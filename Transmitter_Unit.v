
module Transmitter_Unit(
        output serial_out,
        output clk_tx,
        input [3:0] data_hex,
        input btn1, btn2,
        input clk_in,
        input rstn,
        
        // UART control signal //
        input b_ready,
        input load_data,
        input t_init
    );
    
    wire [7:0] data_enc;
    wire [7:0] data_err_inj;
    
    clk_div16 I_clk_div16 (
        .clk_out(clk_tx), 
        .clk_in(clk_in), 
        .rstn(rstn)
        );
    
    Hamming_Encoder I_Hamming_Encoder (
        .data_out(data_enc), 
        .data_in(data_hex), 
        .clk(clk_tx), 
        .rstn(rstn)
        );
        
    Error_Injection I_Error_Injection (
        .data_out(data_err_inj), 
        .data_in(data_enc), 
        .btn1(btn1),
        .btn2(btn2), 
        .clk(clk_tx), 
        .rstn(rstn)
        );
        
    UART_Transmitter I_UART_Transmitter (
        .serial_out(serial_out), 
        .data_bus(data_err_inj), 
        .b_ready(b_ready), 
        .load_data(load_data), 
        .t_init(t_init), 
        .clk(clk_tx), 
        .rstn(rstn)
        );
   
endmodule
