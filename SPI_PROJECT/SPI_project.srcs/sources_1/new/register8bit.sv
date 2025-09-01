module register8bit(
        input clk,
        input reset,
        input push, sel,
        input [7:0] D,
        output reg [7:0] Q
    );
    
always @(posedge(clk)) begin
    if (!reset)
        Q <= 0;
    else if (push&sel)
        Q <= D;
end
endmodule
