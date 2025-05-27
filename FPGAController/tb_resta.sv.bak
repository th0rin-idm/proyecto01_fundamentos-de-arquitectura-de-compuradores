module tb_resta;

  // Entradas del módulo bajo prueba
  logic [3:0] A, B;

  // Salida del módulo
  logic [3:0] S;

  // Instancia del módulo resta
  resta dut (
    .A(A),
    .B(B),
    .S(S)
  );

  initial begin
    $display("A    - B    = S");
    $display("--------------------");

    // Pruebas simples
    A = 4'b0101; B = 4'b0011; #1; // 5 - 3 = 2
    $display("%b - %b = %b", A, B, S);

    A = 4'b1000; B = 4'b0010; #1; // 8 - 2 = 6
    $display("%b - %b = %b", A, B, S);

    A = 4'b0110; B = 4'b0110; #1; // 6 - 6 = 0
    $display("%b - %b = %b", A, B, S);

    A = 4'b0010; B = 4'b0100; #1; // 2 - 4 = -2 → 2's comp: 1110
    $display("%b - %b = %b", A, B, S);

    A = 4'b0000; B = 4'b0001; #1; // 0 - 1 = -1 → 2's comp: 1111
    $display("%b - %b = %b", A, B, S);

    $finish;
  end

endmodule
