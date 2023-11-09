%% 卷积量化
clear
load("matlab.mat");
addpath("funs\");
%% 先创建随机的量化参数
if ~exist('Scale_Bias_Shift.txt','file')
    [Bias,Scale,Shift]=Step8_ConvQuant().Gen_Rand_Data(OutFeatureSize^2,Out_Channel);
    save("matlab.mat")
end
%% 拿到量化参数后，开始模拟量化计算
%脉动阵列出来的图片用元胞数组存储，但是计算还是按矩阵计算那样来描述
OutFeature_3D_UnArranged;%

Step8_ConvQuant().ConvQuant_Compute(Scale,Bias,Shift,OutFeature_3D_UnArranged{1}(:,1)',134)%输入的应该是第一行的第一个点的全部通道，即OutFeature_3D_UnArranged{row}(通道,col)
%% 暂时插一段layernorm的数据
%64bit中包含4个16bit，每个16bit中包含8bit scale和shift
%同样地，每个64bit包含32个ptf，每个ptf为2bit
fid=fopen('LayerNorm.txt','w');
for i=1:(Out_Channel/4+Out_Channel/32)
    fprintf(fid,"000000000000000%d\n",i);
end
%% 将每个txt文件拼接起来
fidA=fopen('WeightData.txt','r');
fidB=fopen('Scale_Bias_Shift.txt','r');
fid_Layernorm=fopen('LayerNorm.txt','r')
fidC=fopen('img2Col随机输入测试数据.txt','r')
DataA=fread(fidA);
DataB=fread(fidB);
Data_LayerNrom=fread(fid_Layernorm);
DataC=fread(fidC);




fidAll=fopen('Data_All.txt','w');
fwrite(fidAll,DataA);
fwrite(fidAll,DataB);
fwrite(fidAll,Data_LayerNrom);
fwrite(fidAll,DataC);
fclose all;





dataIn=281469346930688;
scale=909765798;
result=dataIn*scale
result_bin=dec2bin(result)
result_bin=['11',result_bin]
result=fliplr(result_bin)
result=result(49:80)
result=fliplr(result)

A=838860800
B=-6468640768
Complt2Sourcd(dec2bin(A+B))