function [Time_All] = AddTime(Data_Size,InPara,Freq)
%UNTITLED7 Datasize 数据的大小（一个矩阵的大小）
%Data1,Data2--两个要拼接的矩阵的大小，InPara/OutPara：输入/输出并行度，一下能得到多少个点
CLK_CYCLE=((1/(Freq*10^6))*10^9)/10^6;

CLK_Nums=ceil(Data_Size(2)/InPara)*Data_Size(1)%边进边计算即可
Time_All=CLK_Nums*CLK_CYCLE;
end