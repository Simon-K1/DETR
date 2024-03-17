startT=[0 3 5 12 16,1.5 6 8 15 18,3 10 11 16 19,2 4 11 13 15,1 3 7 16 18,5 11 14 16 20 33];
durationT=[3 2 5 4 4,4 1 7 2 5,6 1 4 3 2,1 6 2 2 9,2 3 4 2 5,5 3 1 2 8 14];
jobId=[1 1 1 1 1,2 2 2 2 2,3 3 3 3 3,4 4 4 4 4,5 5 5 5 5,6 6 6 6 6 6];

% GTC=ganttChart(startT,durationT,jobId);
% GTC=ganttChart(startT,durationT,jobId,'Curvature',.4);

startT=[T_Img2Col.startT,T_A.startT,T_B.startT,T_C.startT,T_Concat.startT,T_LayerNorm.startT,T_Softmax.startT,T_Add.startT]
durationT=[T_Img2Col.durationT,T_A.durationT,T_B.durationT,T_C.durationT,T_Concat.durationT,T_LayerNorm.durationT,T_Softmax.durationT,T_Add.durationT]
jobId=[T_Img2Col.jobId,T_A.jobId,T_B.jobId,T_C.jobId,T_Concat.jobId,T_LayerNorm.jobId,T_Softmax.jobId,T_Add.jobId]
GTC=ganttChart(startT,durationT,jobId);
%卷积
%1     Img2Col
%2     Gemm
%3     A
%4     B
%5     C
%6     LayerNorm
%7     Softmax
%8     Concat
%9     Add
%10    

%% 时间预估
if exist("matlab.mat",'file')
    clear
    load("matlab.mat")
    fid=fopen("time.txt",'w')
    LayerNorm_Parall=8;%暂时不修改
    SoftMax_Parall=8;%暂时不修改
    Add_Parall=8;%暂时不修改
    DMA_WDITH=16;%单位：字节
    MLP_Ratio=4 ;%用于控制MLP层的Linear维度默认4
    Freq=200;
    %HeadNums=12;

    CLK_CYCLE=((1/(Freq*10^6))*10^9)/10^6 ;%时钟周期：单位用ms来表示
    A_Size=[OutFeatureSize^2,KernelSize^2*Feature_Channel];
    B_Size=[KernelSize^2*Feature_Channel,Out_Channel];
    %% 卷积计算
    T_Img2Col=GantTime(1);
    T_A=GantTime(2);
    T_A=GantTime(2);
    T_B=GantTime(3);
    T_C=GantTime(4);
    T_LayerNorm=GantTime(5);
    T_Softmax=GantTime(6);
    T_Concat=GantTime(7);
    T_Add=GantTime(8);
    Fixed_Latency=0.001%特定时间延时0.001ms

    [Conv_Cache,Conv_Compute,Conv_MACS]=GemmTime(A_Size,B_Size,[Slice,Height,Width],Freq,DMA_WDITH);
    Conv_Gops=Conv_MACS/(Conv_Compute+Conv_Cache)*10^3%B矩阵缓存时间时间不应该考虑，因为在计算的时候可以同时缓存权重
    Total_Time=Conv_Compute+Conv_Cache;
    Total_Macs=Conv_MACS;
    fprintf(fid,"卷积计算：Mac:%.3f,Delay:%.3f,Gops:%.3f\n",Conv_MACS,Total_Time,Conv_Gops);
    
    T_Img2Col.AddTime(0,Conv_Compute)
    T_A.AddTime(T_Img2Col.LastStart+Fixed_Latency,Conv_Compute)
    T_B.AddTime(0,Conv_Cache)
    T_C.AddTime(T_A.LastStart,Conv_Compute)

    %Concat
    Total_Time=Total_Time+0.01;
    C_Size=[A_Size(1)+1,B_Size(2)];

    T_Concat.AddTime(T_C.LastStart+0.01,T_C.LastDuration)


    %LayerNorm
    LayerNorm_Time=(ceil(A_Size(1)/LayerNorm_Parall)+1)*(B_Size(2)+randi([10,33],1,1))*CLK_CYCLE
    Total_Time=Total_Time+LayerNorm_Time;
    fprintf(fid,"LayerNorm%.3f\n",LayerNorm_Time);
    
    T_LayerNorm.AddTime(T_Concat.LastEnd,LayerNorm_Time)

    %Encoder开始
    %Linear1层构建QKV
    Encoder_Time=0;
    Encoder_Macs=0;
    [Linear1_Cache,Linear1_Compute,Linear1_MACs]=GemmTime(C_Size,[C_Size(2),C_Size(2)*3],[Slice,Height,Width],Freq,DMA_WDITH);
    Linear1_Compute=Linear1_Compute+Linear1_Cache
