clear
load("matlab.mat")
%% 查看权重矩阵所占资源(KB)
MemSize=Row*Col/1024;


fprintf("输入通道：%d\n卷积核大小：%d\n输出通道：%d\n",Feature_Channel,KernelSize,Out_Channel)
fprintf("权重数据所占资源数量:%d KB\n",MemSize)
fprintf("所需Bram个数：%d \n",MemSize/4)
%% 检查读写地址有没有超,一开始默认的地址位宽都是16位
SA_Col=8;%脉动阵列列数
DMA_Width=8;%权重缓存模块的DMA位宽,单位：字节
InDepth=Row*Col/(SA_Col*DMA_Width);
OutDepth=Row*Col/SA_Col;
fprintf("写入地址范围：0~%d,地址位宽：%d\n",InDepth-1,ceil(log2(InDepth)))
fprintf("读出地址范围：0~%d,地址位宽：%d\n",OutDepth-1,ceil(log2(OutDepth)))

%% 生成仿真txt
%权重也按通道优先展开,列优先存储
%先将权重矩阵展平
Matrix_Flattened=reshape(WeightMatrix',1,[]);%按列优先展平
fid_raw_W=fopen('WeightData.txt','w');
Shape=size(Matrix_Flattened);
 for i=8:8:Shape(2)
  %通道按从低往高排列，比如第一个通道的点放最低位
  fprintf(fid_raw_W,'%02x%02x%02x%02x%02x%02x%02x%02x,\n',Matrix_Flattened(i),Matrix_Flattened(i-1),Matrix_Flattened(i-2),Matrix_Flattened(i-3),Matrix_Flattened(i-4),Matrix_Flattened(i-5),Matrix_Flattened(i-6),Matrix_Flattened(i-7));%低位第一个点，高位第二个点，
 end
fclose(fid_raw_W);
