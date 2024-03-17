classdef GantTime < handle
    properties
        Id=[]
        jobId
        jobName=""
        startT
        durationT
    end
    methods
        function obj = GantTime(Id)
            obj.Id = Id;
            obj.jobId=[];
            obj.startT = [];
            obj.durationT = [];
%             obj.JobName=JobName;
        end
        function AddTime(obj, startT, durationT)
            if isempty(obj.startT)||startT>obj.startT(end)
                obj.startT = [obj.startT, startT];
                obj.durationT = [obj.durationT, durationT];
                size(obj.startT)
                obj.jobId=ones(1,size(obj.startT,2))*obj.Id;
            end
        end
        function print(obj)
            [obj.startT;obj.durationT]
        end
        function [Last]=LastStart(obj)
            Last=obj.startT(end);
        end
        function [Last]=LastDuration(obj)
            Last=obj.durationT(end);
        end
        function [Last]=LastEnd(obj)
            Last=LastStart(obj)+LastDuration(obj);
        end
        function [Time_All]=LayerAdd(obj,Data_Size,InPara,Freq)
            %UNTITLED7 此处提供此函数的摘要
            %Data1,Data2--两个要拼接的矩阵的大小，InPara/OutPara：输入/输出并行度，一下能得到多少个点
            CLK_CYCLE=((1/(Freq*10^6))*10^9)/10^6;
            CLK_Nums=ceil(Data_Size(2)/InPara)*Data_Size(1)%边进边计算即可
            Time_All=CLK_Nums*CLK_CYCLE;
        end
        function [Time_All]=LayerSoftmax(obj,MatrixSize,Freq)
            CLK_CYCLE=((1/(Freq*10^6))*10^9)/10^6;
            Time_All=(MatrixSize(1)+3)*ceil(MatrixSize(1)/8)*CLK_CYCLE;
            
        end
    end
end