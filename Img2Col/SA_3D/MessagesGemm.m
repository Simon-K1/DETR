%% 矩阵相关信息
clear
WeightCache_Size=2048*8*8;%权重Cache的大小，比如8*8的SA上方挂了8块Bram，每个Bram的存储为8B*2048
%%
% load("MM_Data.mat")
MatrixA_Size=[10000,384];%修改
MatrixB_Size=[384,192];%修改
WeightSize=MatrixB_Size(1)*MatrixB_Size(2);
fprintf("WeightCache剩余空间：%%%f\n",(WeightCache_Size-WeightSize)/WeightCache_Size*100);
ComputeTime_88=(MatrixA_Size(1)*MatrixB_Size(2)/64)*(8-1+MatrixA_Size(2))*5/1000000;
ComputeTime_888=(MatrixA_Size(1)*MatrixB_Size(2)/(8*8*8))*(8-1+MatrixA_Size(2))*5/1000000;
fprintf("预估计算时间：%f/%f\n",ComputeTime_88,ComputeTime_888);



