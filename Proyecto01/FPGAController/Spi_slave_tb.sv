`timescale 1ns / 1ps

module Spi_slave_tb;

    // Parámetros del Testbench
    localparam CLK_PERIOD_FPGA        = 20;     // 50 MHz → 20 ns
    localparam SCLK_PERIOD_SPI        = 1000;   // 1 MHz → 1000 ns
    localparam ACK_EXPECTED_FROM_FPGA = 8'hA5;  // ACK esperado

    // Entradas al DUT
    logic        clk_fpga_tb;
    logic        reset_tb;
    logic        sclk_spi_tb;
    logic        mosi_tb;
    logic        ss_n_tb;

    // Salidas del DUT
    logic [3:0]  spi_data_out_dut;
    logic        spi_data_valid_out_dut;
    logic        miso_dut;

    // Señales del maestro simulado
    logic [7:0]  byte_to_send_tb;
    logic [3:0]  speed_value_to_send_tb;
    logic [7:0]  byte_received_from_fpga_tb;
    string       test_case_name;

    // Instancia del DUT
    Spi_slave_module dut (
        .clk                  (clk_fpga_tb),
        .reset                (reset_tb),
        .sclk_in              (sclk_spi_tb),
        .mosi_in              (mosi_tb),
        .ss_n_in              (ss_n_tb),
        .spi_data_out         (spi_data_out_dut),
        .spi_data_valid_out   (spi_data_valid_out_dut),
        .miso_out             (miso_dut)
    );

    // Generador de reloj de la FPGA
    always begin
        clk_fpga_tb = 1'b0;
        #(CLK_PERIOD_FPGA/2);
        clk_fpga_tb = 1'b1;
        #(CLK_PERIOD_FPGA/2);
    end

    // Tarea de transferencia SPI sin "for"
    task spi_transfer_byte(
        input  [7:0] data_to_send_master,
        output [7:0] data_received_master
    );
        logic [7:0] shift_out;
        shift_out            = data_to_send_master;
        data_received_master = 8'b0;
        // repeat en lugar de for
        repeat (8) begin
            mosi_tb   = shift_out[7];
            shift_out = { shift_out[6:0], 1'b0 };
            sclk_spi_tb = 1'b0;
            #(SCLK_PERIOD_SPI/2);
            sclk_spi_tb = 1'b1;
            #1;
            data_received_master = { data_received_master[6:0], miso_dut };
            #(SCLK_PERIOD_SPI/2 - 1);
        end
        sclk_spi_tb = 1'b0;
        mosi_tb     = 1'bz;
    endtask

    // Tarea de verificación usando solo ecuaciones booleanas en las aserciones
    task check_spi_transaction(
        input [3:0] expected_data,
        input [7:0] expected_ack,
        input [7:0] actual_ack
    );
        // Aserción ACK: ~( |(actual_ack ^ expected_ack) ) debe ser 1
        assert ( ~( |(actual_ack ^ expected_ack)) );
        // Dar tiempo para que el DUT procese el dato y genere el pulso
        #(CLK_PERIOD_FPGA * 5);
        // Aserción Data: ~( |(spi_data_out_dut ^ expected_data) ) debe ser 1
        assert ( ~( |(spi_data_out_dut ^ expected_data)) );
    endtask

    // Secuencia principal de pruebas
    initial begin
        // Inicialización
        clk_fpga_tb = 1'b0;
        reset_tb    = 1'b1;
        sclk_spi_tb = 1'b0;
        mosi_tb     = 1'bz;
        ss_n_tb     = 1'b1;
        #(CLK_PERIOD_FPGA * 5);
        reset_tb = 1'b0;
        #(CLK_PERIOD_FPGA * 5);

        // Test Case 1: velocidad = 5
        test_case_name         = "Enviar Velocidad 5";
        speed_value_to_send_tb = 4'b0101;
        byte_to_send_tb        = speed_value_to_send_tb << 4;
        ss_n_tb                = 1'b0;
        #(CLK_PERIOD_FPGA);
        spi_transfer_byte(byte_to_send_tb, byte_received_from_fpga_tb);
        ss_n_tb = 1'b1;
        #(CLK_PERIOD_FPGA * 2);
        check_spi_transaction(speed_value_to_send_tb,
                              ACK_EXPECTED_FROM_FPGA,
                              byte_received_from_fpga_tb);
        #(SCLK_PERIOD_SPI * 2);

        // Test Case 2: velocidad = 10 (0xA)
        test_case_name         = "Enviar Velocidad 10";
        speed_value_to_send_tb = 4'b1010;
        byte_to_send_tb        = speed_value_to_send_tb << 4;
        ss_n_tb                = 1'b0;
        #(CLK_PERIOD_FPGA);
        spi_transfer_byte(byte_to_send_tb, byte_received_from_fpga_tb);
        ss_n_tb = 1'b1;
        #(CLK_PERIOD_FPGA * 2);
        check_spi_transaction(speed_value_to_send_tb,
                              ACK_EXPECTED_FROM_FPGA,
                              byte_received_from_fpga_tb);
        #(SCLK_PERIOD_SPI * 2);

        // Test Case 3: velocidad = 0
        test_case_name         = "Enviar Velocidad 0";
        speed_value_to_send_tb = 4'b0000;
        byte_to_send_tb        = speed_value_to_send_tb << 4;
        ss_n_tb                = 1'b0;
        #(CLK_PERIOD_FPGA);
        spi_transfer_byte(byte_to_send_tb, byte_received_from_fpga_tb);
        ss_n_tb = 1'b1;
        #(CLK_PERIOD_FPGA * 2);
        check_spi_transaction(speed_value_to_send_tb,
                              ACK_EXPECTED_FROM_FPGA,
                              byte_received_from_fpga_tb);
        #(SCLK_PERIOD_SPI * 2);

        $finish;
    end

endmodule
