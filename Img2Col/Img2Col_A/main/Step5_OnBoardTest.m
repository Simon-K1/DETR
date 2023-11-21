%% 拿到第三步生成的指令和此步骤生成的标准输入bin文件上板验证，最后和标准输出进行逐字节对比
clear 
load("matlab.mat")
Picture_Flattened=reshape(Feature_In',1,[]);
if WEIGHT_VERSION==1
    WeightMatrix_Flattened=reshape(WeightMatrix,1,[]);
    assert(exist("Scale","var"),"如果还没有生成量化参数，需要先到step8生成随机的量化参数，更新matlab.mat后再重新生成上板bin文件");
    %
    Scale_Flattened=reshape(Scale,1,[]);
    Bias_Flattened=reshape(Bias,1,[]);
    Shift_Flattened=reshape(Shift,1,[]);

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
fid=fopen("OnBoardTest.bin",'w');
fwrite(fid,WeightMatrix_Flattened,"uint8");
fwrite(fid,Bias_Flattened,"uint32");%uint8和int8生成的bin文件还有区别，存在一种可能，2341694147用int32无法表示，因为int32还要1bit的符号位。。。
fwrite(fid,Scale_Flattened,"uint32");
fwrite(fid,Shift_Flattened,"uint32");
fwrite(fid,Picture_Flattened,"uint8");
fclose(fid);
%% 发送数据量和收回数据量计算
SendPicture_Len=size(Feature_In,1)*size(Feature_In,2);
SendWeight_Len=size(WeightMatrix,1)*size(WeightMatrix,2);
SendQuantFactor_Len=Out_Channel*3*4;%Scale，Shift，Zp，每个参数4字节，每个通道都有一个Factor
ReceivePicture_Len=Out_Col*Out_Row*Out_Channel;
[SendPicture_Len,SendWeight_Len,SendPicture_Len+SendWeight_Len,ReceivePicture_Len];
fprintf("SendLength=%d;\n",SendPicture_Len+SendWeight_Len+SendQuantFactor_Len)
fprintf("ReceiveLength=%d;\n",ReceivePicture_Len)

%% 创建全仿COE文件
if 0
    command = 'bin2coe -i Weight_Picture.bin -w 64 -o Weight_Picture.coe';
    [status,cmdout] = system(command)
end
