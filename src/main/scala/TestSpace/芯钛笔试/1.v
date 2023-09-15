//用Verilog或VHDL写一段代码，实现对一个输入信号消除glitch(毛刺)，输入高电平时间小于1us认为是毛刺
module Test(
    input clk,//100M时钟
    input rst,
    input signal,//输入的信号
    output O_signal
);

reg [10:0]cnt;//100M时钟，每个周期为10ns，需要计数100次
reg O_signal;
always@(posedge clk)begin
    if(rst)begin
        cnt<=0;
    end
    else if (signal)begin
        cnt<=cnt+1'b1;
    end
end
reg [7:0]cnt100;//只数到100下；
reg signal_valid;//信号有效标志
always@(posedge clk)begin
    if(rst)begin
        cnt100<='d100;
    end
    else if(signal_valid)begin
        cnt100<=cnt100-1'b1;
    end
end
always@(posedge clk)begin
    if(rst)begin
        signal_valid<=0;
    end
    else if(cnt>=100)begin
        signal_valid<=1'b1;
    end
    else if(cnt100==0)begin
        signal_valid<=0;
    end
end

always@(posedge clk)begin
    if(rst)begin
        O_signal<=0;
    end
    else 
        if(cnt>100)begin
            O_signal<=signal|signal_valid;
        end
    end

endmodule