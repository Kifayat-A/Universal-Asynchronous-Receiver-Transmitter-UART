module baud_gen(
    input clk,rst_n,
    input [1:0]baud_rate,
    output reg bd_clk

);

reg [13:0] count;
reg [13:0] final_value;

localparam BAUD24 = 2'b00,
           BAUD48 = 2'b01,
           BAUD96 = 2'b10,
           BAUD192 =2'b11;

always @ (*)begin
    case(baud_rate) 
        BAUD24 : final_value = 14'd10417;  
        BAUD48 : final_value = 14'd5208;   
        BAUD96 : final_value = 14'd2604;   
        BAUD192 : final_value = 14'd1302;  
        default: final_value = 14'd0;
    endcase
end 

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        count <= 0;
        bd_clk <= 0;
    end
    else begin
        if(count == final_value) begin
            count <= 0 ;
            bd_clk <= ~bd_clk;
        end
        else begin
            count <= count+1;
            bd_clk <= bd_clk;
        end
        end
    end



endmodule