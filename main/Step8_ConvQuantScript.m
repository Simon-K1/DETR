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

Quant_Result=Step8_ConvQuant().ConvQuant_Compute(Scale,Bias,Shift,OutFeature_3D_UnArranged{1}(:,1)',59)%输入的应该是第一行的第一个点的全部通道，即OutFeature_3D_UnArranged{row}(通道,col)
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



%%

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
%%
%来自Pytorch的数据
S1=0.0078356666;
S2=0.0003194482;
S3=0.0291325375;
Scale=S1*S2/S3
Scale_Shift=0;
while ~(Scale>0.5&&Scale<1)
    Scale=Scale*2;
    Scale_Shift=Scale_Shift+1;
end
Scale_Shift
Scale=round(Scale*2^32)
%Scae算完后，并从pytorch中拿到定点化好的Bias
Bias=159623382
Bias_Bin=dec2bin(Bias)
Bias_Bin=BinSlice(Bias_Bin,[31,0]);
%开始算q1*q2+Bias
    %先算Bias_Tmp
    Bias_Shift=bin2dec(Bias_Bin(2:8));
    Bias_Tmp=[repmat(Bias_Bin(1),[1,8+Bias_Shift]),BinSlice(Bias_Bin,[23,0]),repmat('0',[1,16-Bias_Shift])];        
    Bias_Tmp=bin2dec(Bias_Tmp)
%接下来就是BiasAdd
q1q2=-8109;
    %q1q2左移16位然后再加Bias_Tmp
    BiasAdd=q1q2*2^16+Bias_Tmp%到目前为止结果左移了16位
%加完Bias再乘以Scale
Scale=3023067392;%定点化后的Scale
    ScaleMul=BiasAdd*Scale
%再除回去
    ScaleMul_Bin=dec2bin(ScaleMul)
    DataShifted=ScaleMul/2^(16)%先把加Bias用的16位移回去
    DataShifted=DataShifted/2^(Scale_Shift-1)