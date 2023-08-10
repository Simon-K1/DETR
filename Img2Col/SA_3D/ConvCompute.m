%% 手写卷积（已无效）
clear
load('matlab.mat')
% 2D图片转成[H,W,C]的格式
% Feature_In_3D=reshape(Feature_In,)
Feature_3D=zeros(In_Row,In_Col,Feature_Channel);%构建一个三维的图片，方便做3D卷积
for Row=1:size(Feature_3D,1)
    for Col=1:size(Feature_3D,2)
        Feature_3D(Row,Col,:)=Feature_In(Row,(Col-1)*Feature_Channel+1:Col*Feature_Channel);
    end
end
%% 将卷积核也转化为3维的（已无效）
Weight_4D=zeros(Out_Channel,KernelSize,KernelSize,Feature_Channel);
for Oc=1:Out_Channel
    for Row=1:KernelSize
        for Col=1:KernelSize
            RowBaseAddr=(Row-1)*KernelSize*Feature_Channel;
            Weight_4D(Oc,Row,Col,:)=WeightMatrix((Col-1)*Feature_Channel+1+RowBaseAddr:Col*Feature_Channel+RowBaseAddr,Oc);
        end
    end
end

Conv1=squeeze(Weight_4D(1,:,:,:)).*Feature_3D(1:4,1:4,1:end);
reshape(Feature_In(1:4,1:4*32)',1,[])*WeightMatrix(:,1:8)
sum(sum(sum(Conv1)))
Kernel2D=reshape(WeightMatrix(:,1),KernelSize*Feature_Channel,[])
%% 测试有符号和无符号计算的测试
SignedA=-10
SignedA_Hex=dec2hex(SignedA)
SignedA_Hex2Dec=hex2dec(SignedA_Hex)
UnsignedA=10
UnsignedA_Hex=dec2hex(UnsignedA)

