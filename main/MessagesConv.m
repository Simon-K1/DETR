%%
clear
load("matlab.mat")
%% 查看权重矩阵所占资源(KB)
MemSize=Row*Col/1024;


fprintf("输入通道：%d\n卷积核大小：%d\n输出通道：%d\n",Feature_Channel,KernelSize,Out_Channel)
fprintf("权重数据所占资源数量:%d KB\n",MemSize)
fprintf("所需Bram个数：%d \n",MemSize/4)
%% 检查读写地址有没有超,一开始默认的地址位宽都是16位
SA_Col=Slice*Width;%脉动阵列列数
DMA_Width=8;%权重缓存模块的DMA位宽,单位：字节
InDepth=Row*Col/(SA_Col*DMA_Width);%也就是Spianl中设置的Mem的最小深度
OutDepth=Row*Col/SA_Col;
fprintf("写入地址范围：0~%d,地址位宽：%d\n",InDepth-1,ceil(log2(InDepth)))
fprintf("读出地址范围：0~%d,地址位宽：%d\n",OutDepth-1,ceil(log2(OutDepth)))
%% 查看输入数据量（字节）
PictureIn_Num=Feature_Size^2*Feature_Channel;%单位字节
WeightIn_Num=size(WeightMatrix,1)*size(WeightMatrix,2);
fprintf("权重数据量：%d 字节\n",WeightIn_Num)
fprintf("图片数据量: %d 字节\n",PictureIn_Num)

%% 计算时间估计
fprintf("输入图片大小：%d\n输出图片大小:%d\n输入通道：%d\n卷积核大小：%d\n步长:%d\n输出通道：%d\n",Feature_Size,OutFeatureSize,Feature_Channel,KernelSize,Stride,Out_Channel)
fprintf("权重数据所占资源数量:%d KB\n",MemSize)
fprintf("所需Bram个数：%d \n",MemSize/4)
Conv_Compute_Time=((OutFeatureSize^2*Out_Channel)/(8*8))*(KernelSize^2*Feature_Channel+8)*5/1000000
Conv_Compute_Time=((OutFeatureSize^2*Out_Channel)/(8*8*8))*(KernelSize^2*Feature_Channel+8)*5/1000000

Gop=(KernelSize^2)*Feature_Channel*2*(OutFeatureSize^2*Out_Channel)
Gops=(Gop/10^9)/(Conv_Compute_Time/1000)