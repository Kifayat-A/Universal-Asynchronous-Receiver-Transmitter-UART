module uart_tx(
    input clk,rst_n,
    input [1:0] parity_type,
    input send,
    input [1:0] baud_rate,
    input [7:0] data_in,
    input wr_en,

    output reg bd_clk_out,
    output reg active,
    output reg tx,
    output fifo_full
);


wire [7:0] fifo2piso;
wire bd_clk_temp;
wire parity_temp;
wire fifo_empty;
reg rd_en_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        rd_en_reg <= 1'b0;
    end else begin
        if (!fifo_empty && send) begin
            rd_en_reg <= 1'b1; // Trigger a read from FIFO
        end else begin
            rd_en_reg <= 1'b0; // De-assert after 1 cycle
        end
    end
end

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
    .data_in(fifo2piso),
    .parity(parity_temp)
);

fifo_sync #(.WIDTH(8),.ADDR(4),.DEPTH(16))  tx_fifo(

    .clk(clk),
    .rst_n(rst_n),
    .data_in(data_in),
    .wr_en(wr_en),
    .rd_en(send),
    .data_out(fifo2piso),
    .full(fifo_full),
    .empty(fifo_empty)

);


piso piso_uut(
    .bd_clk(bd_clk_temp),
    .rst_n(rst_n),
    .tx_start(send),
    .data_in(fifo2piso),
    .parity(parity_temp),
    .tx(tx),
    .active(active)
);

endmodule