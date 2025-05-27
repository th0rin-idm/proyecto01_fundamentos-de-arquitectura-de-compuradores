module and4bits (
    input  logic [3:0] A,
    input  logic [3:0] B,
    output logic [3:0] R
);

    // Instancias de compuertas AND para cada bit
    and and0 (R[0], A[0], B[0]);
    and and1 (R[1], A[1], B[1]);
    and and2 (R[2], A[2], B[2]);
    and and3 (R[3], A[3], B[3]);

endmodule
