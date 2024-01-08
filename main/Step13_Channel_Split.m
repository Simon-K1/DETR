%% VGG有一个入256出512的卷积，很明显存不下，所以需要对通道进行拆分然后再Add
InChannel=256;
OutChannel=512;
Kernelsize=3;
MatrixB=rand([InChannel*Kernelsize,OutChannel])
Method=Split_Method(MatrixB,1024,4,8,64)
Method.Section

%% 局部函数
%一种很直接的策略，给定资源量，决定需要拆分的次数
function [Method]=Split_Method(MatrixB,Bram_Depth,Slice,Height,Width)
%Bram_Depth:Bram的深度，位宽按8来算，深度1，只能存1个点
%这里的MatrixB_Size为权重矩阵的大小，移位现在使用脉动阵列在计算，所以都用矩阵来描述
assert(numel(size(MatrixB))==2,"矩阵B必须是一个二维矩阵");
[Row,Col]=size(MatrixB);
Supported_Max_Col=Slice*Width*floor(Bram_Depth/Row);%对于当前矩阵来说，计算时可缓存的最大列数
%策略一：按列进行拆分
    %只要能存够一列，那么就可以按列进行拆分，否则执行策略二，按行进行拆分
    if Row<=Bram_Depth
        Method.Str="按列拆分"
        Split_Times=ceil(Col/Supported_Max_Col);
        Section=[];
        for i=1:Split_Times%从哪开始从哪结束
            Start=(i-1)*(Supported_Max_Col)+1;
            if i*(Slice*Width)>=Col
                End=Col;
            else
                End=i*(Supported_Max_Col);
            end
            Section=[Section;[Start,End]];
        end
        Method.Section=Section;
    end
end