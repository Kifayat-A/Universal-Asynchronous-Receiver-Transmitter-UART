module parity_in(
    input rst_n,[1:0]parity_type,
    input [7:0] data_in,
    output reg parity
);

localparam ODD = 2'b01,
           EVEN = 2'b10;

always @(*) begin
    if(!rst_n) begin
        parity = 0 ;
    end
    else begin
        case(parity_type) 
            (ODD):parity = ^data_in ? 0 : 1;
            (EVEN):parity = ^data_in ? 1 : 0;
            default: parity =1;
        endcase
    end
end
endmodule