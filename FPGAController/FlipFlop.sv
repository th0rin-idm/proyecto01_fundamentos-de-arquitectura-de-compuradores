module FlipFlop (
    input  logic reset,
    input  logic button_stable,      // Entrada debounced usada como "clk manual"
    input  logic [1:0] num,          // Entrada de número
    output logic [1:0] accumulated_value,
    output logic signal_out
);

    logic [1:0] acc; 
    logic [1:0] sum;


    DecoderToBcd sumador (
        .A1(num[1]), .A0(num[0]),   // Entrada num
        .B1(acc[1]), .B0(acc[0]),   // Entrada acc (valor actual del acumulador)
        .S(sum)                     // Salida sum = num + acc
    );


    always_ff @(negedge button_stable or posedge reset) begin

        acc <= ( {2{reset}} & 2'b00 ) | ( {2{~reset}} & sum );
    end


    assign accumulated_value = acc;

    wire acc_es_uno = (~acc[1] & acc[0]);

    wire acc_es_dos = (acc[1] & ~acc[0]);

    assign signal_out = acc_es_uno | acc_es_dos;

endmodule