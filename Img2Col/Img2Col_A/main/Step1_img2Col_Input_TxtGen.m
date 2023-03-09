%% 第一步： 生成8x输入通道的测试数据，包含32输入通道的图片和32输出通道的卷积权重
    % 图片大小，步长等相关信息需要手动配置
clear
Feature_Size=225;%图片大小224*224
Feature_Channel=48;%图片通道32
Out_Channel=64;

Stride=5;%要修改
KernelSize=5;%要修改
OutFeatureSize=75;%无需修改，在后面自动推理出来
%Strdie1
if Stride==KernelSize
%     OutFeatureSize=Feature_Size/KernelSize;
    if(mod(Feature_Size,KernelSize)==0)
        OutFeatureSize=Feature_Size/KernelSize;
    else
%         fprintf("Error:kernelSize必须和FeatureSize匹配\n")
        error('Error:kernelSize必须和FeatureSize匹配\n')
    end
else 
    if Stride==1
    OutFeatureSize=size(1:Feature_Size-KernelSize+1,2);

    else 
        
            Tmp=1:Stride:Feature_Size;
            if(Tmp(end)~=Feature_Size)
                Feature_Size=Tmp(end)+KernelSize-1
            end
            OutFeatureSize=size(Tmp,2)
        
    end
end
Compute_OutChannel=8;%每次计算的输出通道，先别动
Compute_OutCol=8;%每次计算的输出列数，先别动


Out_Col=OutFeatureSize;
Out_Row=OutFeatureSize;
Out_Col_Lefted=Out_Col;
In_Col=Feature_Size;
In_Row=Feature_Size;


Feature_In=zeros(Feature_Size,Feature_Size*Feature_Channel);
Feature_Row=zeros(1,Feature_Size);



for row=1:Feature_Size
    Row_Data=rand(1,Feature_Size*Feature_Channel)*5;
    Row_Data_Outer=(Row_Data>255)*255;%将大于255的数变成255
    Row_Data_Inner=Row_Data.*(Row_Data<=255);%将小于255的数保留
    Row_Data=Row_Data_Outer+Row_Data_Inner;
    Row_Data=round(Row_Data);
    Feature_In(row,:)=Row_Data;
end

fid_raw_W=fopen('img2Col随机输入测试数据.txt','w');
Matrix_Flattened=reshape(Feature_In',1,[]);%展平
Shape=size(Matrix_Flattened);

 for i=8:8:Shape(2)
  %通道按从低往高排列，比如第一个通道的点放最低位
  fprintf(fid_raw_W,'%02x%02x%02x%02x%02x%02x%02x%02x\n',Matrix_Flattened(i),Matrix_Flattened(i-1),Matrix_Flattened(i-2),Matrix_Flattened(i-3),Matrix_Flattened(i-4),Matrix_Flattened(i-5),Matrix_Flattened(i-6),Matrix_Flattened(i-7));%低位第一个点，高位第二个点，
 end
fclose(fid_raw_W);
%% 开始构建权重数据
WeightMatrix=zeros(Feature_Channel*KernelSize*KernelSize,Out_Channel);%%构建权重矩阵
WeightMatrix_Row=zeros(1,Out_Channel);


Row=size(WeightMatrix,1);
Col=size(WeightMatrix,2);
for row=1:Row%遍历矩阵所有行
    Row_Data=rand(1,Col)*5;
    Row_Data_Outer=(Row_Data>255)*255;%将大于255的数变成255
    Row_Data_Inner=Row_Data.*(Row_Data<=255);%将小于255的数保留
    Row_Data=Row_Data_Outer+Row_Data_Inner;
    Row_Data=round(Row_Data);
    WeightMatrix(row,:)=Row_Data;
end

%% 生成权重仿真txt
%权重也按通道优先展开,列优先存储
%先将权重矩阵展平
Matrix_Flattened=reshape(WeightMatrix,1,[]);%按列优先展平
fid_raw_W=fopen('WeightData.txt','w');
Shape=size(Matrix_Flattened);
 for i=8:8:Shape(2)
  %通道按从低往高排列，比如第一个通道的点放最低位
  fprintf(fid_raw_W,'%02x%02x%02x%02x%02x%02x%02x%02x\n',Matrix_Flattened(i),Matrix_Flattened(i-1),Matrix_Flattened(i-2),Matrix_Flattened(i-3),Matrix_Flattened(i-4),Matrix_Flattened(i-5),Matrix_Flattened(i-6),Matrix_Flattened(i-7));%低位第一个点，高位第二个点，
 end
fclose(fid_raw_W);

save('matlab')