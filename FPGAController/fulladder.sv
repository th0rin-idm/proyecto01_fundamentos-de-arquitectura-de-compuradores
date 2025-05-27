module fulladder(
input logic A,B, Cin,
output logic Cout, S
);


//assign = A ^ B ^ Cin;
assign S = A ^ B ^ Cin;

//assign A & B | A & Cin | B & Cin;
assign Cout = (A & B) | (A & Cin) | (B & Cin);

endmodule 


