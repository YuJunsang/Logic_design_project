
module Hamming_Encoder(
    output [7:0] data_out,
    input [3:0] data_in,
    input clk, rstn
    );

// **** TODO **** //
reg [7:0] c; // don't declare it as an array; c[7:0]

always @ (posedge clk or negedge rstn) begin
    if (rstn) begin // reset 시?
        c[0] = (data_in[0] ^ data_in[1] ^ data_in[3]); // P1
        c[1] = (data_in[0] ^ data_in[2] ^ data_in[3]); // P2
        c[2] = data_in[0]; // D1
        c[3] = (data_in[1] ^ data_in[2] ^ data_in[3]); // P3
        c[4] = data_in[1]; // D2
        c[5] = data_in[2]; // D3
        c[6] = data_in[3]; // D4
        c[7] = (data_in[0] ^ data_in[1] ^ data_in[2]); // P4
    end else // reset
        c = 8'b00000000;
end


assign data_out = c;
$display("incoder data_out: %b",c)

// ************** //

endmodule
