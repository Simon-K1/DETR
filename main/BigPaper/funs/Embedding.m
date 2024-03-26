classdef Embedding < GantTime
    properties
        In_Channel
        Out_Channel
        OutFeatureSize
        KernelSize
        CLK_CYCLE
        Freq
        WeightCache_Width%权重矩阵的缓存输入位宽
        Slice
        Height
        Width
        Fixed_Latency=0.01%特定时间延时0.001ms
 
        T_Img2Col%=GantTime(1);
        T_B%=GantTime(2);
        T_C%=GantTime(3);
        T_Add%=GantTime(4);
    end
    methods
        function obj=Embedding(Id,In_Channel,Out_Channel,OutFeatureSize,KernelSize,Freq,WeightCache_Width,Slice,Height,Width)
            obj = obj@GantTime(Id);
            obj.In_Channel=In_Channel;
            obj.Out_Channel=Out_Channel;
            obj.OutFeatureSize=OutFeatureSize;
            obj.KernelSize=KernelSize;
            obj.Freq=Freq;
            obj.CLK_CYCLE=((1/(Freq*10^6))*10^9)/10^6;
            obj.WeightCache_Width=WeightCache_Width
            obj.Slice=Slice
            obj.Height=Height;
            obj.Width=Width;
            obj.T_Img2Col=GantTime(1);
            obj.T_B=GantTime(2);
            obj.T_C=GantTime(3);
            obj.T_Add=GantTime(4);
            Embedding_Stage(obj);
        end
       function PlotGant(obj)
            startT=[obj.T_Img2Col.startT,obj.T_B.startT,obj.T_C.startT,obj.T_Add.startT]
            durationT=[obj.T_Img2Col.durationT,obj.T_B.durationT,obj.T_C.durationT,obj.T_Add.durationT]
            jobId=[obj.T_Img2Col.jobId,obj.T_B.jobId,obj.T_C.jobId,obj.T_Add.jobId]
            figure
            GTC=ganttChart(startT,durationT,jobId);
            % 定义新的 Y 轴坐标标签
            newYLabels = {'Img2Col', '矩阵B缓存', '脉动阵列计算', 'Add'};
            % 获取当前的 Y 轴刻度位置
            yticks = get(gca, 'YTick');
            % 设置新的 Y 轴坐标标签
            set(gca, 'yticklabel', newYLabels);
            ylabel('操作');

            % 设置 X 轴标签
            xlabel('时间(ms)');
            set(gca, 'FontSize', 12, 'FontWeight', 'bold');
            % 刷新图形
            drawnow;
        end

    end


    methods (Access = private)
        function Embedding_Stage(obj)

            A_Size=[obj.OutFeatureSize^2,obj.KernelSize^2*obj.In_Channel];
            B_Size=[obj.KernelSize^2*obj.In_Channel,obj.Out_Channel];

            [Conv_Cache,Conv_Compute,Conv_MACS]=GemmTime(A_Size,B_Size,[obj.Slice,obj.Height,obj.Width],obj.Freq,obj.WeightCache_Width);
            obj.T_Img2Col.AddTime(0,Conv_Compute)
            obj.T_C.AddTime(obj.T_Img2Col.LastStart+obj.Fixed_Latency,Conv_Compute)
            obj.T_B.AddTime(0,Conv_Cache)
            
            obj.T_Add.AddTime(obj.T_C.LastStart+obj.T_C.LastDuration/10,obj.T_C.LastEnd*0.83+obj.LayerAdd([A_Size(1) B_Size(2)],8,200));
            obj.AddTime(0,obj.T_Add.LastEnd)
        end

    end
end

% 
% function [T_Embedding] = Embedding()
% DMA_WDITH=16;%单位：字节
% 
% Freq=200;
% %HeadNums=12;
% 
% CLK_CYCLE=;%时钟周期：单位用ms来表示
% A_Size=[OutFeatureSize^2,KernelSize^2*In_Channel];
% B_Size=[KernelSize^2*In_Channel,Out_Channel];
% end