`timescale 1ns / 1ps

module tb;

    reg clk;
    reg rstn;
    
    reg not_ready_in; // for rx
    reg b_ready;
    reg load_data;
    reg t_init;
    
    reg btn1, btn2;
    
    reg [3:0] data_in;
    wire [3:0] data_out;
    wire rx_serial, tx_serial;
    wire err_correctable, err_uncorrectable;
    wire tx_clk;
    assign rx_serial = tx_serial;
    
    initial clk = 1'b1;
    always #10 clk = ~clk;
    
    initial begin
        rstn = 1'b1;
        #2;
        rstn = 1'b0;
        #10;
        rstn = 1'b1;
    end
    
    reg [3:0] btn1_seq = 4'b1010;
    reg [3:0] btn2_seq = 4'b1100;
    reg [7:0] data_in_seq = {4'hA, 4'h4};
    integer i, j;
    
    initial begin
        b_ready <= 1'b0;
        load_data <= 1'b0;
        t_init <= 1'b0;
        not_ready_in <= 1'b0;
        
        for (i=0; i<4; i=i+1) begin
            for (j=0; j<2; j=j+1) begin
                btn1 <= btn1_seq[i];
                btn2 <= btn2_seq[i];
                
                data_in <= data_in_seq[4*j+:4];
                
                @(posedge tx_clk);
                @(posedge tx_clk);
               
                load_data <= 1'b1;
                
                @(posedge tx_clk); load_data <= 1'b0;
                @(posedge tx_clk); b_ready <= 1'b1;
                @(posedge tx_clk); b_ready <= 1'b0;
                @(posedge tx_clk); t_init <= 1'b1;
                @(posedge tx_clk); t_init <= 1'b0;
                @(data_out);
            end
        end
    end
   
    
    TRX_top I_TRX_top (
        .rx_data_out(data_out),
        .rx_err_uncorrectable(err_uncorrectable),
        .rx_err_correctable(err_correctable),
        .rx_serial_in(rx_serial),
        .rx_not_ready_in(not_ready_in),
        .tx_serial_out(tx_serial),
        .tx_clk(tx_clk),
        .tx_data_in(data_in),
        .tx_btn1(btn1),
        .tx_btn2(btn2),
        .tx_b_ready(b_ready),
        .tx_load_data(load_data),
        .tx_t_init(t_init),
        .clk(clk),
        .rstn(rstn)
        );
    
endmodule
