function [ShiftNum] = ConvQuant(Weight,Scale,ZeroPoint)
%输入权重，Scale，ZeroPoint
    % ConvQuant(rand(10,10),rand_range([0.00001,0.0001],[1,10]),rand_range([0.00001,0.0001],[1,10]))
    assert(size(size(Weight),2)==2,"输入权重需要按通道展开成二维矩阵");

Channel_Num=size(Weight,2);%获取输出通道数
%% 第一步：获取将Scale缩放到0.5~1之间ShiftNum
    Scale_RightShifted=zeros(1,Channel_Num);
    ShiftNum=zeros(1,Channel_Num);%移位数
    for i=1:Channel_Num%遍历所有通道
        while ~(Scale(i)>=0.5&&Scale(i)<1)
            Scale_RightShifted(i)=Scale(i)*2;
            ShiftNum(i)=ShiftNum(i)+1;%
        end
        Scale_RightShifted(i)=floor(Scale(i)*2^32);%继续放大32倍并取整，保留更多的精度
        %这里直接截余取整，不再四舍五入
    end
%% 第二步：
end


