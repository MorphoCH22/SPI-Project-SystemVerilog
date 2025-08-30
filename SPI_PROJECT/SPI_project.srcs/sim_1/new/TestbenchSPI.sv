module TestbenchSPI;

bit clk;
bit reset;
bit transPulse;
bit [3:0] selIn;

bit [7:0] mDataIn;
bit [3:0][7:0] sDataIn;
        
bit [7:0] mDataOut;
bit [3:0][7:0] sDataOut;


always #10 clk = ~clk;

TopSPI cut  (
            .clk(clk),
            .reset(reset),
            .transPulse(transPulse),
            .selIn(selIn),
            .mDataIn(mDataIn),
            .sDataIn(sDataIn),
            .mDataOut(mDataOut),
            .sDataOut(sDataOut)
            );

initial begin
    clk <= 0;
    mDataIn <= 8'd32;
    sDataIn[0] <= 8'd10;
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
