module mux4_1 (
    input  logic [1:0] sel,
    input  logic D0, D1, D2, D3,
    output logic Y
);

    logic w0, w1;

    mux2_1 m0(.sel(sel[0]), .A(D0), .B(D1), .Y(w0));
    mux2_1 m1(.sel(sel[0]), .A(D2), .B(D3), .Y(w1));
    mux2_1 m2(.sel(sel[1]), .A(w0), .B(w1), .Y(Y));

endmodule
