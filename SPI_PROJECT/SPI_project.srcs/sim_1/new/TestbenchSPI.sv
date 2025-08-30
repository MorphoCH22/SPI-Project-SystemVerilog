module TestbenchSPI;

bit clk;
bit reset;
bit transPulse;
bit [3:0] selIn;

bit [7:0] mDataIn;
bit [7:0] s1DataIn;
        
bit [7:0] mDataOut;
bit [7:0] s1DataOut;


always #10 clk = ~clk;

TopSPI cut  (
            .clk(clk),
            .reset(reset),
            .transPulse(transPulse),
            .selIn(selIn),
            .mDataIn(mDataIn),
            .s1DataIn(s1DataIn),
            .mDataOut(mDataOut),
            .s1DataOut(s1DataOut)
            );

initial begin
    clk <= 0;
    mDataIn <= 8'd32;
    s1DataIn <= 8'd10;
    reset <= 0;
    repeat (5) @(posedge(clk))
    reset <= 1;
    selIn <= 4'b1110;
    transPulse <= 1'b1;
    repeat (11) @(posedge(clk))
    transPulse <= 1'b0;
    $finish;
end

endmodule
