%% 论文实验画图
clear
load("matlab.mat")
%% 初始配置信息手动设置
%step1：设置脉动阵列大小
SA_size=[8,9];
%step2：设置alpha入gamma出
InOut=[1,8];
%% 下面无需修改，开始计算两种架构的计算时间开销
if InOut(1)*InOut(2)*KernelSize^2~=SA_size(1)*SA_size(2)
    warning("脉动阵列的计算单元数量和几入几出的计算单元数量不一致");
end
%当前卷积参数下脉动阵列计算时间
SA_ComputeTime=ceil(Out_Row/SA_size(1))*ceil(Out_Col/SA_size(2))*Out_Channel*(Feature_Channel*KernelSize^2+SA_size(2)-1);
SA_ComputeTime=Out_Row*Out_Col*Out_Channel*(Feature_Channel*KernelSize^2+SA_size(2)-1)/(SA_size(1)*SA_size(2));

%% 算？入？出的卷积架构的计算时间
%输入通道分块：
InChannel_Split_Nums=ceil(Feature_Channel/InOut(1));
%输出通道分块:
OutChannel_Split_Nums=ceil(Out_Channel/InOut(2));
%对输入通道和输出通道进行分块后，输出特征图一个完整的像素点就需要InChannel_Split_Nums*OutChannel_Split_Nums个周期
arc2_ComputeTime=InChannel_Split_Nums*OutChannel_Split_Nums*(Out_Row*Out_Col)
SA_ComputeTime



