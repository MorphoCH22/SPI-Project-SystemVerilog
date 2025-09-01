module mux4to1(
        input [1:0] sel,
        input [3:0][7:0] dataIn,
        output reg [7:0] dataOut
    );
    
    always @(sel, dataIn) begin
    case (sel)
        2'b00:          dataOut <= dataIn[0];
        2'b01:          dataOut <= dataIn[1];
        2'b10:          dataOut <= dataIn[2];
        2'b11:          dataOut <= dataIn[3];
    endcase
    end
endmodule
