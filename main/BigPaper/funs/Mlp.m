classdef Mlp<GantTime
    %UNTITLED15 此处提供此类的摘要
    %   此处提供详细说明

    properties
        C_Size
        Slice
        Height
        Width
        Freq
        DMA_WDITH
        HeadNums

        T_Start=0%起始时间

        
        T_A
        T_B
        T_C
        T_Act

        
    end

    methods
        function obj = Mlp(Id,C_Size,HeadNums,Slice,Height,Width,Freq,DMA_WDITH,varargin)
            obj = obj@GantTime(Id);%这个构造函数必须放最前面
            obj.C_Size=C_Size
            obj.Slice=Slice
            obj.Height=Height
            obj.Width=Width
            obj.Freq=Freq
            obj.DMA_WDITH=DMA_WDITH
            obj.HeadNums=HeadNums
    
            obj.T_A=GantTime(1);
            obj.T_B=GantTime(2);
            obj.T_C=GantTime(3);
            obj.T_Act=GantTime(4);
            if ~isempty(varargin)
                for i = 1:numel(varargin)
                    arg = varargin{i};
                    if i==1
                        obj.T_Start=arg;
                    end
                end
            end
            obj.MlpLayer;
        end

        function PlotGant(obj)
            startT=[obj.T_A.startT,obj.T_B.startT,obj.T_C.startT,obj.T_Act.startT]
            durationT=[obj.T_A.durationT,obj.T_B.durationT,obj.T_C.durationT,obj.T_Act.durationT]
            jobId=[obj.T_A.jobId,obj.T_B.jobId,obj.T_C.jobId,obj.T_Act.jobId]
            figure
            GTC=ganttChart(startT,durationT,jobId);
            figure
            GTC=ganttChart(obj.startT,obj.durationT,obj.jobId); 
        end



        function [] = MlpLayer(obj)
            [Linear_Cache,Linear_Compute,Linear_MACs]=GemmTime([obj.C_Size(1),obj.C_Size(2)],[obj.C_Size(2),obj.C_Size(2)*4],[obj.Slice,obj.Height,obj.Width],obj.Freq,obj.DMA_WDITH)
            obj.T_A.AddTime(obj.T_Start,Linear_Compute)
            obj.T_B.AddTime(obj.T_Start,Linear_Cache)%这里就等缓存了十分之一权重后即可开始计算，
            % %最差的情况，就是缓存完了才开始计算
            obj.T_C.AddTime(obj.T_B.LastStart+Linear_Cache/10,Linear_Compute)

            %Act和计算同时开始
            obj.T_Act.AddTime(obj.T_C.LastStart+Linear_Compute/10,Linear_Compute)

            %继续计算Linear
            [Linear_Cache,Linear_Compute,Linear_MACs]=GemmTime([obj.C_Size(1),obj.C_Size(2)*4],[obj.C_Size(2)*4,obj.C_Size(2)],[obj.Slice,obj.Height,obj.Width],obj.Freq,obj.DMA_WDITH);
            obj.T_A.AddTime(obj.T_Act.LastEnd,Linear_Compute);
            obj.T_B.AddTime(obj.T_Act.LastEnd,Linear_Cache);
            obj.T_C.AddTime(obj.T_B.LastStart+Linear_Cache/10,Linear_Compute);

            obj.AddTime(obj.T_Start,obj.T_C.LastEnd-obj.T_Start);
        end
    end
end