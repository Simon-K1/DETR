%Matlab DataGenerate for img2col
%% 生成第一版的img2col测试数据输入
clear
Feature_Size=224;%图片大小224*224
Feature_Channel=3;%图片通道3
Frature_In=zeros(Feature_Size,Feature_Size*Feature_Channel);
Feature_Row=zeros(1,224);
addr=1;
for col =1:Feature_Size%先生成一行数据
    for channel=1:Feature_Channel
        Feature_Row(1,addr+channel-1)=col;
    end
    addr=addr+Feature_Channel;
end
for row=1:Feature_Size
    Frature_In(row,:)=Feature_Row;
end

fid_raw_W=fopen('Img2Col_Txt\img2Col顺序输入测试数据.txt','w');
Matrix_Flattened=reshape(Frature_In',1,[])%展平
Shape=size(Matrix_Flattened);
%由于一下进8个点也就是8个通道，需要通道补零
 for i=3:3:Shape(2)
  %通道按从低往高排列，比如第一个通道的点放最低位
  fprintf(fid_raw_W,'%02x%02x%02x%02x%02x%02x%02x%02x\n',0,0,0,0,0,Matrix_Flattened(i),Matrix_Flattened(i-1),Matrix_Flattened(i-2));%低位第一个点，高位第二个点，
 end
fclose(fid_raw_W);