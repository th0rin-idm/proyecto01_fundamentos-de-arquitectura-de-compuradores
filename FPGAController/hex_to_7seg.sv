module hex_to_7seg (
    input  logic [3:0] hex,      // Entrada de 4 bits (0-F)
    output logic [6:0] seg       // Salida para 7 segmentos {a,b,c,d,e,f,g}
                                // seg[0] = a, ..., seg[6] = g
);

    // Asignar bits de entrada para claridad
    logic s3, s2, s1, s0;
    always_comb begin
        s3 = hex[3];
        s2 = hex[2];
        s1 = hex[1];
        s0 = hex[0];
    end

    // Definición booleana de cada segmento (1 = encendido, activo alto)
    assign seg[0] = (~s3 & ~s2 & ~s1 & ~s0) | // 0
                    (~s3 & ~s2 &  s1 & ~s0) | // 2
                    (~s3 & ~s2 &  s1 &  s0) | // 3
                    (~s3 &  s2 & ~s1 &  s0) | // 5
                    (~s3 &  s2 &  s1 & ~s0) | // 6
                    (~s3 &  s2 &  s1 &  s0) | // 7
                    ( s3 & ~s2 & ~s1 & ~s0) | // 8
                    ( s3 & ~s2 & ~s1 &  s0) | // 9
                    ( s3 & ~s2 &  s1 & ~s0) | // A
                    ( s3 &  s2 & ~s1 & ~s0) | // C
                    ( s3 &  s2 &  s1 & ~s0) | // E
                    ( s3 &  s2 &  s1 &  s0);  // F

    assign seg[1] = (~s3 & ~s2 & ~s1 & ~s0) | // 0
                    (~s3 & ~s2 & ~s1 &  s0) | // 1
                    (~s3 & ~s2 &  s1 & ~s0) | // 2
                    (~s3 & ~s2 &  s1 &  s0) | // 3
                    (~s3 &  s2 & ~s1 & ~s0) | // 4
                    (~s3 &  s2 &  s1 &  s0) | // 7
                    ( s3 & ~s2 & ~s1 & ~s0) | // 8
                    ( s3 & ~s2 & ~s1 &  s0) | // 9
                    ( s3 & ~s2 &  s1 & ~s0) | // A
                    ( s3 &  s2 & ~s1 &  s0);  // D

    assign seg[2] = (~s3 & ~s2 & ~s1 & ~s0) | // 0
                    (~s3 & ~s2 & ~s1 &  s0) | // 1
                    (~s3 & ~s2 &  s1 &  s0) | // 3
                    (~s3 &  s2 & ~s1 & ~s0) | // 4
                    (~s3 &  s2 & ~s1 &  s0) | // 5
                    (~s3 &  s2 &  s1 & ~s0) | // 6
                    (~s3 &  s2 &  s1 &  s0) | // 7
                    ( s3 & ~s2 & ~s1 & ~s0) | // 8
                    ( s3 & ~s2 & ~s1 &  s0) | // 9
                    ( s3 & ~s2 &  s1 & ~s0) | // A
                    ( s3 & ~s2 &  s1 &  s0) | // B
                    ( s3 &  s2 & ~s1 &  s0);  // D

    assign seg[3] = (~s3 & ~s2 & ~s1 & ~s0) | // 0
                    (~s3 & ~s2 &  s1 & ~s0) | // 2
                    (~s3 & ~s2 &  s1 &  s0) | // 3
                    (~s3 &  s2 & ~s1 &  s0) | // 5
                    (~s3 &  s2 &  s1 & ~s0) | // 6
                    ( s3 & ~s2 & ~s1 & ~s0) | // 8
                    ( s3 & ~s2 &  s1 &  s0) | // B
                    ( s3 &  s2 & ~s1 & ~s0) | // C
                    ( s3 &  s2 & ~s1 &  s0) | // D
                    ( s3 &  s2 &  s1 & ~s0);  // E

    assign seg[4] = (~s3 & ~s2 & ~s1 & ~s0) | // 0
                    (~s3 & ~s2 &  s1 & ~s0) | // 2
                    (~s3 &  s2 &  s1 & ~s0) | // 6
                    ( s3 & ~s2 & ~s1 & ~s0) | // 8
                    ( s3 & ~s2 &  s1 & ~s0) | // A
                    ( s3 & ~s2 &  s1 &  s0) | // B
                    ( s3 &  s2 & ~s1 & ~s0) | // C
                    ( s3 &  s2 & ~s1 &  s0) | // D
                    ( s3 &  s2 &  s1 & ~s0) | // E
                    ( s3 &  s2 &  s1 &  s0);  // F

    assign seg[5] = (~s3 & ~s2 & ~s1 & ~s0) | // 0
                    (~s3 &  s2 & ~s1 & ~s0) | // 4
                    (~s3 &  s2 & ~s1 &  s0) | // 5
                    (~s3 &  s2 &  s1 & ~s0) | // 6
                    ( s3 & ~s2 & ~s1 & ~s0) | // 8
                    ( s3 & ~s2 & ~s1 &  s0) | // 9
                    ( s3 & ~s2 &  s1 & ~s0) | // A
                    ( s3 & ~s2 &  s1 &  s0) | // B
                    ( s3 &  s2 & ~s1 & ~s0) | // C
                    ( s3 &  s2 &  s1 & ~s0) | // E
                    ( s3 &  s2 &  s1 &  s0);  // F

    assign seg[6] = (~s3 & ~s2 &  s1 & ~s0) | // 2
                    (~s3 & ~s2 &  s1 &  s0) | // 3
                    (~s3 &  s2 & ~s1 & ~s0) | // 4
                    (~s3 &  s2 & ~s1 &  s0) | // 5
                    (~s3 &  s2 &  s1 & ~s0) | // 6
                    ( s3 & ~s2 & ~s1 & ~s0) | // 8
                    ( s3 & ~s2 & ~s1 &  s0) | // 9
                    ( s3 & ~s2 &  s1 & ~s0) | // A
                    ( s3 & ~s2 &  s1 &  s0) | // B
                    ( s3 &  s2 & ~s1 &  s0) | // D
                    ( s3 &  s2 &  s1 & ~s0) | // E
                    ( s3 &  s2 &  s1 &  s0);  // F

endmodule
