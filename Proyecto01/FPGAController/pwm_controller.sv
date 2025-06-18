module pwm_controller #(
    parameter PRESCALER_WIDTH = 12   // ajusta para fijar la frecuencia PWM
) (
    input  logic             FPGA_clk,
    input  logic             FPGA_reset,  // activo alto, síncrono
    input  logic      [3:0]  speed,       // 0…15
    output logic             pwm_out
);

    // --------------------------------------------------
    // 1) PRESCALER: divide FPGA_clk
    // --------------------------------------------------
    logic [PRESCALER_WIDTH-1:0] prescaler, next_prescaler;
    // conteo +1
    wire [PRESCALER_WIDTH-1:0] prescaler_inc = prescaler + 1'b1;
    // reset→0, else→prescaler_inc
    assign next_prescaler =
          ({PRESCALER_WIDTH{ FPGA_reset }} & {PRESCALER_WIDTH{1'b0}})
        | ({PRESCALER_WIDTH{~FPGA_reset }} & prescaler_inc);
    always_ff @(posedge FPGA_clk) prescaler <= next_prescaler;

    // Disparo PWM cada vez que prescaler llega a máximo (todas las 1)
    // prescaler_inc==0 sólo cuando prescaler estaba en all-1
    wire pwm_tick = ~|prescaler_inc;  

    // --------------------------------------------------
    // 2) CONTADOR PWM de 4 bits
    // --------------------------------------------------
    logic [3:0] pwm_cnt, next_pwm_cnt;
    wire [3:0] pwm_cnt_inc = pwm_cnt + 1'b1;
    // reset→0, else if tick→cnt+1, else retain
    assign next_pwm_cnt =
          ({4{ FPGA_reset        }} & 4'b0000)
        | ({4{~FPGA_reset & pwm_tick}} & pwm_cnt_inc)
        | ({4{~FPGA_reset &~pwm_tick}} & pwm_cnt);
    always_ff @(posedge FPGA_clk) pwm_cnt <= next_pwm_cnt;

    // --------------------------------------------------
    // 3) SALIDA PWM: alto mientras pwm_cnt < speed
    // --------------------------------------------------
    // comparador (<) genera 1 si cnt<speed, 0 si cnt>=speed
    wire cmp = pwm_cnt < speed;
    assign pwm_out = cmp;

endmodule
