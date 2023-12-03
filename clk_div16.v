
module clk_div16(
    output clk_out,
    input clk_in, rstn
    );
    
    wire clk_div2_w, clk_div4_w, clk_div8_w;
    
    clk_div2 ICLK_DIV2 (.clk_out(clk_div2_w), .clk_in(clk_in), .rstn(rstn));
    clk_div2 ICLK_DIV4 (.clk_out(clk_div4_w), .clk_in(clk_div2_w), .rstn(rstn));
    clk_div2 ICLK_DIV8 (.clk_out(clk_div8_w), .clk_in(clk_div4_w), .rstn(rstn));
    clk_div2 ICLK_DIV16 (.clk_out(clk_out), .clk_in(clk_div8_w), .rstn(rstn));
    
endmodule
