%% 第一步： 生成8x输入通道的测试数据，包含32输入通道的图片和32输出通道的卷积权重
    % 图片大小，步长等相关信息需要手动配置
clear

ProjDir="E:\Transformer\Matlab\main\Tests\SA_3D\SA_1_8_8\Padding";%修改
PytorchPath="E:\Transformer\Transformer_Arithmatic\Transformer_Main\BinPath\"
if exist(ProjDir,'dir')
    warning("文件夹已经存在！！")
    cd(ProjDir)
else
    mkdir(ProjDir)
    cd(ProjDir)
end
FromPytorch=0;%是否采用pytorch生成的真实数据
Drop_Message=1;%决定卷积完后图片大小要不要变化
               %默认为1，0选项在加入padding模块后已经没啥用了


WEIGHT_VERSION=1;%权重缓存模块的版本，可选1（V1），2（V2，已失效）
Feature_Size=224;%图片大小224*224（未Padding的图片大小）
Feature_Channel=8;%图片通道
Out_Channel=64;%输出图片通道，要修改
BinFile_Channel=Out_Channel;%一般来说binfile_channel和Out_Channel一样

enPadding=1;%要修改--要不要padding
zeroNum=3;%要修改--Padding补零的圈数，如果是1的话，图片的行和高都会加2
zeroData=0;%要修改，根据Pytorch量化结果来吧，没真实数据就用随机数

Stride=2;%要修改
KernelSize=7;%要修改
assert(Stride<=KernelSize,"Stride must be less than kernelSize");
%脉动阵列配置
Slice=1;
Height=8;%不要改
Width=8;
HeadNums=12;%注意力头的数量，记得修改HeadNums，Tiny=3,Small=6,base=12

%Compute_InChannel=Height;%每次计算的输出通道，
%Compute_OutChannel=Slice*Width;%每次计算的输出列数，先别动


%-----------------------------下面的都不要改-----------------------------------------
if enPadding==1 %Feature_Size=Feature_Size+zeroNum*2
  padding=zeroNum;
else
  padding=0;
end

OutFeatureSize=75;%无需修改，在后面自动推理出来
assert(mod(Feature_Channel,8)==0,"输入通道必须是8的倍数");
assert(mod(Out_Channel,8)==0,"输出通道必须是8的倍数");
if Stride==KernelSize
    if(mod(Feature_Size,KernelSize)==0)
        OutFeatureSize=Feature_Size/KernelSize;
    else
        error('Error:kernelSize必须和FeatureSize匹配\n')
    end
else
    OutFeatureSize =floor((Feature_Size+padding*2-KernelSize)/Stride)+1;
end

Out_Col=OutFeatureSize;
Out_Row=OutFeatureSize;
Out_Col_Lefted=Out_Col;


In_Col=Feature_Size;
In_Row=Feature_Size;

Feature_Size_padding=Feature_Size+padding*2;
Feature_In=zeros(Feature_Size_padding,Feature_Size_padding*Feature_Channel);
Feature_Row=zeros(1,Feature_Size);



