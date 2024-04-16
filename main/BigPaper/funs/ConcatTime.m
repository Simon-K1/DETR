function [Time_All] = ConcatTime(Data1_Size,Data2_Size,InPara,OutPara,Freq)
%UNTITLED7 此处提供此函数的摘要
%Data1,Data2--两个要拼接的矩阵的大小，InPara/OutPara：输入/输出并行度，一下能得到多少个点
CLK_CYCLE=((1/(Freq*10^6))*10^9)/10^6;
assert(Data1_Size(1)==Data2_Size(1));
Time1=ceil(Data1_Size(2)/InPara);
Time2=ceil(Data2_Size(2)/InPara);%输入一行数据的时间
Time_In=max(Time1,Time2);
Time_Out=ceil((Data1_Size(2)+Data2_Size(2))/OutPara)
Time_All=(Time_In+Time_Out)*Data2_Size(1)*CLK_CYCLE;
end