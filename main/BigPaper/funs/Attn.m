classdef Attn<GantTime
    %注意力机制
    %   此处提供详细说明

    properties
        T_A=GantTime(1);
        T_B=GantTime(2);
        T_C=GantTime(3);
        T_Softmax=GantTime(4)
        T_Concat=GantTime(5)

        C_Size
        Slice
        Height
        Width
        Freq
        DMA_WDITH
        HeadNums

        T_Start=0%起始时间
    end

    methods
        function obj = Attn(Id,C_Size,HeadNums,Slice,Height,Width,Freq,DMA_WDITH,varargin)

            obj = obj@GantTime(Id);%这个构造函数必须放最前面
            obj.C_Size=C_Size
            obj.Slice=Slice
            obj.Height=Height
            obj.Width=Width
            obj.Freq=Freq
            obj.DMA_WDITH=DMA_WDITH
            obj.HeadNums=HeadNums
            obj.LayerAttn
            for i = 1:numel(varargin)
                arg = varargin{i};
                if i==1
                    obj.T_Start=arg;
                end
            end
        end

       function PlotGant(obj)
            startT=[obj.T_A.startT,obj.T_B.startT,obj.T_C.startT,obj.T_Concat.startT,obj.T_Softmax.startT]
            durationT=[obj.T_A.durationT,obj.T_B.durationT,obj.T_C.durationT,obj.T_Concat.durationT,obj.T_Softmax.durationT]
            jobId=[obj.T_A.jobId,obj.T_B.jobId,obj.T_C.jobId,obj.T_Concat.jobId,obj.T_Softmax.jobId]
            figure
            GTC=ganttChart(startT,durationT,jobId);
            figure
             GTC=ganttChart(obj.startT,obj.durationT,obj.jobId); 
       end
    end

    methods (Access = private)
        function [] = LayerAttn(obj)
            CLK_CYCLE=((1/(obj.Freq*10^6))*10^9)/10^6;
            for j=1:3
                for i=1:obj.HeadNums
                    if i==1&&j==1
                        [Linear1_Cache,Linear1_Compute,Linear1_MACs]=GemmTime(obj.C_Size,[obj.C_Size(2),obj.C_Size(2)/obj.HeadNums],[obj.Slice,obj.Height,obj.Width],obj.Freq,obj.DMA_WDITH);
                        obj.T_B.AddTime(obj.T_Start,Linear1_Cache);
                        obj.T_A.AddTime(obj.T_Start,Linear1_Compute)
                        obj.T_C.AddTime(obj.T_A.LastStart+0.01,Linear1_Compute);
                    else
                        [Linear1_Cache,Linear1_Compute,Linear1_MACs]=GemmTime(obj.C_Size,[obj.C_Size(2),obj.C_Size(2)/obj.HeadNums],[obj.Slice,obj.Height,obj.Width],obj.Freq,obj.DMA_WDITH);
                        obj.T_B.AddTime(obj.T_C.LastEnd,Linear1_Cache);
                        obj.T_A.AddTime(obj.T_C.LastEnd,Linear1_Compute)
                        obj.T_C.AddTime(obj.T_A.LastStart+0.01,Linear1_Compute);
                    end
                end
            end
            %Softmax(Q*K)
            for i=1:obj.HeadNums
                if i==1
                    [QK_Cache,QK_Compute,QK_MACs]=GemmTime([obj.C_Size(1),obj.C_Size(2)/obj.HeadNums],[obj.C_Size(2)/obj.HeadNums,obj.C_Size(1)],[obj.Slice,obj.Height,obj.Width],obj.Freq,obj.DMA_WDITH);
                    obj.T_A.AddTime(obj.T_C.LastEnd+0.01,QK_Compute)
                    obj.T_B.AddTime(obj.T_C.LastEnd+0.01,QK_Cache)
                    obj.T_C.AddTime(obj.T_A.LastStart+0.005,QK_Compute)
                    obj.T_Softmax.AddTime(obj.T_C.LastEnd,obj.LayerSoftmax(obj.C_Size,200))
                else
                    [QK_Cache,QK_Compute,QK_MACs]=GemmTime([obj.C_Size(1),obj.C_Size(2)/obj.HeadNums],[obj.C_Size(2)/obj.HeadNums,obj.C_Size(1)],[obj.Slice,obj.Height,obj.Width],obj.Freq,obj.DMA_WDITH);
                    obj.T_A.AddTime(obj.T_Softmax.LastEnd+0.01,QK_Compute)
                    obj.T_B.AddTime(obj.T_Softmax.LastEnd+0.01,QK_Cache)
                    obj.T_C.AddTime(obj.T_A.LastStart+0.005,QK_Compute)
                    obj.T_Softmax.AddTime(obj.T_C.LastEnd,obj.LayerSoftmax(obj.C_Size,200))
                end
            end
            for i=1:obj.HeadNums
                [QKV_Cache,QKV_Compute,QKV_MACs]=GemmTime([obj.C_Size(2)/obj.HeadNums,obj.C_Size(1)],[obj.C_Size(1),obj.C_Size(1)],[obj.Slice,obj.Height,obj.Width],obj.Freq,obj.DMA_WDITH);
                if i==1
                    obj.T_A.AddTime(obj.T_Softmax.LastEnd,QKV_Compute)
                    obj.T_B.AddTime(obj.T_Softmax.LastEnd,QKV_Cache)
                    obj.T_C.AddTime(obj.T_A.LastStart+0.005,QKV_Compute)

                else
                    obj.T_A.AddTime(obj.T_C.LastEnd,QKV_Compute)
                    obj.T_B.AddTime(obj.T_C.LastEnd,QKV_Cache)
                    obj.T_C.AddTime(obj.T_A.LastStart+0.005,QKV_Compute)
                    %边乘边Concat
                    if i==2
                        obj.T_Concat.AddTime(obj.T_C.LastEnd+0.005,ConcatTime([obj.C_Size(1),obj.C_Size(2)/obj.HeadNums],[obj.C_Size(1),obj.C_Size(2)/obj.HeadNums*(i-1)],8,16,200));
                    else
                        obj.T_Concat.AddTime(obj.T_Concat.LastEnd+0.005,ConcatTime([obj.C_Size(1),obj.C_Size(2)/obj.HeadNums],[obj.C_Size(1),obj.C_Size(2)/obj.HeadNums*(i-1)],8,16,200));
                    end
                end
            end%Endfor

            obj.AddTime(obj.T_Start,obj.T_Concat.LastEnd)
        end%End LayerAttn
    end
