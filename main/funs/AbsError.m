function [Error,Error_Min,Error_Max] = AbsError(Correct,x)%绝对误差的统计
    Error=abs(Correct-x);
    Correct=reshape(Correct,1,[]);%展平
    x=reshape(x,1,[]);
    
    % 第一步：检查最大误差和最小误差
    
    Fpga_Error_Max=max(Error,[],'all');
    Fpga_Error_Min=min(Error,[],'all');
    Error_Min=Fpga_Error_Min;
    Error_Max=Fpga_Error_Max;

    nums=size(Fpga_Error_Min:0.01:Fpga_Error_Max,2)
    Error_Range=Fpga_Error_Min:0.01:Fpga_Error_Max;
    Error_Range=Error_Range(2:end);
    k=1;
    for i=Fpga_Error_Min:0.01:Fpga_Error_Max
        
        nums(k)=sum(Error<i,'all');
        k=k+1;
    end
    nums=nums(2:end)

    %然后再统计每个区间内的数据有多少
    for i=size(nums,2):-1:2
        nums(i)=nums(i)-nums(i-1)
    end
    %需要将少于1%的全部加起来
    Percentage=nums/sum(nums);
    Mask=Percentage<0.01
    if sum(Mask)~=0
        Error_Range=[Error_Range((1:length(nums)-sum(Mask))),Error_Range(end)]
        nums=[nums(1:length(nums)-sum(Mask)),sum(nums.*Mask)];
    end
    %% 

    bar(nums);
    ylabel("Counts")
    xlabel("Error")
    set(gca, 'XTick', 1:length(nums), 'XTickLabel', round(Error_Range,4))
%     xtickformat('%1.3f');%将x轴的数据精度保留到一位小数即可
    for i = 1:length(nums)
%         text(i, nums(i), num2str(nums(i)), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
        text(i, nums(i), [num2str(nums(i)/sum(nums)*100, '%.1f'), '%'], 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
        
    end
end

