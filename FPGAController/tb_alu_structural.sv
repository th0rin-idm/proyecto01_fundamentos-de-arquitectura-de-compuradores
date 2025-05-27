`timescale 1ns/1ps

module tb_alu_structural;

    logic [3:0] A, B;
    logic [1:0] Op;
    logic [3:0] R;
    logic Z, N, C, V;

    alu_structural dut (
        .A(A),
        .B(B),
        .Op(Op),
        .R(R),
        .Z(Z),
        .N(N),
        .C(C),
        .V(V)
    );

    initial begin
        $display("Tiempo | Op |   A   |   B   |   R  | Z N C V | Hex | Operación");
        $monitor("%4t   | %b  | %4b | %4b | %4b | %b %b %b %b | %1h   | %s",
                 $time, Op, A, B, R, Z, N, C, V, R, (Op == 2'b00) ? "AND " :
                                                   (Op == 2'b01) ? "XOR " :
                                                   (Op == 2'b10) ? "RESTA" :
                                                                   "MULT ");

        // Operación AND
        Op = 2'b00; A = 4'b1100; B = 4'b1010; #10;

        // Operación XOR
        Op = 2'b01; A = 4'b1100; B = 4'b1010; #10;

        // RESTA sin préstamo: 5 - 3 = 2
        Op = 2'b10; A = 4'b0101; B = 4'b0011; #10;

        // MULTI: 3 * 2 = 6
        Op = 2'b11; A = 4'b0011; B = 4'b0010; #10;

        // RESTA con préstamo: 2 - 4 = -2
        Op = 2'b10; A = 4'b0010; B = 4'b0100; #10;

        // MULTI: 15 * 1 = 15
        Op = 2'b11; A = 4'b1111; B = 4'b0001; #10;

        // RESTA con resultado cero: 4 - 4 = 0
        Op = 2'b10; A = 4'b0100; B = 4'b0100; #10;

        // AND que da cero
        Op = 2'b00; A = 4'b1010; B = 4'b0101; #10;

        $finish;
    end

endmodule
