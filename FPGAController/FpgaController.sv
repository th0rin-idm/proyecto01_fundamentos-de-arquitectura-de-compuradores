`timescale 1ns / 1ps

module FpgaController (
    // Entradas de reloj y reset
    input  logic        FPGA_clk,
    input  logic        FPGA_reset,

    // SPI (se deja aunque no se use para la ALU ahora)
    input  logic        arduino_sclk,
    input  logic        arduino_mosi,
    input  logic        arduino_ss_n,

    // Switches (one-hot) para elegir operación
    input  logic        sw_and,    // cuando vale 1 → AND
    input  logic        sw_xor,    // cuando vale 1 → XOR
    input  logic        sw_sub,    // cuando vale 1 → SUB
    input  logic        sw_mul,    // cuando vale 1 → MUL

    // Botones para los operandos de 1 bit
    // btn0→A[0], btn1→A[1], btn2→B[0], btn3→B[1]
    input  logic        btn0,
    input  logic        btn1,
    input  logic        btn2,
    input  logic        btn3,

    // Salidas
    output logic        fpga_physical_miso,
    output logic [6:0]  seven_segment_display
);

    // -------------------------------------------------------------
    // 1) Instancia del SPI Slave (mantenido pero no usado luego)
    // -------------------------------------------------------------
    wire        data_is_valid;
    wire [3:0]  data_from_spi;
    Spi_slave_module spi_unit (
        .clk                (FPGA_clk),
        .reset              (FPGA_reset),
        .sclk_in            (arduino_sclk),
        .mosi_in            (arduino_mosi),
        .ss_n_in            (arduino_ss_n),
        .spi_data_out       (data_from_spi),
        .spi_data_valid_out (data_is_valid),
        .miso_out           (fpga_physical_miso)
    );

    // -------------------------------------------------------------
    // 2) Formar operandos A_ext y B_ext de 4 bits a partir de botones
    //    Cada botón vale 0 o 1:
    //      A_ext = {2’b00, btn1, btn0}
    //      B_ext = {2’b00, btn3, btn2}
    // -------------------------------------------------------------
    wire [3:0] A_ext = {2'b00, btn1, btn0};
    wire [3:0] B_ext = {2'b00, btn3, btn2};

    // -------------------------------------------------------------
    // 3) Decodificar los switches en un código Op[1:0]:
    //       Op = {Op1, Op0}
    //       Op0 = sw_xor OR sw_mul
    //       Op1 = sw_sub OR sw_mul
    //    Mapea one-hot de 4 switches a un bus de 2 bits
    //       00 → AND
    //       01 → XOR
    //       10 → SUB
    //       11 → MUL
    // -------------------------------------------------------------
    wire Op0 = sw_xor | sw_mul;
    wire Op1 = sw_sub | sw_mul;
    wire [1:0] Op = {Op1, Op0};

    // -------------------------------------------------------------
    // 4) Llamar a la ALU estructural
    // -------------------------------------------------------------
    wire [3:0] alu_result;
    alu_structural u_alu (
        .A   (A_ext),
        .B   (B_ext),
        .Op  (Op),
        .R   (alu_result)
    );

    // -------------------------------------------------------------
    // 5) Lógica de display
    //
    //    - Mientras no haya ningún switch activo (op_valid=0), mostramos “0”
    //    - Cuando al menos un switch está en 1 (op_valid=1), mostramos alu_result
    //    - El valor se codifica a 7-segmentos y luego se registra síncronamente
    // -------------------------------------------------------------
    wire        op_valid      = sw_and | sw_xor | sw_sub | sw_mul;
    wire [6:0]  zero_pattern  = 7'b1000000; // forma “0” en display
    wire [6:0]  decoded_result;

    // Decoder hex→7seg estructural
    hex_to_7seg hexdec (
        .hex (alu_result),
        .seg (decoded_result)
    );

    // MUX combinacional puro (sin if, sin case, sin ?:)
    wire [6:0] display_comb = 
          ({7{op_valid   }} & decoded_result)
        | ({7{~op_valid  }} & zero_pattern);

    // Registro síncrono con reset asíncrono para fijar el patrón
    logic [6:0] display_reg;
    always_ff @(posedge FPGA_clk or posedge FPGA_reset) begin
        if (FPGA_reset)
            display_reg <= zero_pattern;   // al reset, “0”
        else
            display_reg <= display_comb;   // al reloj, carga el valor combinado
    end

    assign seven_segment_display = display_reg;

endmodule
