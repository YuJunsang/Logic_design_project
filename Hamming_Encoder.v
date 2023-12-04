
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