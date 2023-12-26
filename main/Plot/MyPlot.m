% 论文画图
%% 理论GOPs计算
SA_Size=[4,8,64];%脉动阵列大小：[Slice,Height,Width]
assert(mod(SA_Size(2),8)==0);
Dsp_Reuse=1;%Dsp 复用
Freq=0.2;%时频率，单位G

%-----------------------------------------------------------------------
mac=2;%乘加操作
if Dsp_Reuse
    mac=4;
end
Theoretical_Gops=SA_Size(1)*SA_Size(2)*SA_Size(3)*mac*Freq%理论计算峰值
%% 矩阵、卷积GOPs计算
load("matlab.mat")
Compute_Time=1.1%单位毫秒
ConvGops=(Out_Row*Out_Col*Out_Channel)*(KernelSize^2*Feature_Channel)*2*10^-1;




