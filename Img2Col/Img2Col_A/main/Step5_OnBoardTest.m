%% 拿到第三步生成的指令和此步骤生成的标准输入bin文件上板验证，最后和标准输出进行逐字节对比
clear 
load("matlab.mat")
Picture_Flattened=reshape(Feature_In',1,[]);
if WEIGHT_VERSION==1
WeightMatrix_Flattened=reshape(WeightMatrix,1,[]);
else
    %这里先默认权重的列数为8的倍数，或者输出图片的通道为8的倍数
    WeightMatrix_Flattened=[];
    for i=8:8:size(WeightMatrix,2)
        WeightMatrix_Flattened=[WeightMatrix_Flattened,reshape(WeightMatrix(:,i-7:i)',1,[])];
    end
end
%% 单独生成图片和权重
if 0
    fid=fopen("PictureIn.bin",'w');
    fwrite(fid,Picture_Flattened,"uint8");
    fclose(fid);
    
    fid=fopen("Weight.bin",'w');
    fwrite(fid,WeightMatrix_Flattened,"int8");
    fclose(fid);

%     Picture=reshape(randi(15,[40,40*32*2]),1,[]);
%     fid=fopen("Picture.bin",'w');
%     fwrite(fid,Picture,"int8");
%     fclose(fid);
%     
% Picture=reshape(randi(15,[40,40*32*2]),1,[]);
%     fid=fopen("Picture.txt",'w');
%     for i=1:size(Picture,2)
% fprintf(fid,"%x,\n",Picture(i));
%     end
%     fclose(fid);
end
%% 也可以将图片和权重拼起来（前期测试的方案，权重放图片前面)
Weitht_Picture=[WeightMatrix_Flattened,Picture_Flattened];
fid=fopen("Weight_Picture.bin",'w');
fwrite(fid,Weitht_Picture,"int8");
fclose(fid);

%% 发送数据量和收回数据量计算
SendPicture_Len=size(Feature_In,1)*size(Feature_In,2);%单位：字节
SendWeight_Len=size(WeightMatrix,1)*size(WeightMatrix,2);
ReceivePicture_Len=Out_Col*Out_Row*Out_Channel;
[SendPicture_Len,SendWeight_Len,SendPicture_Len+SendWeight_Len,ReceivePicture_Len]

%% 创建全仿COE文件
if 0
    command = 'bin2coe -i Weight_Picture.bin -w 64 -o Weight_Picture.coe';
    [status,cmdout] = system(command)
end
