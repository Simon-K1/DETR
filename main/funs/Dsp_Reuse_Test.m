%% Dsp复用测试
% Int有符号计算
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