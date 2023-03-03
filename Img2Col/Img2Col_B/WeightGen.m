%% 生成随机权重,用于生成权重的仿真输入txt
clear
KernelSize=16;%卷积核大小
InChannel=32%输入通道，这里不像之前仿真Img2Col那样设置一个8输入通道,现在直接设置一个大一点的输入通道
OutChannel=32;%输出通道,768输出通道数据太大了
Stride=16;%步长

WeightMatrix=zeros(InChannel*KernelSize*KernelSize,OutChannel);%%构建权重矩阵
WeightMatrix_Row=zeros(1,OutChannel);

Feature_Row=zeros(1,224);

Row=size(WeightMatrix,1);
Col=size(WeightMatrix,2);
for row=1:Row%遍历矩阵所有行
    Row_Data=rand(1,Col)*300;
    Row_Data_Outer=(Row_Data>255)*255;%将大于255的数变成255
    Row_Data_Inner=Row_Data.*(Row_Data<=255);%将小于255的数保留
    Row_Data=Row_Data_Outer+Row_Data_Inner;
    Row_Data=round(Row_Data);
    WeightMatrix(row,:)=Row_Data;
end




