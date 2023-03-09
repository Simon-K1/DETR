%Matlab DataGenerate for img2col
%% 生成第一版的img2col测试数据输入
clear
Feature_Size=224;%图片大小224*224
Feature_Channel=3;%图片通道3
Feature_In=zeros(Feature_Size,Feature_Size*Feature_Channel);
Feature_Row=zeros(1,224);
addr=1;
for col =1:Feature_Size%先生成一行数据
    for channel=1:Feature_Channel
        Feature_Row(1,addr+channel-1)=col;
    end
    addr=addr+Feature_Channel;
end
for row=1:Feature_Size
    Feature_In(row,:)=Feature_Row;
end

fid_raw_W=fopen('Img2Col_Txt\img2Col顺序输入测试数据.txt','w');
Matrix_Flattened=reshape(Feature_In',1,[])%展平
Shape=size(Matrix_Flattened);
%由于一下进8个点也就是8个通道，需要通道补零
 for i=3:3:Shape(2)
  %通道按从低往高排列，比如第一个通道的点放最低位
  fprintf(fid_raw_W,'%02x%02x%02x%02x%02x%02x%02x%02x\n',0,0,0,0,0,Matrix_Flattened(i),Matrix_Flattened(i-1),Matrix_Flattened(i-2));%低位第一个点，高位第二个点，
 end
fclose(fid_raw_W);


%% 仿真地其他数据测试
Row_Base_Addr0=0:224:224*15
Row_Base_Addr1=(224*16:224:224*31)'
Row_Base_Addr=(0:224:224*31)'
%Matlab DataGenerate for img2col
%% 生成第二版的img2col测试数据输入，随机数据，与vivado仿真对比
clear
Feature_Size=224;%图片大小224*224
Feature_Channel=3;%图片通道3
Feature_In=zeros(Feature_Size,Feature_Size*Feature_Channel);
Feature_Row=zeros(1,224);


for row=1:Feature_Size
    Row_Data=rand(1,Feature_Size*3)*300;
    Row_Data_Outer=(Row_Data>255)*255;%将大于255的数变成255
    Row_Data_Inner=Row_Data.*(Row_Data<=255);%将小于255的数保留
    Row_Data=Row_Data_Outer+Row_Data_Inner
    Row_Data=round(Row_Data)
    Feature_In(row,:)=Row_Data;
end

fid_raw_W=fopen('Img2Col_Txt\img2Col随机输入测试数据.txt','w');
Matrix_Flattened=reshape(Feature_In',1,[])%展平
Shape=size(Matrix_Flattened);
%由于一下进8个点也就是8个通道，需要通道补零
 for i=3:3:Shape(2)
  %通道按从低往高排列，比如第一个通道的点放最低位
  fprintf(fid_raw_W,'%02x%02x%02x%02x%02x%02x%02x%02x\n',0,0,0,0,0,Matrix_Flattened(i),Matrix_Flattened(i-1),Matrix_Flattened(i-2));%低位第一个点，高位第二个点，
 end
fclose(fid_raw_W);
%% 生成32输入通道的测试数据
clear
Feature_Size=224;%图片大小224*224
Feature_Channel=32;%图片通道32
In_Col=224;
In_Row=224;

Stride=2;
KernelSize=16;

Compute_OutChannel=8;%每次计算的输出通道
Compute_OutCol=8;%每次计算的输出列数

Row_Base_Addr=0;%行基地址
Kernel_Base_Addr=0;
Kernel_Addr=0;

Out_Channel=32;
Out_Col=14;
Out_Row=14;
Out_Col_Lefted=Out_Col;



Feature_In=zeros(Feature_Size,Feature_Size*Feature_Channel);
Feature_Row=zeros(1,224);


for row=1:Feature_Size
    Row_Data=rand(1,Feature_Size*Feature_Channel)*300;
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
