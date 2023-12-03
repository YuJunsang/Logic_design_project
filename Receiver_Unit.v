
module Receiver_Unit(
        output [3:0] data_dec,
        output err_uncorrectable, err_correctable,
        input serial_in,
        input clk_in,
        input rstn,
        
        // UART control signal //
        input not_ready_in
    );
    
    wire [7:0] data_out_uart;
    
    UART_Receiver I_UART_Receiver (
        .data_reg(data_out_uart), 
        .not_ready_out(not_ready_out), 
        .error1(error1), 
        .error2(error2), 
        .serial_in(serial_in), 
        .not_ready_in(not_ready_in),
        .sample_clk(clk_rx), 
        .rstn(rstn)
        );
        
    Hamming_Decoder I_Hamming_Decoder (
        .data_out(data_dec),
        .err_uncorrectable(err_uncorrectable),
        .err_correctable(err_correctable),
        .data_in(data_out_uart),
        .clk(clk_rx),
        .rstn(rstn)
        );
        
    clk_div2 I_clk_div2 (
        .clk_out(clk_rx),
        .clk_in(clk_in),
        .rstn(rstn)
        );
        
endmodule
