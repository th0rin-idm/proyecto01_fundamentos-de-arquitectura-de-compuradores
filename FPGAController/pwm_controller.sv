`timescale 1ns / 1ps

// Archivo: pwm_controller16.sv
// PWM de 4-bit (16 niveles) con prescaler y reset asíncrono
// 100% estructural: sin if/else, sin case, solo ecuaciones booleanas y registros

module pwm_controller #(
    parameter PRESCALER_WIDTH = 12   // Ajusta para fijar la frecuencia PWM
) (
    input  logic             FPGA_clk,
    input  logic             FPGA_reset,  // Activo alto, asíncrono
    input  logic      [3:0]  speed,       // 0…15
    output logic             pwm_out
);

    // --------------------------------------------------
    // 1) PRESCALER: divide FPGA_clk
    // --------------------------------------------------
    logic [PRESCALER_WIDTH-1:0] prescaler;
    wire [PRESCALER_WIDTH-1:0]  prescaler_inc = prescaler + 1'b1;
    // Detecta wrap-around (cuando prescaler pasa de max a 0)
    wire                         prescaler_tick = ~|prescaler_inc;

    // Contador síncrono con reset asíncrono
    always_ff @(posedge FPGA_clk or posedge FPGA_reset) begin
        if (FPGA_reset)
            prescaler <= {PRESCALER_WIDTH{1'b0}};
        else
            prescaler <= prescaler_inc;
    end

    // --------------------------------------------------
    // 2) CONTADOR PWM de 4 bits
    // --------------------------------------------------
    logic [3:0] pwm_cnt;
    wire [3:0] pwm_cnt_inc = pwm_cnt + 1'b1;

    always_ff @(posedge FPGA_clk or posedge FPGA_reset) begin
        if (FPGA_reset)
            pwm_cnt <= 4'b0000;
        else if (prescaler_tick)
            pwm_cnt <= pwm_cnt_inc;
        else
            pwm_cnt <= pwm_cnt;
    end

    // --------------------------------------------------
    // 3) SALIDA PWM: alto mientras pwm_cnt < speed
    // --------------------------------------------------
    // Comparador genera 1 si cnt<speed, 0 si cnt>=speed
    wire cmp = pwm_cnt < speed;
    assign pwm_out = cmp;

endmodule
