module mux4_1_4bits (
    input  logic [1:0] sel,
    input  logic [3:0] D0, D1, D2, D3,
    output logic [3:0] Y
);
    mux4_1 m0(.sel(sel), .D0(D0[0]), .D1(D1[0]), .D2(D2[0]), .D3(D3[0]), .Y(Y[0]));
    mux4_1 m1(.sel(sel), .D0(D0[1]), .D1(D1[1]), .D2(D2[1]), .D3(D3[1]), .Y(Y[1]));
    mux4_1 m2(.sel(sel), .D0(D0[2]), .D1(D1[2]), .D2(D2[2]), .D3(D3[2]), .Y(Y[2]));
    mux4_1 m3(.sel(sel), .D0(D0[3]), .D1(D1[3]), .D2(D2[3]), .D3(D3[3]), .Y(Y[3]));
endmodule