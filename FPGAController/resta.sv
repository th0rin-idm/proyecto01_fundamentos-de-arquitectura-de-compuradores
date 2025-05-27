module resta(
    input logic [3:0] A, B,
    output logic [3:0] S
);

    logic [3:0] Bcomp;  // complemento a 1 de B
    logic [3:0] Sout;
    logic Cout0, Cout1, Cout2, Cout3;

    assign Bcomp = ~B; // complemento a 1 de B

    
    fulladder inst_adder1(
        .A(A[0]),
        .B(Bcomp[0]),
        .Cin(1'b1),
        .S(Sout[0]),
        .Cout(Cout0)
    );

    fulladder inst_adder2(
        .A(A[1]),
        .B(Bcomp[1]),
        .Cin(Cout0),
        .S(Sout[1]),
        .Cout(Cout1)
    );

    fulladder inst_adder3(
        .A(A[2]),
        .B(Bcomp[2]),
        .Cin(Cout1),
        .S(Sout[2]),
        .Cout(Cout2)
    );

    fulladder inst_adder4(
        .A(A[3]),
        .B(Bcomp[3]),
        .Cin(Cout2),
        .S(Sout[3]),
        .Cout(Cout3)
    );

    assign S = Sout; // conectar salida

endmodule
