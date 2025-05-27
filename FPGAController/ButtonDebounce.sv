module ButtonDebounce #(
    parameter N = 16  // ancho contador para debounce
)(
    input  logic clk,
    input  logic rst,         // reset sincronizado activo alto
    input  logic btn_in,      // entrada del botón
    output logic btn_out      // salida del botón filtrado
);

    // Señales internas
    logic sync_0, sync_1;
    logic [N-1:0] cnt;
    logic filtered;

    // Doble sincronizador para entrada asíncrona
    always_ff @(posedge clk) begin
        sync_0 <= btn_in;
        sync_1 <= sync_0;
    end

    // Contador para debounce y filtro (sin if/else)
    logic cnt_enable;
    logic [N-1:0] cnt_next;
    logic filtered_next;

    assign cnt_enable = (sync_1 != filtered);

    assign cnt_next = cnt_enable ? (cnt + 1) : {N{1'b0}};
    assign filtered_next = (cnt == {N{1'b1}}) ? sync_1 : filtered;

    always_ff @(posedge clk) begin
        cnt <= cnt_next;
        filtered <= filtered_next;
    end

    assign btn_out = filtered;

endmodule
