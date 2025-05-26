// Nombre del archivo: hex_to_7seg_structural.sv
// Decodificador de 4-bit hex a 7-segmentos totalmente estructural,
// sin case, if o operador ternario.

module hex_to_7seg_structural (
    input  logic [3:0] hex,  // valor 0–15
    output logic [6:0] seg   // {g,f,e,d,c,b,a}, activo bajo
);

    // --- Patrones constantes para cada hex ---
    localparam logic [6:0] PAT0 = 7'b1000000;
    localparam logic [6:0] PAT1 = 7'b1111001;
    localparam logic [6:0] PAT2 = 7'b0100100;
    localparam logic [6:0] PAT3 = 7'b0110000;
    localparam logic [6:0] PAT4 = 7'b0011001;
    localparam logic [6:0] PAT5 = 7'b0010010;
    localparam logic [6:0] PAT6 = 7'b0000010;
    localparam logic [6:0] PAT7 = 7'b1111000;
    localparam logic [6:0] PAT8 = 7'b0000000;
    localparam logic [6:0] PAT9 = 7'b0010000;
    localparam logic [6:0] PATA = 7'b0001000;
    localparam logic [6:0] PATB = 7'b0000011;
    localparam logic [6:0] PATC = 7'b1000110;
    localparam logic [6:0] PATD = 7'b0100001;
    localparam logic [6:0] PATE = 7'b0000110;
    localparam logic [6:0] PATF = 7'b0001110;

    // --- Decodificador one-hot ---  
    // Genera un vector de 16 bits con un único '1' en la posición 'hex'
    wire logic [15:0] one_hot;
    assign one_hot = 16'b1 << hex;

    // --- Multiplexor estructural usando AND/OR/NOT ---
    assign seg =
          ({7{one_hot[ 0]}} & PAT0) 
        | ({7{one_hot[ 1]}} & PAT1)
        | ({7{one_hot[ 2]}} & PAT2)
        | ({7{one_hot[ 3]}} & PAT3)
        | ({7{one_hot[ 4]}} & PAT4)
        | ({7{one_hot[ 5]}} & PAT5)
        | ({7{one_hot[ 6]}} & PAT6)
        | ({7{one_hot[ 7]}} & PAT7)
        | ({7{one_hot[ 8]}} & PAT8)
        | ({7{one_hot[ 9]}} & PAT9)
        | ({7{one_hot[10]}} & PATA)
        | ({7{one_hot[11]}} & PATB)
        | ({7{one_hot[12]}} & PATC)
        | ({7{one_hot[13]}} & PATD)
        | ({7{one_hot[14]}} & PATE)
        | ({7{one_hot[15]}} & PATF);

endmodule
