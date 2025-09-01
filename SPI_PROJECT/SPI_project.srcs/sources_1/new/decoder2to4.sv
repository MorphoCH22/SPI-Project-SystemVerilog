module decoder2to4(
        input [1:0] selectIn,
        output reg [3:0] selectOut
    );
    
    always @(selectIn) begin
    case (selectIn)
    2'b00:          selectOut <= 4'b0001;
    2'b01:          selectOut <= 4'b0010;
    2'b10:          selectOut <= 4'b0100;
    2'b11:          selectOut <= 4'b1000;
    default:        selectOut <= 4'b0000;
    endcase
    end
endmodule
