module mux4to1(
        input [3:0][3:0] dataIn,
        input [3:0] sel,
        output reg [3:0] dataOut
    );
    
    always @(dataIn, sel) begin
        case (sel)
        4'b1110:    dataOut <= dataIn[0];
        4'b1101:    dataOut <= dataIn[1];
        4'b1011:    dataOut <= dataIn[2];
        4'b0111:    dataOut <= dataIn[3];
        default:    dataOut <= 0;
        endcase
    end
    
endmodule
