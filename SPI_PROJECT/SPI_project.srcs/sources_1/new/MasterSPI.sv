module MasterSPI(
        input clkIn,
        input reset,
        input [7:0] dataIn,
        input [3:0] selIn,
        input transPulse,
        output reg [7:0] data,
        
        input MISO,
        output clkOut,
        output reg MOSI,
        output reg [3:0] selOut
    );
    
    reg [3:0] count;
    reg state;

    assign clkOut = clkIn&(state|!reset);

    always @(posedge (clkIn)) begin
        if (!reset) begin
            selOut <= 4'b1111;
            MOSI <= 1'b0;
            data <= 8'b0;
            count <= 4'b0;
            state <= 1'b0;
        end else begin
            case (state)
                1'b0: begin
                selOut <= selIn;
                    if (transPulse) begin
                        data <= dataIn;
                        count <= 4'b0;
                        state <= 1'b1;
                    end
                end
                1'b1: begin
                    MOSI <= data[7];
                    data <= {data[6:0], MISO};
                    if (count == 4'b1000)
                        state <= 1'b0;
                    count <= count + 1;
                end
            endcase
        end
    end
endmodule