%     [Linear1_Cache,Linear1_Compute,Linear1_MACs]=GemmTime(C_Size,[C_Size(2),C_Size(2)/HeadNums],[Slice,Height,Width],Freq,DMA_WDITH);
%     Linear1_Compute=(Linear1_Compute+Linear1_Cache)*3*HeadNums;
    Linear1_Gops=Linear1_MACs/Linear1_Compute*10^3 %在后面继续除一个Slice*Width是因为只需要统计第一次循环的缓存时间就行，剩下的数据可以边算变换成
    Encoder_Time=Encoder_Time+Linear1_Compute;
    Encoder_Macs=Encoder_Macs+Linear1_MACs;
    fprintf(fid,"Encoder_Linear：Mac:%.3f,Delay:%.3f,Gops:%.3f\n",Linear1_MACs,Linear1_Compute,Linear1_Gops);

    for j=1:3
        for i=1:HeadNums
            if i==1&&j==1
                [Linear1_Cache,Linear1_Compute,Linear1_MACs]=GemmTime(C_Size,[C_Size(2),C_Size(2)/HeadNums],[Slice,Height,Width],Freq,DMA_WDITH);
                T_B.AddTime(T_LayerNorm.LastEnd,Linear1_Cache);
                T_A.AddTime(T_LayerNorm.LastEnd,Linear1_Compute)
                T_C.AddTime(T_A.LastStart+0.01,Linear1_Compute);
            else
                [Linear1_Cache,Linear1_Compute,Linear1_MACs]=GemmTime(C_Size,[C_Size(2),C_Size(2)/HeadNums],[Slice,Height,Width],Freq,DMA_WDITH);
                T_B.AddTime(T_C.LastEnd,Linear1_Cache);
                T_A.AddTime(T_C.LastEnd,Linear1_Compute)
                T_C.AddTime(T_A.LastStart+0.01,Linear1_Compute);
            end
        end
    end
    
    %开始计算Q，K，V
    %QK^T
    [QK_Cache,QK_Compute,QK_MACs]=GemmTime([C_Size(1),C_Size(2)/HeadNums],[C_Size(2)/HeadNums,C_Size(1)],[Slice ,Height,Width],Freq,DMA_WDITH);
    QK_Compute=QK_Compute*HeadNums%(ceil(HeadNums/Slice))
    QK_Gops=QK_MACs*HeadNums/QK_Compute*10^3;
    Encoder_Time=Encoder_Time+QK_Compute;
    Encoder_Macs=Encoder_Macs+QK_MACs*HeadNums;
    fprintf(fid,"QK^T：Mac:%.3f,Delay:%.3f,Gops:%.3f\n",QK_MACs*HeadNums,QK_Compute,QK_Gops);
    %SoftMax
    SoftMax_Time=(ceil(A_Size(1)/LayerNorm_Parall)+1)*(A_Size(1)+randi([10,33],1,1))*CLK_CYCLE;
    SoftMax_Time=SoftMax_Time*1;
    Encoder_Time=Encoder_Time+SoftMax_Time;
    fprintf(fid,"Softmax%.3f\n",SoftMax_Time);


        %Softmax(Q*K)
        for i=1:HeadNums
            if i==1
                [QK_Cache,QK_Compute,QK_MACs]=GemmTime([C_Size(1),C_Size(2)/HeadNums],[C_Size(2)/HeadNums,C_Size(1)],[Slice,Height,Width],Freq,DMA_WDITH);
                T_A.AddTime(T_C.LastEnd+0.01,QK_Compute)
                T_B.AddTime(T_C.LastEnd+0.01,QK_Cache)
                T_C.AddTime(T_A.LastStart+0.005,QK_Compute)
                T_Softmax.AddTime(T_C.LastEnd,C_Size(1)*ceil(C_Size(1)/8)*CLK_CYCLE)
            else
                [QK_Cache,QK_Compute,QK_MACs]=GemmTime([C_Size(1),C_Size(2)/HeadNums],[C_Size(2)/HeadNums,C_Size(1)],[Slice,Height,Width],Freq,DMA_WDITH);
                T_A.AddTime(T_Softmax.LastEnd+0.01,QK_Compute)
                T_B.AddTime(T_Softmax.LastEnd+0.01,QK_Cache)
                T_C.AddTime(T_A.LastStart+0.005,QK_Compute)
                T_Softmax.AddTime(T_C.LastEnd,C_Size(1)*ceil(C_Size(1)/8)*CLK_CYCLE)
            end
        end


    %QKV
    %Softmax的结果量化到4bit，所以这里的脉动阵列的列数应该*2
    %在计算QKV时V作为A矩阵输入，Attn作为B矩阵输入
    [QKV_Cache,QKV_Compute,QKV_MACs]=GemmTime([C_Size(2)/HeadNums,C_Size(1)],[C_Size(1),C_Size(1)],[Slice*2,Height,Width],Freq,DMA_WDITH);%2024.2.22修改Slice*2，不应该增加列数的，不然性能还弱了
    %下面这一条是预估不转置计算时的情况，结果显示计算资源被严重浪费并并且计算效率减少到了之前的1/6
    %[QKV_Cache,QKV_Compute,QKV_MACs]=GemmTime([C_Size(1),C_Size(1)],[C_Size(1),C_Size(2)/HeadNums],[Slice,Height,Width*2],Freq,DMA_WDITH);
    
    QKV_Compute=QKV_Compute*HeadNums;
    QKV_Gops=QKV_MACs*HeadNums/QKV_Compute*10^3;
    Encoder_Time=Encoder_Time+QKV_Compute;
    Encoder_Macs=Encoder_Macs+QKV_MACs*HeadNums;
    fprintf(fid,"QKV：Mac:%.3f,Delay:%.3f,Gops:%.3f\n",QKV_MACs*HeadNums,QKV_Compute,QKV_Gops);

    %ShortCut Add
    Add=ceil(C_Size(1)/Add_Parall)*(C_Size(2)+randi([10],1))*CLK_CYCLE
    Encoder_Time=Encoder_Time+Add;
    fprintf(fid,"shortcutAdd：Delay:%.3f\n",Add);
    for i=1:HeadNums
        [QKV_Cache,QKV_Compute,QKV_MACs]=GemmTime([C_Size(2)/HeadNums,C_Size(1)],[C_Size(1),C_Size(1)],[Slice,Height,Width],Freq,DMA_WDITH);
        if i==1
            T_A.AddTime(T_Softmax.LastEnd,QKV_Compute)
            T_B.AddTime(T_Softmax.LastEnd,QKV_Cache)
            T_C.AddTime(T_A.LastStart+0.005,QKV_Compute)
            
        else
            T_A.AddTime(T_C.LastEnd,QKV_Compute)
            T_B.AddTime(T_C.LastEnd,QKV_Cache)
            T_C.AddTime(T_A.LastStart+0.005,QKV_Compute)
            %边乘边Concat
            if i==2
                T_Concat.AddTime(T_C.LastEnd+0.005,ConcatTime([C_Size(1),C_Size(2)/HeadNums],[C_Size(1),C_Size(2)/HeadNums*(i-1)],8,16,200));
            else
                T_Concat.AddTime(T_Concat.LastEnd+0.005,ConcatTime([C_Size(1),C_Size(2)/HeadNums],[C_Size(1),C_Size(2)/HeadNums*(i-1)],8,16,200));
            end
        end
    end
    T_Add.AddTime(T_Concat.LastEnd,AddTime([C_Size(1),C_Size(2)],8,200))
    %MLP开始
    %LayerNorm
    LayerNorm_Time=(ceil(A_Size(1)/LayerNorm_Parall)+1)*(B_Size(2)+randi([10,33],1,1))*CLK_CYCLE
    Encoder_Time=Encoder_Time+LayerNorm_Time;
    fprintf(fid,"LayerNorm%.3f\n",LayerNorm_Time);
    
    T_LayerNorm.AddTime(T_Add.LastEnd,C_Size(1)*C_Size(2)/8*CLK_CYCLE)


    %Linear with RELU
        %这里的Linear维度与mlp ratio有关  维度=Embedding_Dim*MlpRatio
    [Linear_Cache,Linear_Compute,Linear_MACs]=GemmTime([C_Size(1),C_Size(2)],[C_Size(2),C_Size(2)*4],[Slice,Height,Width],Freq,DMA_WDITH)
    Linear_Compute=(Linear_Compute+Linear_Cache);
    Linear_Gops=Linear_MACs/Linear_Compute*10^3;
    Encoder_Time=Encoder_Time+Linear_Compute;
    Encoder_Macs=Encoder_Macs+Linear_MACs;
    fprintf(fid,"LinearWithRelu：Mac:%.3f,Delay:%.3f,Gops:%.3f\n",Linear_MACs,Linear_Compute,Linear_Gops);
        
    T_A.AddTime(T_LayerNorm.LastEnd,Linear_Compute);
    T_B.AddTime(T_LayerNorm.LastEnd,Linear_Cache);
    T_C.AddTime(T_A.LastStart+0.005,Linear_Compute);
    
    
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
    
    T_A.AddTime(T_C.LastEnd,Linear_Compute);
    T_B.AddTime(T_C.LastEnd,Linear_Cache);
    T_C.AddTime(T_A.LastStart+0.005,Linear_Compute)

    %Cls 开始
    LayerNorm_Time=(ceil(A_Size(1)/LayerNorm_Parall)+1)*(B_Size(2)+randi([10,33],1,1))*CLK_CYCLE
    fprintf(fid,"FCN_LayerNorm%.3f\n",LayerNorm_Time);
    Total_Time=Total_Time+LayerNorm_Time
    
    T_LayerNorm.AddTime(T_C.LastEnd,C_Size(1)*C_Size(2)/8*CLK_CYCLE);

    [FCN_Cache,FCN_Compute,FCN_MACs]=GemmTime([1,C_Size(2)],[C_Size(2),1000],[Slice,Height,Width],Freq,DMA_WDITH);
