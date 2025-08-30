module MasterSPI(
        input clkIn,
        input reset,
        input [7:0] dataIn,
        input [3:0] selIn,
        input transPulse,
        output reg [7:0] data,
        
        input [3:0] MISO,
        output clkOut,
        output reg MOSI,
        output [3:0] selOut
    );
    
    reg [3:0] count;
    reg state;
    reg [3:0] sel;

    assign clkOut = clkIn&(state|!reset);
    assign selOut = sel;

    always @(posedge (clkIn)) begin
        if (!reset) begin
            sel <= 4'b1111;
            MOSI <= 1'b0;
            data <= 8'b0;
            count <= 4'b0;
            state <= 1'b0;
        end else begin
            case (state)
                1'b0: begin
                sel <= selIn;
                    if (transPulse) begin
                        data <= dataIn;
                        count <= 4'b0;
                        state <= 1'b1;
                    end
                end
                1'b1: begin
                    MOSI <= data[7];
                    case (sel)
                        4'b1110:    data <= {data[6:0], MISO[0]};
                        4'b1101:    data <= {data[6:0], MISO[1]};
                        4'b1011:    data <= {data[6:0], MISO[2]};
                        4'b0111:    data <= {data[6:0], MISO[3]};
                        default:    data <= data;
                    endcase
                    if (count == 4'b1000)
                        state <= 1'b0;
                    count <= count + 1;
                end
            endcase
        end
    end
endmodule
