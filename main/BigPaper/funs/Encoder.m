classdef Encoder<GantTime
    %UNTITLED12 此处提供此类的摘要
    %   此处提供详细说明

    properties
        T_LayerNorm
        T_Attn
        T_Add
        T_Mlp
        T_Start=0


        C_Size
        Slice
        Height
        Width
        Freq
        DMA_WDITH
        HeadNums

        VARARGIN
    end

    methods
        function obj =Encoder(Id,C_Size,HeadNums,Slice,Height,Width,Freq,DMA_WDITH,varargin)
            obj = obj@GantTime(Id);
            obj.C_Size=C_Size
            obj.Slice=Slice
            obj.Height=Height
            obj.Width=Width
            obj.Freq=Freq
            obj.DMA_WDITH=DMA_WDITH
            obj.HeadNums=HeadNums

            obj.T_LayerNorm=GantTime(1);
            obj.VARARGIN=varargin;
           if isempty(varargin)
                for i = 1:numel(varargin)
                    arg = varargin{i};
                    if i==1
                        obj.T_Start=arg;
                    end
                end
            end
            obj.LayerEncoder
        end
        function []=PlotGant(obj)
            startT=[obj.T_LayerNorm.startT,obj.T_Attn.startT,obj.T_Add.startT,obj.T_Mlp.startT]
            durationT=[obj.T_LayerNorm.durationT,obj.T_Attn.durationT,obj.T_Add.durationT,obj.T_Mlp.durationT]
            jobId=[obj.T_LayerNorm.jobId,obj.T_Attn.jobId,obj.T_Add.jobId,obj.T_Mlp.jobId]
            figure
            GTC=ganttChart(startT,durationT,jobId);


            % 定义新的 Y 轴坐标标签
            newYLabels = {'LayerNorm', 'Attention', 'Add', 'Mlp'};
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
        function []=LayerEncoder(obj)
            %先LayerNorm
            obj.T_LayerNorm.AddTime(obj.T_Start,Layer_LayerNorm(obj,obj.C_Size,200));
            
            %注意力完了之后先Add再LayerNorm
            obj.T_Attn=Attn(2,obj.C_Size,obj.HeadNums,obj.Slice,obj.Height,obj.Width,obj.Freq,obj.DMA_WDITH,obj.T_LayerNorm.LastEnd,0);
            obj.T_Add=GantTime(3);
            obj.T_Add.AddTime(obj.T_Attn.LastEnd,LayerAdd(obj,[obj.C_Size],8,200))%Atn之后的add操作
            obj.T_LayerNorm.AddTime(obj.T_Add.LastEnd,Layer_LayerNorm(obj,obj.C_Size,200));
            %Add完了开始进入MLP
            obj.T_Mlp=Mlp(4,obj.C_Size,obj.HeadNums,obj.Slice,obj.Height,obj.Width,obj.Freq,obj.DMA_WDITH,obj.T_LayerNorm.LastEnd);
            obj.T_Add.AddTime(obj.T_Mlp.LastStart+obj.T_Mlp.LastDuration/10,obj.T_Mlp.LastDuration)%从最后计算的10分之一开始并行Add
            obj.AddTime(obj.T_Start,obj.T_Add.LastEnd);
        end
    end
end