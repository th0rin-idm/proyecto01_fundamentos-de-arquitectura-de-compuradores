module FpgaController (
    input  logic FPGA_clk,
    input  logic FPGA_reset,
    input  logic arduino_sclk,
    input  logic arduino_mosi,
    input  logic arduino_ss_n,

    input  logic btn0,
    input  logic btn1,
    input  logic btn2,
    input  logic btn3,

    input  logic Mult,
    input  logic Sub,
    input  logic And,
    input  logic Xor,

    output logic fpga_physical_miso,
    output logic [3:0] led_outputs,         // {Z, C, V, N}
    output logic [6:0] seven_segment_pins,
    output logic [6:0] seven_segment_pins2,
    output logic motor_pwm
);

    // --- Datos SPI y display ---
    logic [3:0] data_from_spi_to_fpga;
    logic       data_is_valid_from_spi;
    logic [6:0] segments_from_bcd_units;
    logic [6:0] segments_from_bcd_units_2;

    // --- Operando B ---
    logic [1:0] dec_result;
    logic [3:0] dec_4bits;

    // --- Selección ALU ---
    logic [1:0] alu_sel;

    // --- Resultado ALU y flags ---
    logic [3:0] alu_result;
    logic       flag_Z, flag_N, flag_C, flag_V;

    // --- Registro del resultado ---
    logic [3:0] reg_out;

    // --- Señales de botón limpias ---
    logic btn0_clean, btn1_clean, btn2_clean, btn3_clean;
    logic Mult_clean, Sub_clean, And_clean, Xor_clean;

    // Debounce para botones operandos
    ButtonDebounce #(.N(16)) db_btn0 (
        .clk(FPGA_clk), .rst(FPGA_reset), .btn_in(btn0), .btn_out(btn0_clean)
    );
    ButtonDebounce #(.N(16)) db_btn1 (
        .clk(FPGA_clk), .rst(FPGA_reset), .btn_in(btn1), .btn_out(btn1_clean)
    );
    ButtonDebounce #(.N(16)) db_btn2 (
        .clk(FPGA_clk), .rst(FPGA_reset), .btn_in(btn2), .btn_out(btn2_clean)
    );
    ButtonDebounce #(.N(16)) db_btn3 (
        .clk(FPGA_clk), .rst(FPGA_reset), .btn_in(btn3), .btn_out(btn3_clean)
    );

    // Debounce para botones de operación ALU
    ButtonDebounce #(.N(16)) db_Mult (
        .clk(FPGA_clk), .rst(FPGA_reset), .btn_in(Mult), .btn_out(Mult_clean)
    );
    ButtonDebounce #(.N(16)) db_Sub (
        .clk(FPGA_clk), .rst(FPGA_reset), .btn_in(Sub), .btn_out(Sub_clean)
    );
    ButtonDebounce #(.N(16)) db_And (
        .clk(FPGA_clk), .rst(FPGA_reset), .btn_in(And), .btn_out(And_clean)
    );
    ButtonDebounce #(.N(16)) db_Xor (
        .clk(FPGA_clk), .rst(FPGA_reset), .btn_in(Xor), .btn_out(Xor_clean)
    );

    // Decodificador de operandos (botones 0–3)
    deco_4_2bits decoder_inst (
        .A(~btn0_clean),
        .B(~btn1_clean),
        .C(~btn2_clean),
        .D(~btn3_clean),
        .Y1(dec_result[1]),
        .Y0(dec_result[0])
    );
    assign dec_4bits = {2'b00, dec_result};

    // Decodificador de operación ALU
    deco_4_2bits alu_controller (
        .A(Mult_clean),
        .B(Sub_clean),
        .C(And_clean),
        .D(Xor_clean),
        .Y1(alu_sel[1]),
        .Y0(alu_sel[0])
    );

    // Instancia ALU estructural con banderas
    alu_structural alu_inst (
        .A(data_from_spi_to_fpga),
        .B(dec_4bits),
        .Op(alu_sel),
        .R(alu_result),
        .Z(flag_Z),
        .N(flag_N),
        .C(flag_C),
        .V(flag_V)
    );

    // Registro de 4 bits para resultado ALU
    Register4Bits reg_inst (
        .clk(FPGA_clk),
        .rst(FPGA_reset),
        .d(alu_result),
        .q(reg_out)
    );

    // Mostrar banderas en LEDs: {Z, C, V, N}
    assign led_outputs = { flag_Z, flag_C, flag_V, flag_N };

    // PWM usando resultado de ALU
    pwm_controller pwm_inst (
        .clk(FPGA_clk),
        .rst(FPGA_reset),
        .hex_in(reg_out),
        .motor_pwm(motor_pwm)
    );

    // Módulo SPI Slave
    Spi_slave_module spi_inst (
        .clk(FPGA_clk),
        .reset(FPGA_reset),
        .sclk_in(arduino_sclk),
        .mosi_in(arduino_mosi),
        .ss_n_in(arduino_ss_n),
        .spi_data_out(data_from_spi_to_fpga),
        .spi_data_valid_out(data_is_valid_from_spi),
        .miso_out(fpga_physical_miso)
    );

    // Decodificadores 7 segmentos para dato SPI y resultado ALU
    hex_to_7seg hex7seg_inst (
        .hex(data_from_spi_to_fpga),
        .seg(segments_from_bcd_units)
    );
    hex_to_7seg hex7seg_reg_inst (
        .hex(reg_out),
        .seg(segments_from_bcd_units_2)
    );

    // Salidas a displays (anodo común: activo bajo)
    assign seven_segment_pins  = ~segments_from_bcd_units;
    assign seven_segment_pins2 = ~segments_from_bcd_units_2;

endmodule
