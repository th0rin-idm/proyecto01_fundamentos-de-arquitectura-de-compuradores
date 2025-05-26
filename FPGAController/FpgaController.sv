// Nombre del archivo: FpgaController.sv
module FpgaController (
    // --- Entradas FÍSICAS a la FPGA ---
    input  logic        FPGA_clk,           // Reloj principal
    input  logic        FPGA_reset,         // Reset de la placa
    input  logic        arduino_sclk,       // SCK del Arduino
    input  logic        arduino_mosi,       // MOSI del Arduino
    input  logic        arduino_ss_n,       // SS_n del Arduino

    // --- Salidas FÍSICAS de la FPGA ---
    output logic        fpga_physical_miso, // MISO hacia Arduino
    output logic        motor_pwm_signal,   // PWM para motor (aquí debes conectar tu lógica de PWM)
    output logic [6:0]  seven_segment_display // Display de 7 segmentos
);

    // --- Señales INTERNAS ---
    wire  [3:0] data_from_spi_module;
    wire        data_is_valid_from_spi_module;
    logic [6:0] decoded_pattern;
    logic [6:0] display_reg;

    // --- SPI Slave ---
    Spi_slave_module spi_unit (
        .clk                  (FPGA_clk),
        .reset                (FPGA_reset),
        .sclk_in              (arduino_sclk),
        .mosi_in              (arduino_mosi),
        .ss_n_in              (arduino_ss_n),
        .spi_data_out         (data_from_spi_module),
        .spi_data_valid_out   (data_is_valid_from_spi_module),
        .miso_out             (fpga_physical_miso)
    );

    // --- Decodificador HEX→7SEG ---
    hex_to_7seg hexdec (
        .hex (data_from_spi_module),
        .seg (decoded_pattern)
    );

    // --- Registro de salida para el display ---
    always_ff @(posedge FPGA_clk or posedge FPGA_reset) begin
        if (FPGA_reset)
            display_reg <= 7'b1111111;      // todos apagados
        else if (data_is_valid_from_spi_module)
            display_reg <= decoded_pattern; // capture en pulso válido
    end

    // --- Conexiones Físicas de Salida ---
    assign seven_segment_display = display_reg;

    // --- PWM del motor ---
    // Aquí deberías instanciar tu módulo de PWM o asignar una señal:
    // Por ejemplo, si no lo usas todavía, lo dejas apagado:
    assign motor_pwm_signal = 1'b0;

endmodule
