module mux2_1_4bits (
    input  logic       sel,
    input  logic [3:0] A, B,
    output logic [3:0] Y
);

    mux2_1 m0(.sel(sel), .A(A[0]), .B(B[0]), .Y(Y[0]));
    mux2_1 m1(.sel(sel), .A(A[1]), .B(B[1]), .Y(Y[1]));
    mux2_1 m2(.sel(sel), .A(A[2]), .B(B[2]), .Y(Y[2]));
    mux2_1 m3(.sel(sel), .A(A[3]), .B(B[3]), .Y(Y[3]));

endmodule
