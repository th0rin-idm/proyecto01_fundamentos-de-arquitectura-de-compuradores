// Nombre del archivo: FpgaController_structural.sv
module FpgaController (
    // --- Entradas FÍSICAS a la FPGA ---
    input  logic        FPGA_clk,           // Reloj principal
    input  logic        FPGA_reset,         // Reset de la placa (síncrono)
    input  logic        arduino_sclk,       // SCK del Arduino
    input  logic        arduino_mosi,       // MOSI del Arduino
    input  logic        arduino_ss_n,       // SS_n del Arduino

    // --- Salidas FÍSICAS de la FPGA ---
    output logic        fpga_physical_miso, // MISO hacia Arduino
    output logic        motor_pwm_signal,   // PWM para motor (pendiente de tu lógica)
    output logic [6:0]  seven_segment_display // Display de 7 segmentos
);

    // --- Señales INTERNAS ---
    wire        data_is_valid;               // Valid pulse desde el SPI
    wire  [3:0] data_from_spi;               // Nibble recibido por SPI
    logic [6:0] decoded_pattern;             // Salida del decodificador HEX→7SEG
    logic [6:0] display_reg;                 // Registro que sujeta el patrón
    logic [6:0] next_display_reg;            // Valor siguiente para el registro

    // --- Instancia del SPI Slave (sin cambios) ---
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

    // --- Instancia del decodificador HEX→7SEG (sin cambios) ---
    hex_to_7seg hexdec (
        .hex (data_from_spi),
        .seg (decoded_pattern)
    );

    // --- Señales de control para el multiplexor estructural ---
    // rst     = 1 en ciclo de reset
    // load    = 1 en flanco válido de dato y NO reset
    // hold    = 1 cuando NO hay dato nuevo y NO reset
    wire rst_n; 
    wire load;
    wire hold;

    assign rst_n = FPGA_reset;
    assign load  = data_is_valid & ~rst_n;
    assign hold  = ~data_is_valid & ~rst_n;

    // --- Lógica combinacional que elige entre reset, load o hold ---
    //    next_display_reg[i] = 
    //       (rst_n     & 1'b1)               |  // patrón de reset = 1
    //       (load      & decoded_pattern[i]) |
    //       (hold      & display_reg[i]);
    assign next_display_reg = 
          ({7{rst_n}} & 7'b1111111)                 // reset → todos segmentos apagados
        | ({7{load}}  & decoded_pattern)            // dato válido → nuevo patrón
        | ({7{hold}}  & display_reg);               // sino → retiene valor previo

    // --- Registro de desplazamiento (flip-flop) para el display (síncrono) ---
    always_ff @(posedge FPGA_clk) begin
        display_reg <= next_display_reg;
    end

    // --- Conexión final al pin físico del display ---
    assign seven_segment_display = display_reg;

    // --- PWM del motor (queda en 0 hasta implementar) ---
    assign motor_pwm_signal = 1'b0;

endmodule
