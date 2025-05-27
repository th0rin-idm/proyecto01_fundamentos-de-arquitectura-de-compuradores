module xor4bits (
    input  logic [3:0] A,
    input  logic [3:0] B,
    output logic [3:0] R,
    output logic Z, N, C, V
);

    // XOR por bit
    xor g0(R[0], A[0], B[0]);
    xor g1(R[1], A[1], B[1]);
    xor g2(R[2], A[2], B[2]);
    xor g3(R[3], A[3], B[3]);

    // Zero flag
    logic or1, or2, or3;
    or o1(or1, R[0], R[1]);
    or o2(or2, R[2], R[3]);
    or o3(or3, or1, or2);
    not n1(Z, or3);

    // Negative flag
    assign N = R[3];

    // No carry ni overflow
    assign C = 1'b0;
    assign V = 1'b0;

endmodule
