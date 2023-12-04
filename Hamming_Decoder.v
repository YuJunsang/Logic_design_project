
module Hamming_Decoder(
    output [3:0] data_out,
    output err_uncorrectable, err_correctable,
    input [7:0] data_in,
    input clk, rstn
    );
    /*
    data_in[0] : P1
    data_in[1] : P2
    data_in[2] : D1
    data_in[3] : P3
    data_in[4] : D2
    data_in[5] : D3
    data_in[6] : D4
    data_in[7] : P4
    */

// **** TODO **** //
    reg A, B, C, D;
    reg err_single_bit, err_double_bit;

    // Syndrome(A, B, C, D) calculation
    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            A <= 1'b0;
            B <= 1'b0;
            C <= 1'b0;
            D <= 1'b0;
            err_single_bit <= 1'b0;
            err_double_bit <= 1'b0;
            data_out <= 4'b0000;
            err_uncorrectable <= 1'b0;
            err_correctable <= 1'b0;
        end else begin
            // Syndrome calculation
            A = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6];
            B = data_in[1] ^ data_in[2] ^ data_in[5] ^ data_in[6];
            C = data_in[1] ^ data_in[4] ^ data_in[5] ^ data_in[6];
            D = data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7];

            // Error number check 
            err_single_bit = (D == 1'b1);
            err_double_bit = (err_single_bit && (A | B | C));

            // Error correctable check
            // 
            if (err_single_bit) begin
                if (A) begin
                    data_out[0] <= ~data_in[2];
                end
                if (B) begin
                    data_out[1] <= ~data_in[4];
                end
                if (C) begin
                    data_out[2] <= ~data_in[6];
                end
                err_correctable <= 1'b1;
            end else if (err_double_bit) begin
                err_uncorrectable <= 1'b1;
            end else begin
                // No errors => Syndrome=(0,0,0,0)
                data_out <= {data_in[2], data_in[4], data_in[6], data_in[7]};
            end
        end
    end
// ************** //

endmodule
