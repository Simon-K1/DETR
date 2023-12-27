%% 时间预估
if exist("matlab.mat",'file')
    load("matlab.mat")
    fid=fopen("time.txt",'w')
    LayerNorm_Parall=8;%暂时不修改
    SoftMax_Parall=8;%暂时不修改
    Add_Parall=8;%暂时不修改
    DMA_WDITH=24;%单位：字节
    MLP_Ratio=4 ;%用于控制MLP层的Linear维度 默认4
    Freq=200;
    %HeadNums=12;

    CLK_CYCLE=((1/(Freq*10^6))*10^9)/10^6 ;%时钟周期：单位用ms来表示
    A_Size=[OutFeatureSize^2,KernelSize^2*Feature_Channel];
    B_Size=[KernelSize^2*Feature_Channel,Out_Channel];
    %% 卷积计算
    [Conv_Cache,Conv_Compute,Conv_MACS]=GemmTime(A_Size,B_Size,[Slice,Height,Width],Freq,DMA_WDITH);
    Conv_Gops=Conv_MACS/(Conv_Compute+Conv_Cache)*10^3%B矩阵缓存时间时间不应该考虑，因为在计算的时候可以同时缓存权重
    Total_Time=Conv_Compute+Conv_Cache;
    Total_Macs=Conv_MACS;
    fprintf(fid,"卷积计算：Mac:%.3f,Delay:%.3f,Gops:%.3f\n",Conv_MACS,Total_Time,Conv_Gops);
    %Concat
    Total_Time=Total_Time+0.01;
    C_Size=[A_Size(1)+1,B_Size(2)];
    %LayerNorm
    LayerNorm_Time=(ceil(A_Size(1)/LayerNorm_Parall)+1)*(B_Size(2)+randi([10,33],1,1))*CLK_CYCLE
    Total_Time=Total_Time+LayerNorm_Time;
    fprintf(fid,"LayerNorm%.3f\n",LayerNorm_Time);


    %Encoder开始
    %Linear1层构建QKV
    Encoder_Time=0;
    Encoder_Macs=0;
    [Linear1_Cache,Linear1_Compute,Linear1_MACs]=GemmTime(C_Size,[C_Size(2),C_Size(2)*3],[Slice,Height,Width],Freq,DMA_WDITH);
    Linear1_Compute=Linear1_Compute+Linear1_Cache
    Linear1_Gops=Linear1_MACs/Linear1_Compute*10^3 %在后面继续除一个Slice*Width是因为只需要统计第一次循环的缓存时间就行，剩下的数据可以边算变换成
    Encoder_Time=Encoder_Time+Linear1_Compute;
    Encoder_Macs=Encoder_Macs+Linear1_MACs;
    fprintf(fid,"Encoder_Linear：Mac:%.3f,Delay:%.3f,Gops:%.3f\n",Linear1_MACs,Linear1_Compute,Linear1_Gops);
    %开始计算Q，K，V
    %QK^T
    [QK_Cache,QK_Compute,QK_MACs]=GemmTime([C_Size(1),C_Size(2)/HeadNums],[C_Size(2)/HeadNums,C_Size(1)],[Slice ,Height,Width],Freq,DMA_WDITH);
    QK_Compute=QK_Compute*HeadNums%(ceil(HeadNums/Slice))
    QK_Gops=QK_MACs*HeadNums/QK_Compute*10^3;
    Encoder_Time=Encoder_Time+QK_Compute;
    Encoder_Macs=Encoder_Macs+QK_MACs*HeadNums;
    fprintf(fid,"QK^T：Mac:%.3f,Delay:%.3f,Gops:%.3f\n",QK_MACs*HeadNums,QK_Compute,QK_Gops);
    %SoftMax
    SoftMax_Time=(ceil(A_Size(1)/LayerNorm_Parall)+1)*(B_Size(2)+randi([10,33],1,1))*CLK_CYCLE;
    Encoder_Time=Encoder_Time+SoftMax_Time;
    fprintf(fid,"Softmax%.3f\n",SoftMax_Time);
    %QKV
    %Softmax的结果量化到4bit，所以这里的脉动阵列的列数应该*2
    %在计算QKV时V作为A矩阵输入，Attn作为B矩阵输入
    [QKV_Cache,QKV_Compute,QKV_MACs]=GemmTime([C_Size(2)/HeadNums,C_Size(1)],[C_Size(1),C_Size(1)],[Slice,Height,Width*2],Freq,DMA_WDITH)
    QKV_Compute=QKV_Compute*HeadNums;
    QKV_Gops=QKV_MACs*HeadNums/QKV_Compute*10^3;
    Encoder_Time=Encoder_Time+QKV_Compute;
    Encoder_Macs=Encoder_Macs+QKV_MACs*HeadNums;
    fprintf(fid,"QKV：Mac:%.3f,Delay:%.3f,Gops:%.3f\n",QKV_MACs*HeadNums,QKV_Compute,QKV_Gops);
    %ShortCut Add
    Add=ceil(C_Size(1)/Add_Parall)*(C_Size(2)+randi([10],1))*CLK_CYCLE
    Encoder_Time=Encoder_Time+Add;
    fprintf(fid,"shortcutAdd：Delay:%.3f\n",Add);

    %MLP开始
    %LayerNorm
    LayerNorm_Time=(ceil(A_Size(1)/LayerNorm_Parall)+1)*(B_Size(2)+randi([10,33],1,1))*CLK_CYCLE
    Encoder_Time=Encoder_Time+LayerNorm_Time;
    fprintf(fid,"LayerNorm%.3f\n",LayerNorm_Time);
    %Linear with RELU
        %这里的Linear维度与mlp ratio有关  维度=Embedding_Dim*MlpRatio
    [Linear_Cache,Linear_Compute,Linear_MACs]=GemmTime([C_Size(1),C_Size(2)],[C_Size(2),C_Size(2)*4],[Slice,Height,Width],Freq,DMA_WDITH)
    Linear_Compute=(Linear_Compute+Linear_Cache);
    Linear_Gops=Linear_MACs/Linear_Compute*10^3;
    Encoder_Time=Encoder_Time+Linear_Compute;
    Encoder_Macs=Encoder_Macs+Linear_MACs;
    fprintf(fid,"LinearWithRelu：Mac:%.3f,Delay:%.3f,Gops:%.3f\n",Linear_MACs,Linear_Compute,Linear_Gops);
        %Linear+Add Relu完了继续把维度变回来
    [Linear_Cache,Linear_Compute,Linear_MACs]=GemmTime([C_Size(1),C_Size(2)*4],[C_Size(2)*4,C_Size(2)],[Slice,Height,Width],Freq,DMA_WDITH);
    Linear_Compute=(Linear_Compute+Linear_Cache);
    Linear_Gops=Linear_MACs/Linear_Compute*10^3;
    Encoder_Time=Encoder_Time+Linear_Compute;
    Encoder_Macs=Encoder_Macs+Linear_MACs;
    Total_Time=Total_Time+Encoder_Time*12;
    Total_Macs=Total_Macs+Encoder_Macs*12;
    fprintf(fid,"LinearWithAdd：Mac:%.3f,Delay:%.3f,Gops:%.3f\n",Linear_MACs,Linear_Compute,Linear_Gops);
    fprintf(fid,"Encoder Time:%.3f  Encoder Macs:%f  Encoder_Gops:%.3f\n",Encoder_Time,Encoder_Macs,Encoder_Macs/Encoder_Time);
    
    %Cls 开始
    LayerNorm_Time=(ceil(A_Size(1)/LayerNorm_Parall)+1)*(B_Size(2)+randi([10,33],1,1))*CLK_CYCLE
    fprintf(fid,"FCN_LayerNorm%.3f\n",LayerNorm_Time);
    Total_Time=Total_Time+LayerNorm_Time
    
    [FCN_Cache,FCN_Compute,FCN_MACs]=GemmTime([1,C_Size(2)],[C_Size(2),1000],[Slice,Height,Width],Freq,DMA_WDITH);
    FCN_Compute=FCN_Compute+FCN_Cache;
    FCN_Gops=FCN_MACs/FCN_Compute;
    Total_Time=Total_Time+FCN_Compute;
    Total_Macs=Total_Macs+FCN_MACs;
    Total_Gops=Total_Macs/Total_Time*10^3;
    fprintf(fid,"FCN：Mac:%.3f,Delay:%.3f,Gops:%.3f\n",FCN_MACs,FCN_Compute,Linear_Gops);
    fprintf(fid,"Total：Mac:%.3f,Delay:%.3f,Gops:%.3f\n",Total_Macs,Total_Time,Total_Gops);
    
    fclose all;
else
    OutFeatureSize=14;
    KernelSize=16;
    Feature_Channel=8;
    Out_Channel=768;
    DMA_WDITH=24;

    GemmTime([196,16*16*8],[16*16*8,768],[4,8,64],200,DMA_WDITH)
end
