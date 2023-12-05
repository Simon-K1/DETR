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
(Out_Row*Out_Col*Out_Channel)*(KernelSize^2*Feature_Channel)*2;
14*14*384*16*16*3*2/10^9
%% Dsp复用模拟  Uint8计算
addpath("main\funs\");

% A=randi([-128,127],1);
% B=randi([-128,127],1);
% C=randi([0,255],1);
A=-119
B=89
C=239
A_Hex=dec2hex(A);
B_Hex=dec2hex(B);
C_Hex=dec2hex(C);
A_C=A*C;
B_C=B*C;
A_C_Hex=dec2hex(A_C);
B_C_Hex=dec2hex(B_C);

Dsp_In1=hex2dec([A_Hex,'00',Fixed_Length_Hex(B,2)])
Dsp_In2=C;
Dsp_Out=dec2hex(Dsp_In1*Dsp_In2)

Dsp_Out_Fliplr=flip(Dsp_Out);

Split=[hex2dec(fliplr(Dsp_Out_Fliplr(5:end))),hex2dec(fliplr(Dsp_Out_Fliplr(1:4)))]
assert((Split(1)==A*C)&&Split(2)==B*C)

%% Int有符号计算
if 1
W1=randi([-128,127],1);
W2=randi([-128,127],1);
Act=randi([-128,127],1);
end
if 0
W1=-52;
W2=-120;
Act=70;%激活为无符号数
end
if 0
W1=-119;
W2=89;
Act=239;%激活为无符号数
end
% 第一步：由于Dsp的计算模式为(A+D)*B--A(8 bit) D(25 bit) B(9 bit)
Din=W1*2^17+W2;
Bin=Act;
Pout=Din*Bin;
Pout_Hex=dec2hex(Pout)
Pout_Bin=Fixed_Length_Bin(Pout,34);
Upper=Complt2Sourcd(Pout_Bin(1:17))
Lower=Complt2Sourcd(Pout_Bin(18:end))
[W1,W2,Act]
assert(Upper==W1*Act&&Lower==W2*Act)
