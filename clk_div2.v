
module clk_div2(
    output reg clk_out,
    input clk_in, rstn
    );
    
    always @(posedge clk_in or negedge rstn) begin
        if(!rstn) clk_out <= 0;
        else clk_out <= !clk_out;
    end
endmodule