end

% 
% 
% 
%     %Encoder开始
%     %Linear1层构建QKV
%     Encoder_Time=0;
%     Encoder_Macs=0;
%     [Linear1_Cache,Linear1_Compute,Linear1_MACs]=GemmTime(C_Size,[C_Size(2),C_Size(2)*3],[Slice,Height,Width],Freq,DMA_WDITH);
%     Linear1_Compute=Linear1_Compute+Linear1_Cache
% %     [Linear1_Cache,Linear1_Compute,Linear1_MACs]=GemmTime(C_Size,[C_Size(2),C_Size(2)/HeadNums],[Slice,Height,Width],Freq,DMA_WDITH);
% %     Linear1_Compute=(Linear1_Compute+Linear1_Cache)*3*HeadNums;
%     Linear1_Gops=Linear1_MACs/Linear1_Compute*10^3 %在后面继续除一个Slice*Width是因为只需要统计第一次循环的缓存时间就行，剩下的数据可以边算变换成
%     Encoder_Time=Encoder_Time+Linear1_Compute;
%     Encoder_Macs=Encoder_Macs+Linear1_MACs;
%     fprintf(fid,"Encoder_Linear：Mac:%.3f,Delay:%.3f,Gops:%.3f\n",Linear1_MACs,Linear1_Compute,Linear1_Gops);
% 
%     for j=1:3
%         for i=1:HeadNums
%             if i==1&&j==1
%                 [Linear1_Cache,Linear1_Compute,Linear1_MACs]=GemmTime(C_Size,[C_Size(2),C_Size(2)/HeadNums],[Slice,Height,Width],Freq,DMA_WDITH);
%                 T_B.AddTime(T_LayerNorm.LastEnd,Linear1_Cache);
%                 T_A.AddTime(T_LayerNorm.LastEnd,Linear1_Compute)
%                 T_C.AddTime(T_A.LastStart+0.01,Linear1_Compute);
%             else
%                 [Linear1_Cache,Linear1_Compute,Linear1_MACs]=GemmTime(C_Size,[C_Size(2),C_Size(2)/HeadNums],[Slice,Height,Width],Freq,DMA_WDITH);
%                 T_B.AddTime(T_C.LastEnd,Linear1_Cache);
%                 T_A.AddTime(T_C.LastEnd,Linear1_Compute)
%                 T_C.AddTime(T_A.LastStart+0.01,Linear1_Compute);
%             end
%         end
%     end
%     
%     %开始计算Q，K，V
%     %QK^T
%     [QK_Cache,QK_Compute,QK_MACs]=GemmTime([C_Size(1),C_Size(2)/HeadNums],[C_Size(2)/HeadNums,C_Size(1)],[Slice ,Height,Width],Freq,DMA_WDITH);
%     QK_Compute=QK_Compute*HeadNums%(ceil(HeadNums/Slice))
%     QK_Gops=QK_MACs*HeadNums/QK_Compute*10^3;
%     Encoder_Time=Encoder_Time+QK_Compute;
%     Encoder_Macs=Encoder_Macs+QK_MACs*HeadNums;
%     fprintf(fid,"QK^T：Mac:%.3f,Delay:%.3f,Gops:%.3f\n",QK_MACs*HeadNums,QK_Compute,QK_Gops);
%     %SoftMax
%     SoftMax_Time=(ceil(A_Size(1)/LayerNorm_Parall)+1)*(A_Size(1)+randi([10,33],1,1))*CLK_CYCLE;
%     SoftMax_Time=SoftMax_Time*1;
%     Encoder_Time=Encoder_Time+SoftMax_Time;
%     fprintf(fid,"Softmax%.3f\n",SoftMax_Time);
% 
% 
%         %Softmax(Q*K)
%         for i=1:HeadNums
%             if i==1
%                 [QK_Cache,QK_Compute,QK_MACs]=GemmTime([C_Size(1),C_Size(2)/HeadNums],[C_Size(2)/HeadNums,C_Size(1)],[Slice,Height,Width],Freq,DMA_WDITH);
%                 T_A.AddTime(T_C.LastEnd+0.01,QK_Compute)
%                 T_B.AddTime(T_C.LastEnd+0.01,QK_Cache)
%                 T_C.AddTime(T_A.LastStart+0.005,QK_Compute)
%                 T_Softmax.AddTime(T_C.LastEnd,C_Size(1)*ceil(C_Size(1)/8)*CLK_CYCLE)
%             else
%                 [QK_Cache,QK_Compute,QK_MACs]=GemmTime([C_Size(1),C_Size(2)/HeadNums],[C_Size(2)/HeadNums,C_Size(1)],[Slice,Height,Width],Freq,DMA_WDITH);
%                 T_A.AddTime(T_Softmax.LastEnd+0.01,QK_Compute)
%                 T_B.AddTime(T_Softmax.LastEnd+0.01,QK_Cache)
%                 T_C.AddTime(T_A.LastStart+0.005,QK_Compute)
%                 T_Softmax.AddTime(T_C.LastEnd,C_Size(1)*ceil(C_Size(1)/8)*CLK_CYCLE)
%             end
%         end
% 
% 
%     %QKV
%     %Softmax的结果量化到4bit，所以这里的脉动阵列的列数应该*2
%     %在计算QKV时V作为A矩阵输入，Attn作为B矩阵输入
%     [QKV_Cache,QKV_Compute,QKV_MACs]=GemmTime([C_Size(2)/HeadNums,C_Size(1)],[C_Size(1),C_Size(1)],[Slice*2,Height,Width],Freq,DMA_WDITH);%2024.2.22修改Slice*2，不应该增加列数的，不然性能还弱了
%     %下面这一条是预估不转置计算时的情况，结果显示计算资源被严重浪费并并且计算效率减少到了之前的1/6
%     %[QKV_Cache,QKV_Compute,QKV_MACs]=GemmTime([C_Size(1),C_Size(1)],[C_Size(1),C_Size(2)/HeadNums],[Slice,Height,Width*2],Freq,DMA_WDITH);
%     
%     QKV_Compute=QKV_Compute*HeadNums;
%     QKV_Gops=QKV_MACs*HeadNums/QKV_Compute*10^3;
%     Encoder_Time=Encoder_Time+QKV_Compute;
%     Encoder_Macs=Encoder_Macs+QKV_MACs*HeadNums;
%     fprintf(fid,"QKV：Mac:%.3f,Delay:%.3f,Gops:%.3f\n",QKV_MACs*HeadNums,QKV_Compute,QKV_Gops);
% 
%     %ShortCut Add
%     Add=ceil(C_Size(1)/Add_Parall)*(C_Size(2)+randi([10],1))*CLK_CYCLE
%     Encoder_Time=Encoder_Time+Add;
%     fprintf(fid,"shortcutAdd：Delay:%.3f\n",Add);
%     for i=1:HeadNums
%         [QKV_Cache,QKV_Compute,QKV_MACs]=GemmTime([C_Size(2)/HeadNums,C_Size(1)],[C_Size(1),C_Size(1)],[Slice,Height,Width],Freq,DMA_WDITH);
%         if i==1
%             T_A.AddTime(T_Softmax.LastEnd,QKV_Compute)
%             T_B.AddTime(T_Softmax.LastEnd,QKV_Cache)
%             T_C.AddTime(T_A.LastStart+0.005,QKV_Compute)
%             
%         else
%             T_A.AddTime(T_C.LastEnd,QKV_Compute)
%             T_B.AddTime(T_C.LastEnd,QKV_Cache)
%             T_C.AddTime(T_A.LastStart+0.005,QKV_Compute)
%             %边乘边Concat
%             if i==2
%                 T_Concat.AddTime(T_C.LastEnd+0.005,ConcatTime([C_Size(1),C_Size(2)/HeadNums],[C_Size(1),C_Size(2)/HeadNums*(i-1)],8,16,200));
%             else
%                 T_Concat.AddTime(T_Concat.LastEnd+0.005,ConcatTime([C_Size(1),C_Size(2)/HeadNums],[C_Size(1),C_Size(2)/HeadNums*(i-1)],8,16,200));
%             end
%         end
%     end
%     T_Add.AddTime(T_Concat.LastEnd,AddTime([C_Size(1),C_Size(2)],8,200))