% for row=1:Feature_Size_padding
%     for col=1:Feature_Size_padding*Feature_Channel%注意列数包含通道 每个row都是特征图的一层（包含通道）
%         if row <=padding || row >Feature_Size_padding-padding
%             Row_Data =zeroData;
%             Feature_In(row,col)=Row_Data;
%         elseif (padding < row && row <= Feature_Size_padding - padding) && (col <= padding*Feature_Channel || ((Feature_Size_padding - padding)*Feature_Channel < col ))
%             Row_Data =zeroData;
%             Feature_In(row,col)=Row_Data;
%         else
%             Row_Data=randi([1,255]);
%             Feature_In(row,col)=Row_Data;%Feature_Size*Feature_Channel个Row_Data
%         end
%     end
% end
Feature_In=reshape(randi([0,255],[Feature_Size,Feature_Size,Feature_Channel]),Feature_Size,[])
Feature_No_Padding=Feature_In(zeroNum+1:end-zeroNum,zeroNum+1:end-zeroNum);
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
%% 生成txt文件
if ~FromPytorch
    fid_raw_W=fopen('Rand_ImageIn.txt','w');
    Matrix_Flattened=reshape(Feature_No_Padding',1,[]);%转置 展平成一行,注意生成的是原始图片（未padding的）
    Shape=size(Matrix_Flattened);%取行数 列数
    %fprintf("shape2 %d\n ",Shape(2))
     for i=8:8:Shape(2)% 行数*列数(展平了) 一个是8bit
      %通道按从低往高排列，比如第一个通道的点放最低位
      fprintf(fid_raw_W,'%02x%02x%02x%02x%02x%02x%02x%02x\n',Matrix_Flattened(i),Matrix_Flattened(i-1),Matrix_Flattened(i-2),Matrix_Flattened(i-3),Matrix_Flattened(i-4),Matrix_Flattened(i-5),Matrix_Flattened(i-6),Matrix_Flattened(i-7));%低位第一个点，高位第二个点，
     end
    fclose(fid_raw_W);
end
%生成权重仿真txt
%权重也按通道优先展开,列优先存储
%先将权重矩阵展平
if ~FromPytorch
    if WEIGHT_VERSION==1
        Matrix_Flattened=reshape(WeightMatrix,1,[]);%按列优先展平
        fid_raw_W=fopen('Rand_Weight.txt','w');
        Shape=size(Matrix_Flattened);
        for i=8:8:Shape(2)
            %通道按从低往高排列，比如第一个通道的点放最低位
            fprintf(fid_raw_W,'%02s%02s%02s%02s%02s%02s%02s%02s\n',dec2hex(Matrix_Flattened(i)),dec2hex(Matrix_Flattened(i-1)),dec2hex(Matrix_Flattened(i-2)),dec2hex(Matrix_Flattened(i-3)),dec2hex(Matrix_Flattened(i-4)),dec2hex(Matrix_Flattened(i-5)),dec2hex(Matrix_Flattened(i-6)),dec2hex(Matrix_Flattened(i-7)));%低位第一个点，高位第二个点，
        end
        fclose(fid_raw_W);
    else% 权重格式版本2，
        fid_raw_W=fopen('Rand_Weight.txt','w');
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
end
dec2bin(bin2dec('000000000000000000110001101000010000000000000000')+bin2dec('111111111111111111100111000101101111111011000000'))

%% 读取pytorch生成的bin文件
if FromPytorch
    %先读取权重
    
    if Out_Channel~=BinFile_Channel
        warning("Bin文件的channel和设置的channel不一样")
        %有时候OnBoardTest.bin文件的channel是768，但是仿真的时候缓存768这么多数据很耗时间
        %所以只提取Bin文件里的前8通道进行仿真
    end
    
    fid=fopen(PytorchPath+"ConvWeight.bin")
    WeightMatrix=fread(fid,size(WeightMatrix),"int8")
    fclose(fid);
    %读取量化参数，量化数据排在权重数据后面
%     fid=fopen("WeightIn.bin")
%     Weight_Quant_Data=fread(fid)
%     fclose(fid);
%     Quant_Data  =Weight_Quant_Data(size(WeightMatrix,1)*size(WeightMatrix,2)+1:end);

%     fid=fopen("Bias_Scale_Shift.bin",'w')
%     fwrite(fid,Quant_Data,'uint8');%这里必须按uint8来写
%     fclose(fid);
    fid=fopen(PytorchPath+"ConvQuant.bin",'r')
    Bias_Scale_Shift=fread(fid,'uint32')
    fclose(fid);
    Scale=zeros(1,BinFile_Channel);
    Shift=zeros(1,BinFile_Channel);

    Bias=Bias_Scale_Shift(1:BinFile_Channel);
    Scale=Bias_Scale_Shift(BinFile_Channel+1:2*BinFile_Channel);
    Shift=Bias_Scale_Shift(2*BinFile_Channel+1:3*BinFile_Channel);
    Bias=Bias(1:Out_Channel);
    Scale=Scale(1:Out_Channel);
    Shift=Shift(1:Out_Channel);

    %再读图片
    fid=fopen(PytorchPath+"ImageIn.bin","r")
    Feature_In=fread(fid,fliplr(size(Feature_In)),"uint8")'%如果图片大小为[224*224*16]图片被展平成二维矩阵，前8个点代表图片第一行第一个点的前8通道，后8个点可就是第一个点的后8通道
    fclose(fid);
    save("matlab.mat")
end





