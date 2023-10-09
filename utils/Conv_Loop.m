%% 阵列配置
SA_H=8
SA_W=8
SA_Num=1
SA_Ability=SA_H*SA_W*SA_Num
%% 卷积相关计算速度分析
IW=224
IH=224
OW=14
OH=14
K=16
IC=8
OC=768

A_Size=[OW*OH,IC*K^2]
B_Size=[IC*K^2,OC]
MulTimes=OW*OH*IC*K^2*OC%乘法次数

Clk_1=MulTimes/SA_Ability%第一种计算方法
Clk_2=(OW*OH/(SA_H*SA_W*SA_Num))*(A_Size(2)+SA_H-1)*OC
%两种方法的结果为嘛还不一样？ 
%% 矩阵相关计算量分析
A_Size=[197,768]
B_Size=[768,768*3]
Clk_Matrix=(A_Size(1)*B_Size(2)/(SA_H*SA_W*SA_Num))*(A_Size(2)+SA_H-1)

