module SlaveSPI(
        input clkIn,
        input reset,
        
        input selIn,
        input MOSI,
        output reg MISO,
        output reg [3:0] data
    );
    
    reg [2:0] count;
    reg state;
    
    always @(posedge (clkIn)) begin
        if (!reset) begin
            MISO <= 1'b0;
            data <= 4'b0;
            count <= 3'b0;
            state <= 1'b0;
        end else begin
            case (state)
                1'b0: begin
                    if (!selIn) begin
                        count <= 3'b0;
                        state <= 1'b1;
                    end 
                end
                1'b1: begin
                    MISO <= data[3];
                    data <= {data[2:0], MOSI};
                    if (count == 3'b100)
                        state <= 1'b0;
                    count <= count + 1;
                end
            endcase
        end
    end
endmodule
