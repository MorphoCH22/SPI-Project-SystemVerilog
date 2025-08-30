module SlaveSPI(
        input clkIn,
        input reset,
        input [7:0] dataIn,
        
        input selIn,
        input MOSI,
        output reg MISO,
        output reg [7:0] data
    );
    
    reg [3:0] count;
    reg state;
    
    always @(posedge (clkIn)) begin
        if (!reset) begin
            MISO <= 1'b0;
            data <= 8'b0;
            count <= 4'b0;
            state <= 1'b0;
        end else begin
            case (state)
                1'b0: begin
                    if (!selIn) begin
                        data <= dataIn;
                        count <= 4'b0;
                        state <= 1'b1;
                    end 
                end
                1'b1: begin
                    MISO <= data[7];
                    data <= {data[6:0], MOSI};
                    if (count == 4'b1000)
                        state <= 1'b0;
                    count <= count + 1;
                end
            endcase
        end
    end
endmodule
