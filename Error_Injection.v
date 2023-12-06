
module Error_Injection(
        output [7:0] data_out,
        input [7:0] data_in,
        input btn1, btn2,
        input clk, rstn
    );

// **** TODO **** //
reg [7:0] c;

always @ (posedge clk) begin
    if (rstn)  c = 8'b00000000; // reset 시?
    else begin
        c = data_in;
        if(btn1 && btn2) begin
            c[0] = ~c[0];
            c[4] = ~c[4];
        end else if (btn1) begin
            c[0] = ~c[0];
        end else if (btn2) begin
            c[4] = ~c[4];
        end else ;
    end
end
assign data_out = c;
// ************** // 

endmodule
