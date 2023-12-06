
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




// 수정 후 코드 // 확인바랍니당 
1) wire은 always 안에서 수정이 안되어서 따로 reg c 선언/ always 문 밖에서 마지막에 data_out으로 assign
2) err_double_bit 코드
3) err_single bit 시 수정 코드 
// **** TODO **** //
reg A, B, C, D;
reg err_single_bit, err_double_bit;
reg [3:0] c;

// Syndrome(A, B, C, D) calculation
always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            c = {data_in[6], data_in[5], data_in[4], data_in[2]};
            
            // Syndrome calculation
            A = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6];
            B = data_in[1] ^ data_in[2] ^ data_in[5] ^ data_in[6];
            C = data_in[1] ^ data_in[4] ^ data_in[5] ^ data_in[6];
            D = data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7];

            // Error number check 
            err_single_bit = (D == 1'b1);
            err_double_bit = (!err_single_bit && (A | B | C));

            // Error correctable check
            if (err_single_bit) begin // only correctable error
                if (A && B && !C) begin // D1 error: 1 1 0
                    c[0] = ~c[0];
                end else if (A && !B && C) begin // D2 error : 1 0 1
                    c[1] = ~c[1];
                end else if (!A && B && C) begin // D3 error : 0 1 1
                    c[2] = ~c[2];
                end else if (A && B && C) begin // D4 error : 1 1 1 
                    c[3] = ~c[3];
                end
            end
       end
 end
    
 assign err_uncorrectable = err_double_bit;
 assign err_correctable = err_single_bit;
 assign data_out = c;
// ************** //

endmodule

//







