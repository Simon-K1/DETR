%% 第一步： 生成8x输入通道的测试数据，包含32输入通道的图片和32输出通道的卷积权重
    % 图片大小，步长等相关信息需要手动配置
clear
Drop_Message=1;%将图片继续补零以匹配卷积不丢失信息
WEIGHT_VERSION=1;%权重缓存模块的版本，可选1（V1），2（V2，已失效）
Feature_Size=224;%图片大小224*224
Feature_Channel=8;%图片通道
Out_Channel=32;%输出图片通道，要修改

Stride=16;%要修改
KernelSize=16;%要修改
assert(Stride<=KernelSize,"Stride must be less than kernelSize");
%脉动阵列配置
Slice=8;
Width=8;
Height=8;

%Compute_InChannel=Height;%每次计算的输出通道，
%Compute_OutChannel=Slice*Width;%每次计算的输出列数，先别动

OutFeatureSize=75;%无需修改，在后面自动推理出来
assert(mod(Feature_Channel,8)==0,"输入通道必须是8的倍数");
assert(mod(Out_Channel,8)==0,"输出通道必须是8的倍数");
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
        if ~Drop_Message%若不丢失信息，继续补零
            
            if(Tmp(end)~=Feature_Size)
                Feature_Size=Tmp(end)+KernelSize-1%修改图片大小
            end
        else%若丢失信息，则修改输出图片大小
            %说明：比如3*3卷积，步长为2，输入图片322*322，
                %对于3*3的步长为2的卷积来说是无法覆盖全部图片的（321*321->160*160,323*323->161*161)
                %这里就是将322*322的图片变成321*321的图片，得到160*160的输出。
                %上面就是将322*322的图片变成323*323的图片，得到161*161的输出。
            %do nothing
        end
        OutFeatureSize=size(Tmp,2)-1
    end
end



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
save('matlab')
%% 生成权重仿真txt
%权重也按通道优先展开,列优先存储
%先将权重矩阵展平
if WEIGHT_VERSION==1
    Matrix_Flattened=reshape(WeightMatrix,1,[]);%按列优先展平
    fid_raw_W=fopen('WeightData.txt','w');
    Shape=size(Matrix_Flattened);
    for i=8:8:Shape(2)
        %通道按从低往高排列，比如第一个通道的点放最低位
        fprintf(fid_raw_W,'%02x%02x%02x%02x%02x%02x%02x%02x\n',Matrix_Flattened(i),Matrix_Flattened(i-1),Matrix_Flattened(i-2),Matrix_Flattened(i-3),Matrix_Flattened(i-4),Matrix_Flattened(i-5),Matrix_Flattened(i-6),Matrix_Flattened(i-7));%低位第一个点，高位第二个点，
    end
    fclose(fid_raw_W);
else% 权重格式版本2，
    fid_raw_W=fopen('WeightData.txt','w');
    Shape=size(WeightMatrix);
    for i=8:8:Shape(2)
        for j=1:Shape(1)
            Matrix_Flattened=WeightMatrix(j,i-7:i);
            %通道按从低往高排列，比如第一个通道的点放最低位
            fprintf(fid_raw_W,'%02x%02x%02x%02x%02x%02x%02x%02x\n',Matrix_Flattened(8),Matrix_Flattened(7),Matrix_Flattened(6),Matrix_Flattened(5),Matrix_Flattened(4),Matrix_Flattened(3),Matrix_Flattened(2),Matrix_Flattened(1));%低位第一个点，高位第二个点，
        end
    end
    fclose(fid_raw_W);

end

dec2bin(bin2dec('000000000000000000110001101000010000000000000000')+bin2dec('111111111111111111100111000101101111111011000000'))

