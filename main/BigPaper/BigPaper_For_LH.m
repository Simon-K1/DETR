%% 画4*4的大图,用柱状图来表示多个阵列对不同卷积的支持
clear
figure;
Freq=200;
CLK_CYCLE=((1/(Freq*10^6))*10^9)/10^6 ;%时钟周期：单位用ms来表示
Slice=1;
Height=8;
Width=8;
SA_Size=[
    1,16,32;
    1,32,64
]
DMA_WDITH=24;
for i = 1:14
    if 1
        figure
    else
        subplot(4,4,i);
    end
    
    KernelSize=i+2;
    times=[];
    Gops_Base=[];
    OutSize=[];
    All_Macs=[];
    All_Gops=[];
    Feature_Channel=8;
    Out_Channel=768;
    
    for Strides = 1:KernelSize;
        [InSize,OutFeatureSize]=BuildPicture(480,Feature_Channel,Out_Channel,KernelSize,Strides);
      
        OutSize=[OutSize,OutFeatureSize];%获取输入图片大小图片大小
        
        
        A_Size=[OutFeatureSize^2,KernelSize^2*Feature_Channel];
        B_Size=[KernelSize^2*Feature_Channel,Out_Channel];
        %% 卷积计算
        times=[];
        for SA_Cnt=1:size(SA_Size,1)%遍历所有的脉动阵列
            Slice=SA_Size(SA_Cnt,1);
            Height=SA_Size(SA_Cnt,2);
            Width=SA_Size(SA_Cnt,3);
            [Conv_Cache,Conv_Compute,Conv_MACS]=GemmTime(A_Size,B_Size,[Slice,Height,Width],Freq,DMA_WDITH);
            Conv_Gops=Conv_MACS/(Conv_Compute+Conv_Cache)*10^3%B矩阵缓存时间时间不应该考虑，因为在计算的时候可以同时缓存权重
            Total_Time=Conv_Compute+Conv_Cache;
            Total_Macs=Conv_MACS;
    
            times = [times,Conv_Gops-Conv_Gops*0.2];
            
%             All_Macs=[All_Macs;Gops_Base];
            
        end
        %记录信息：
        Gops_Base=[Gops_Base,Total_Macs];%这里名字没取好
        All_Gops=[All_Gops;times]
        
    end
    color = rand(1,3);  % 随机生成RGB颜色
    %plot(1:KernelSize, times,'-p','LineWidth',1,'Color',color);
    bar(All_Gops);
%     set(gca, 'YScale', 'log');
    ylabel("Gops")
    hold on
    color = rand(1,3);  % 随机生成RGB颜色
    yyaxis right;
%     semilogy(1:KernelSize, Gops, 'r-o');
%     hold on

%     gca.YAxis(2).Scale = 'log';  % 设置右边坐标轴为对数刻度
    plot(1:KernelSize, Gops_Base,'-o','LineWidth',3,'Color','green');
    %xlabel("kernelsize");
    ylabel("Macs")
    title("KernelSize="+string(KernelSize)+";Stride=1~"+string(KernelSize),'FontWeight','bold')
    grid on
end
legend('[16*32]','[32*64]');




%% 设计空间探索1--热度图
