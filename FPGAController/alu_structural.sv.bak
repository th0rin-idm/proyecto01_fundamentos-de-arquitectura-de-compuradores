module alu_structural (
    input  logic [3:0] A,
    input  logic [3:0] B,
    input  logic [1:0] Op,
    output logic [3:0] R,
    output logic Z, N, C, V
);

    // Resultados intermedios
    logic [3:0] R_and, R_xor, R_sub, R_mul;
    logic Z_and, N_and, C_and, V_and;
    logic Z_xor, N_xor, C_xor, V_xor;
    logic Z_sub, N_sub, C_sub, V_sub;
    logic Z_mul, N_mul, C_mul, V_mul;

    // Instancias de los módulos de operaciones
    and4bits u_and(.A(A), .B(B), .R(R_and), .Z(Z_and), .N(N_and), .C(C_and), .V(V_and));
    xor4bits u_xor(.A(A), .B(B), .R(R_xor), .Z(Z_xor), .N(N_xor), .C(C_xor), .V(V_xor));
    resta u_sub(.A(A), .B(B), .S(R_sub), .Z(Z_sub), .N(N_sub), .C(C_sub), .V(V_sub));
    multi u_mul(.a(A), .b(B), .Pcirc(R_mul), .Z(Z_mul), .N(N_mul), .C(C_mul), .V(V_mul));

    // Multiplexores estructurales de 4 a 1 para R y banderas
    mux4_1_4bits muxR(.sel(Op), .D0(R_and), .D1(R_xor), .D2(R_sub), .D3(R_mul), .Y(R));
    mux4_1 muxZ(.sel(Op), .D0(Z_and), .D1(Z_xor), .D2(Z_sub), .D3(Z_mul), .Y(Z));
    mux4_1 muxN(.sel(Op), .D0(N_and), .D1(N_xor), .D2(N_sub), .D3(N_mul), .Y(N));
    mux4_1 muxC(.sel(Op), .D0(C_and), .D1(C_xor), .D2(C_sub), .D3(C_mul), .Y(C));
    mux4_1 muxV(.sel(Op), .D0(V_and), .D1(V_xor), .D2(V_sub), .D3(V_mul), .Y(V));

endmodule
