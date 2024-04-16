%% VGG有一个入256出512的卷积，很明显存不下，所以需要对通道进行拆分然后再Add
%卷积通道拆分
InChannel=256;
OutChannel=512;
Kernelsize=3;
MatrixB=rand([InChannel*Kernelsize^2,OutChannel]);
Method=Split_Method(MatrixB,1024*8,1,8,8);
Method.Section%Method即拆分策略，

%矩阵计算通道拆分

MatrixB=rand([InChannel*Kernelsize,OutChannel])
Method=Split_Method(MatrixB,1024,4,8,64)
Method.Section
