module resta (
    input  logic [3:0] A, B,
    output logic [3:0] S,
    output logic Z, N, C, V
);

    logic [3:0] Bcomp;
    logic [3:0] Sout;
    logic Cout0, Cout1, Cout2, Cout3;

    // Complemento a 1 de B
    assign Bcomp = ~B;

    // Full adders para hacer A + (~B + 1)
    fulladder fa0(
        .A(A[0]), .B(Bcomp[0]), .Cin(1'b1),
        .S(Sout[0]), .Cout(Cout0)
    );

    fulladder fa1(
        .A(A[1]), .B(Bcomp[1]), .Cin(Cout0),
        .S(Sout[1]), .Cout(Cout1)
    );

    fulladder fa2(
        .A(A[2]), .B(Bcomp[2]), .Cin(Cout1),
        .S(Sout[2]), .Cout(Cout2)
    );

    fulladder fa3(
        .A(A[3]), .B(Bcomp[3]), .Cin(Cout2),
        .S(Sout[3]), .Cout(Cout3)
    );

    assign S = Sout;

    // Banderas
    assign C = ~Cout3;  // Carry = cout del último bit
    assign N = S[3];   // Negative = bit más significativo

    // Zero = ~(S[0] | S[1] | S[2] | S[3])
    logic or1, or2, or3;
    or o1(or1, S[0], S[1]);
    or o2(or2, S[2], S[3]);
    or o3(or3, or1, or2);
    not zf(Z, or3);

    // Overflow = Cout3 ^ Cout2
    xor ovf(V, Cout2, Cout3);

endmodule
