module tb_multi;

    // Entradas
    logic [3:0] a, b;

    // Salidas
    logic [3:0] Pcirc;

    // Instancia del DUT
    multi dut (
        .a(a),
        .b(b),
        .Pcirc(Pcirc)
    );

    initial begin
        $display(" a  x  b  = Pcirc (bin)\n------------------------");

        a = 4'd3;  b = 4'd2;  #1;
        $display("%2d x %2d = %2d (%b)", a, b, Pcirc, Pcirc);

        a = 4'd4;  b = 4'd5;  #1;
        $display("%2d x %2d = %2d (%b)", a, b, Pcirc, Pcirc);

        a = 4'd7;  b = 4'd7;  #1;
        $display("%2d x %2d = %2d (%b)", a, b, Pcirc, Pcirc);

        a = 4'd15; b = 4'd15; #1;
        $display("%2d x %2d = %2d (%b)", a, b, Pcirc, Pcirc);

        a = 4'd8;  b = 4'd0;  #1;
        $display("%2d x %2d = %2d (%b)", a, b, Pcirc, Pcirc);

        $finish;
    end

endmodule
