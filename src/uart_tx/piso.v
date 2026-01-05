module piso (
    input        bd_clk,
    input        rst_n,
    input        tx_start,
    input  [7:0] data_in,
    input        parity,
    output reg   tx,
    output reg   active
);

    localparam IDLE   = 1'b0,
               ACTIVE = 1'b1;

    reg        state;
    reg [3:0]  count;
    reg [10:0] frame;

    always @(posedge bd_clk or negedge rst_n) begin
        if (!rst_n) begin
            state  <= IDLE;
            count  <= 0;
            frame  <= 11'b0;
            tx     <= 1'b1;
            active <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    tx     <= 1'b1;
                    active <= 1'b0;
                    count  <= 0;
                    if (tx_start) begin
                        frame <= {1'b1, parity, data_in, 1'b0};
                        state <= ACTIVE;
                    end
                end
                ACTIVE: begin
                    active <= 1'b1;
                    tx     <= frame[0];
                    if (count == 4'd10) begin
                        state <= IDLE;
                        count <= 0;
                    end else begin
                        frame <= frame >> 1;
                        count <= count + 1'b1;
                    end
                end
            endcase
        end
    end

endmodule
