module tb_fulladder;

  // Entradas al DUT (Device Under Test)
  logic A, B, Cin;

  // Salidas del DUT
  logic S, Cout;

  // Instancia del módulo fulladder
  fulladder dut (
    .A(A),
    .B(B),
    .Cin(Cin),
    .S(S),
    .Cout(Cout)
  );

  // Procedimiento de prueba
  initial begin
    $display("A B Cin | S Cout");
    $display("---------------");

    // Prueba de todas las combinaciones posibles (8 en total)
    for (int i = 0; i < 8; i++) begin
      {A, B, Cin} = i;
      #1; // Esperar un ciclo de simulación
      $display("%b %b  %b  | %b   %b", A, B, Cin, S, Cout);
    end

    $finish;
  end

endmodule
