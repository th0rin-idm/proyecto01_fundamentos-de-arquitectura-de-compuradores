module mux2_1 (
    input  logic sel,
    input  logic A, B,
    output logic Y
);

    logic nsel, w0, w1;

    not g1(nsel, sel);
    and g2(w0, A, nsel);
    and g3(w1, B, sel);
    or  g4(Y, w0, w1);

endmodule
