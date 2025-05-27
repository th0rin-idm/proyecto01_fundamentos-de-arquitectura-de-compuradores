`timescale 1ns/1ps

module tb_xor4bits;

    // Entradas
    logic [3:0] A, B;

    // Salida
    logic [3:0] R;

    // Instancia del DUT (Device Under Test)
    xor4bits dut (
        .A(A),
        .B(B),
        .R(R)
    );

    initial begin
        $display("Tiempo |   A   ^   B   =   R");
        $monitor("%4t    | %b ^ %b = %b", $time, A, B, R);

        // Casos de prueba
        A = 4'b0000; B = 4'b0000; #10;
        A = 4'b1111; B = 4'b0000; #10;
        A = 4'b1010; B = 4'b0101; #10;
        A = 4'b1111; B = 4'b1111; #10;
        A = 4'b1100; B = 4'b1010; #10;

        $finish;
    end

endmodule
