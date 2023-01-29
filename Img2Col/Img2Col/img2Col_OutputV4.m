%% 生成一版8通道的随机输入用于上板测试
clear
Feature_Size=224;%图片大小224*224
Feature_Channel=8;%图片通道3
Feature_In=zeros(Feature_Size,Feature_Size*Feature_Channel);
Feature_Row=zeros(1,224);

load("保存的matlab数据\上板8通道测试数据.mat");
% for row=1:Feature_Size
%     Row_Data=rand(1,Feature_Size*Feature_Channel)*300;
%     Row_Data_Outer=(Row_Data>255)*255;%将大于255的数变成255
%     Row_Data_Inner=Row_Data.*(Row_Data<=255);%将小于255的数保留
%     Row_Data=Row_Data_Outer+Row_Data_Inner
%     Row_Data=round(Row_Data)
%     Feature_In(row,:)=Row_Data;
% end

fid_raw_W=fopen('Img2Col_Txt\img2Col_8通道输入测试数据.txt','w');
Matrix_Flattened=reshape(Feature_In',1,[])%展平
Shape=size(Matrix_Flattened);
%由于一下进8个点也就是8个通道，需要通道补零
 for i=Feature_Channel:Feature_Channel:Shape(2)
  %通道按从低往高排列，比如第一个通道的点放最低位
  fprintf(fid_raw_W,'%02x%02x%02x%02x%02x%02x%02x%02x\n',Matrix_Flattened(i),Matrix_Flattened(i-1),Matrix_Flattened(i-2),Matrix_Flattened(i-3),Matrix_Flattened(i-4),Matrix_Flattened(i-5),Matrix_Flattened(i-6),Matrix_Flattened(i-7));%低位第一个点，高位第二个点，
 end
fclose(fid_raw_W);
%matlab生成标准输出与仿真对比
%分析：硬件部分是按行展开卷积核，一下处理8个滑窗

%% 然后生成bin文件
fid = fopen('binFiles/InFeature8通道输入.bin','w');% 更改 TriLib0.dat 为星库数据774320个星库，每个星库6个参数，每个参数2字节
fwrite(fid,Matrix_Flattened,'uint8');
fclose(fid);