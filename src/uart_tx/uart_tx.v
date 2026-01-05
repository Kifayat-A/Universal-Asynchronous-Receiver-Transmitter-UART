module uart_tx(
    input clk,rst_n,
    input [1:0] parity_type,
    input send,
    input [1:0] baud_rate,
    input [7:0] data_in,

    output reg bd_clk_out,
    output reg active,
    output reg tx
);

wire bd_clk_temp;
wire parity_temp;

baud_gen bd_gen(
    .clk(clk),
    .rst_n(rst_n),
    .baud_rate(baud_rate),
    .bd_clk(bd_clk_temp)
);
assign bd_clk_out = bd_clk_temp;

parity_in parity_uut(
    .rst_n(rst_n),
    .parity_type(parity_type),
    .data_in(data_in),
    .parity(parity_temp)
);


piso piso_uut(
    .bd_clk(bd_clk_temp),
    .rst_n(rst_n),
    .tx_start(send),
    .data_in(data_in),
    .parity(parity_temp),
    .tx(tx),
    .active(active)
);

endmodule