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
    end
end