module pwm_controller (
    input  logic clk,
    input  logic rst,            // Reset activo alto sincronizado
    input  logic [3:0] hex_in,   // Valor 0–15 para velocidad
    output logic motor_pwm       // Señal PWM de salida
);

    reg [7:0] count;
    logic [7:0] motor_speed;

    // Escala hex_in de 0..15 a 0..255 multiplicando por 17
    assign motor_speed = (hex_in << 4) + hex_in;

    // Contador síncrono con reset usando máscara lógica para evitar if
    always_ff @(posedge clk) begin
        count <= ({8{~rst}} & (count + 8'h01));
    end

    // PWM: motor_pwm alto mientras count < motor_speed
    assign motor_pwm = (count < motor_speed);

endmodule

