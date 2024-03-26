
function [WeightCache_Time,Compute_Time,MACs]=GemmTime(A_Size,B_Size,SA_Size,Freq,DMA_WIDTH)
    % SA[Slice,Height,Width]
    
    assert(A_Size(2)==B_Size(1));
    
    if(~exist("Freq","var"))
        Freq=200%默认200M,输入参数默认为时钟周期
        warning("频率设置为200M")
    end
    if(~exist("DMA_WIDTH",'var'))
        DMA_WIDTH=8;
    end
    CLK_CYCLE=((1/(Freq*10^6))*10^9)/10^6 ;%单位用ms来表示
    %输出矩阵的大小：
    C_Size=[A_Size(1),B_Size(2)];
    WeightCache_Time_All=(B_Size(1)*B_Size(2)/DMA_WIDTH)*CLK_CYCLE;
    WeightCache_Time=(B_Size(2)*B_Size(1)/DMA_WIDTH)*CLK_CYCLE
    %只需缓存第一轮也就是SLICE*WIDTH列的数据，剩下的数据可以边算边缓存
    
    Tmp1=ceil(((C_Size(1)*C_Size(2))/(SA_Size(1)*SA_Size(2)*SA_Size(3))));%脉动阵列每次可以出3*8*64个点，那么需要出多少次
    Compute_Time=Tmp1*(A_Size(2)+SA_Size(3)-1)*CLK_CYCLE;

    %感觉上面那种算法不太对
     Compute_Time=ceil(A_Size(1)/SA_Size(2))*ceil(B_Size(2)/(SA_Size(1)*SA_Size(3)))*(A_Size(2))*CLK_CYCLE
%     if(varargin{1}=="DSPx2")%DSP复用
%         %如果是Dsp复用，那么一下能进两个点
%     end
    MACs=(A_Size(1)*B_Size(2))*(A_Size(2)*2)/10^9;
    
end