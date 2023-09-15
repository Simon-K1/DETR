module test(
    input clk,
    input rst,
    input signal,//一比特一比特输入的序列
    output o_signal

);
reg a,b,c;
always@(posedge clk)begin
    
    if(rst)begin
        a<=0;
        b<=0;
        c<=0;
    end
    else begin
        a<=signal;
        b<=a;
        c<=b;
    end
end

always@(*)begin
    if({{a},{b},{c}}==3'b101||{{a},{b},{c}}==3'b010)begin
        o_signal=1;
    end
    else begin
        o_signal=0;
    end
end
endmodule