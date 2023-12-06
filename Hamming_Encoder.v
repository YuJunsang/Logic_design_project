
module Hamming_Encoder(
    output [7:0] data_out, // P4 D4 D3 D2 P3 D1 P2 P1
    input [3:0] data_in,   // D4 D3 D2 D1
    input clk, rstn
    );

// **** TODO **** //
    reg p1, p2, p3, p4;

    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            data_out <= 8'b00000000; // Reset condition
            p1 <= 1'b0;
            p2 <= 1'b0;
            p3 <= 1'b0;
            p4 <= 1'b0;
        end else begin
            // Data bits assignment
            data_out[6] = data_in[3]; 
            data_out[5] = data_in[2];
            data_out[4] = data_in[1];
            data_out[2] = data_in[0];

            // Parity bit calculations
            p1 = data_in[0] ^ data_in[1] ^ data_in[3];
            p2 = data_in[0] ^ data_in[2] ^ data_in[3];
            p3 = data_in[1] ^ data_in[2] ^ data_in[3];
            p4 = data_in[0] ^ data_in[1] ^ data_in[2];

            // Insert parity bits into data_out
            data_out[0] = p1;
            data_out[1] = p2;
            data_out[3] = p3;
            data_out[7] = p4;
        end
    end
// ************** //

endmodule



// 수정 코드 // 확인부탁ㄱ!
// hamming decoder랑 마찬가지로 data_out은 wire라 바로 always안에서 수정 안되어서 c 따로 선언!
// **** TODO **** //
reg [7:0] c; // don't declare it as an array; c[7:0]

always @ (posedge clk) begin
    if (rstn)  c = 8'b00000000; // reset 시?
    else begin 
        c[0] = (data_in[0] ^ data_in[1] ^ data_in[3]); // P1
        c[1] = (data_in[0] ^ data_in[2] ^ data_in[3]); // P2
        c[2] = data_in[0]; // D1
        c[3] = (data_in[1] ^ data_in[2] ^ data_in[3]); // P3
        c[4] = data_in[1]; // D2
        c[5] = data_in[2]; // D3
        c[6] = data_in[3]; // D4
        c[7] = (data_in[0] ^ data_in[1] ^ data_in[2]); // P4
    end
end

assign data_out = c;
// ************** //
