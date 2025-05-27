module multi (
    input  logic [3:0] a, b,
    output logic [3:0] Pcirc,
    output logic Z, N, C, V
);

    // Productos parciales
    logic pp00, pp01, pp02, pp03;
    logic pp10, pp11, pp12, pp13;
    logic pp20, pp21, pp22, pp23;
    logic pp30, pp31, pp32, pp33;

    logic S2_1, S2_2, S3_1, S4_1, S4_2, S5_1, S5_2, S6_1;
    logic C1_1, C1_2, C2_1, C2_2, C3_1, C3_2, C4_1, C4_2, C5_1, C5_2, C6_1, C6_2, C7_1;
    logic [7:0] P;

    // ANDs
    and and00(pp00, a[0], b[0]);
    and and01(pp01, a[1], b[0]);
    and and02(pp02, a[2], b[0]);
    and and03(pp03, a[3], b[0]);

    and and10(pp10, a[0], b[1]);
    and and11(pp11, a[1], b[1]);
    and and12(pp12, a[2], b[1]);
    and and13(pp13, a[3], b[1]);

    and and20(pp20, a[0], b[2]);
    and and21(pp21, a[1], b[2]);
    and and22(pp22, a[2], b[2]);
    and and23(pp23, a[3], b[2]);

    and and30(pp30, a[0], b[3]);
    and and31(pp31, a[1], b[3]);
    and and32(pp32, a[2], b[3]);
    and and33(pp33, a[3], b[3]);

    // FA para sumas parciales
    assign P[0] = pp00;
    fulladder fa1(.A(pp01), .B(pp10), .Cin(1'b0), .S(P[1]), .Cout(C1_1));
    fulladder fa2a(.A(pp02), .B(pp11), .Cin(1'b0), .S(S2_1), .Cout(C2_1));
    fulladder fa2b(.A(S2_1), .B(pp20), .Cin(C1_1), .S(P[2]), .Cout(C3_1));
    fulladder fa3a(.A(pp03), .B(pp12), .Cin(1'b0), .S(S3_1), .Cout(C4_1));
    fulladder fa3b(.A(S3_1), .B(pp21), .Cin(C2_1), .S(S4_1), .Cout(C5_1));
    fulladder fa3c(.A(S4_1), .B(pp30), .Cin(C3_1), .S(P[3]), .Cout(C6_1));
    fulladder fa4a(.A(pp13), .B(pp22), .Cin(1'b0), .S(S5_1), .Cout(C1_2));
    fulladder fa4b(.A(S5_1), .B(pp31), .Cin(C4_1), .S(S5_2), .Cout(C2_2));
    fulladder fa4c(.A(S5_2), .B(C5_1), .Cin(C6_1), .S(P[4]), .Cout(C3_2));
    fulladder fa5a(.A(pp23), .B(pp32), .Cin(1'b0), .S(S2_2), .Cout(C4_2));
    fulladder fa5b(.A(S2_2), .B(C1_2), .Cin(C3_2), .S(S6_1), .Cout(C5_2));
    fulladder fa5c(.A(S6_1), .B(C2_2), .Cin(C4_2), .S(P[5]), .Cout(C6_2));
    fulladder fa6a(.A(pp33), .B(C5_2), .Cin(C6_2), .S(P[6]), .Cout(C7_1));

    assign P[7] = C7_1;
    assign Pcirc = P[3:0];

    // Flags
    assign N = Pcirc[3];

    logic or1, or2, or3;
    or o1(or1, Pcirc[0], Pcirc[1]);
    or o2(or2, Pcirc[2], Pcirc[3]);
    or o3(or3, or1, or2);
    not nz(Z, or3);

    assign C = 1'b0;
    assign V = 1'b0;

endmodule
