%% 卷积量化
clear
load("matlab.mat");

%% 先创建随机的量化参数

[Bias,Scale,Shift]=Step8_ConvQuant().Gen_Rand_Data(OutFeatureSize^2,Out_Channel);
%% 拿到量化参数后，开始模拟量化计算
%脉动阵列出来的图片用元胞数组存储，但是计算还是按矩阵计算那样来描述
OutFeature_3D_UnArranged;%

Step8_ConvQuant().ConvQuant_Compute(Scale,Bias,Shift,OutFeature_3D_UnArranged{1}(1,:))


test=dec2bin(Bias)
test=BinSlice(test,[30,24])
test=bin2dec(test)