%% 每一个网络大层流水
clear
load("matlab.mat")
fid=fopen("time.txt",'w')
LayerNorm_Parall=8;%暂时不修改
SoftMax_Parall=8;%暂时不修改
Add_Parall=8;%暂时不修改

%% 卷积计算
T_Img2Col=GantTime(1);
T_B=GantTime(2);
T_C=GantTime(3);
T_Add=GantTime(8);
Fixed_Latency=0.001%特定时间延时0.001ms

[Conv_Cache,Conv_Compute,Conv_MACS]=GemmTime(A_Size,B_Size,[Slice,Height,Width],Freq,DMA_WDITH);
Conv_Gops=Conv_MACS/(Conv_Compute+Conv_Cache)*10^3%B矩阵缓存时间时间不应该考虑，因为在计算的时候可以同时缓存权重
Total_Time=Conv_Compute+Conv_Cache;
Total_Macs=Conv_MACS;
fprintf(fid,"卷积计算：Mac:%.3f,Delay:%.3f,Gops:%.3f\n",Conv_MACS,Total_Time,Conv_Gops);

T_Img2Col.AddTime(0,Conv_Compute)
T_A.AddTime(T_Img2Col.LastStart+Fixed_Latency,Conv_Compute)
T_B.AddTime(0,Conv_Cache)
T_C.AddTime(T_A.LastStart,Conv_Compute)

%Add
Total_Time=Total_Time+0.01;
C_Size=[A_Size(1)+1,B_Size(2)];

T_Concat.AddTime(T_C.LastStart+0.01,T_C.LastDuration)


