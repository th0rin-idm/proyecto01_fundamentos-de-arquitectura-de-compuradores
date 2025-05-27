`timescale 1ns/1ps

module tb_alu_structural;

    // Entradas
    logic [3:0] A, B;
    logic [1:0] Op;

    // Salida
    logic [3:0] R;

    // Instancia del módulo ALU
    alu_structural dut (
        .A(A),
        .B(B),
        .Op(Op),
        .R(R)
    );

    initial begin
        $display("Tiempo |  Op |   A   |   B   |   R (resultado)");
        $monitor("%4t   |  %b  | %b | %b | %b", $time, Op, A, B, R);

        // Prueba operación AND (Op = 00)
        Op = 2'b00; A = 4'b1100; B = 4'b1010; #10;  // Esperado: 1000

        // Prueba operación XOR (Op = 01)
        Op = 2'b01; A = 4'b1100; B = 4'b1010; #10;  // Esperado: 0110

        // Prueba operación RESTA (Op = 10)
        Op = 2'b10; A = 4'b0101; B = 4'b0011; #10;  // 5 - 3 = 2 → 0010

        // Prueba operación MULTI (Op = 11)
        Op = 2'b11; A = 4'b0011; B = 4'b0010; #10;  // 3 * 2 = 6 → 0110 (circular)

        // Otro caso RESTA (con acarreo negativo)
        Op = 2'b10; A = 4'b0010; B = 4'b0100; #10;  // 2 - 4 = -2 → complemento: 1110

        // Otro caso MULTI
        Op = 2'b11; A = 4'b1111; B = 4'b0001; #10;  // 15 * 1 = 15 → 1111

        $finish;
    end

endmodule
