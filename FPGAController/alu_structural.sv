module alu_structural (
    input  logic [3:0] A,
    input  logic [3:0] B,
    input  logic [1:0] Op,  // selector de operación
    output logic [3:0] R    // resultado circular
);

    // Salidas intermedias
    logic [3:0] R_and, R_xor, R_sub, R_mul;

    // Instancias de cada módulo funcional
    and4bits u_and (
        .A(A),
        .B(B),
        .R(R_and)
    );

    xor4bits u_xor (
        .A(A),
        .B(B),
        .R(R_xor)
    );

    resta u_sub (
        .A(A),
        .B(B),
        .S(R_sub)
    );

    multi u_mul (
        .a(A),
        .b(B),
        .Pcirc(R_mul)
    );

    // MUX estructural 4 a 1 de 4 bits
    logic [3:0] s0, s1;

    // Primera capa de selección
    mux2_1_4bits mux0 (
        .sel(Op[0]),
        .A(R_and),
        .B(R_xor),
        .Y(s0)
    );

    mux2_1_4bits mux1 (
        .sel(Op[0]),
        .A(R_sub),
        .B(R_mul),
        .Y(s1)
    );

    // Segunda capa de selección
    mux2_1_4bits mux_final (
        .sel(Op[1]),
        .A(s0),
        .B(s1),
        .Y(R)
    );

endmodule
