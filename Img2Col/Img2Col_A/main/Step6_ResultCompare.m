%% 第六步骤：结果对比
    % 读取fpga回来的数据进行逐字节对比
clear
load("../matlab.mat")
% load("../matlab_Conv.mat","OutFeature_3D_UnArranged")
fid=fopen("ConvResult.bin");
ConvOutput_Fpga=fread(fid,[Out_Col*Out_Channel,Out_Row]);    
ConvOutput_Fpga=ConvOutput_Fpga';
fclose(fid);


%% 硬件卷积输出（标准的图片格式），数据未量化
OutFeature=zeros(Out_Row,Out_Col*Out_Channel);
i=1;
j=1;
for row=1:Stride:In_Row-KernelSize+1%遍历行
    for col=1:Stride:In_Col-KernelSize+1%遍历列
        Window=reshape(Feature_In(row:row+KernelSize-1,(col-1)*Feature_Channel+1:(col+KernelSize-1)*Feature_Channel)',1,[]);%计算一个滑窗对应的全部输出点
        OutFeature(i,j:j+Out_Channel-1)=Window*WeightMatrix;
        j=j+Out_Channel;
    end
    i=i+1;
    j=1;
end
for i=1:size(OutFeature,1)%遍历行
    OriginData=OutFeature(i,:);
    OriginData_Cut=fliplr(dec2hex(OriginData));
    OriginData_Cut=fliplr(OriginData_Cut(:,1:2));%直接截位取低8bit
    OriginData_Cut=hex2dec(OriginData_Cut)';
    OutFeature(i,:)=OriginData_Cut;
end

%% 开始逐字节比较
ErrorFlag=0;
for i=1:size(OutFeature,1)
    for j=1:size(OutFeature,2)
        if OutFeature(i,j)~=ConvOutput_Fpga(i,j)
            [i,j]
            ErrorFlag=1;
            break
        end
    end
end
if ErrorFlag
    fprintf("卷积测试失败\n");
else
    fprintf("⭐卷积测试成功⭐\n");
end