%     [FCN_Cache,FCN_Compute,FCN_MACs]=GemmTime([1000,C_Size(2)],[C_Size(2),1],[Slice,Height,Width],Freq,DMA_WDITH);
    FCN_Compute=FCN_Compute+FCN_Cache;
    FCN_Gops=FCN_MACs/FCN_Compute*10^3;
    Total_Time=Total_Time+FCN_Compute;
    Total_Macs=Total_Macs+FCN_MACs;
    Total_Gops=Total_Macs/Total_Time*10^3;
    fprintf(fid,"FCN：Mac:%.3f,Delay:%.3f,Gops:%.3f\n",FCN_MACs,FCN_Compute,FCN_Gops);
    fprintf(fid,"Total：Mac:%.3f,Delay:%.3f,Gops:%.3f\n",Total_Macs,Total_Time,Total_Gops);
    
    T_A.AddTime(T_LayerNorm.LastEnd,FCN_Compute);
    T_B.AddTime(T_C.LastEnd,FCN_Cache);
    T_C.AddTime(T_A.LastStart+0.005,FCN_Compute)
    
    
    fclose all;
else
    OutFeatureSize=14;
    KernelSize=16;
    Feature_Channel=8;
    Out_Channel=768;
    DMA_WDITH=24;

    GemmTime([196,16*16*8],[16*16*8,768],[4,8,64],200,DMA_WDITH)
end