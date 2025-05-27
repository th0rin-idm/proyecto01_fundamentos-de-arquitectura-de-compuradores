module mux2_1 (
    input  logic sel,
    input  logic A, B,
    output logic Y
);
    logic nsel, w0, w1;
    not g0(nsel, sel);
    and g1(w0, A, nsel);
    and g2(w1, B, sel);
    or  g3(Y, w0, w1);
endmodule
