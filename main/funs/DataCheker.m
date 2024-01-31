function [outputArg1,outputArg2] = DataCheker(data1,data2,data3,OutFeature)
%UNTITLED3 此处提供此函数的摘要
%   此处提供详细说明
    for i=1:size(OutFeature,1)
        for j=1:size(OutFeature,2)-2
            if OutFeature(i,j)==data1&&OutFeature(i,j+1)==data2&&OutFeature(i,j+2)==data3           
                [i,j]
                break
            end
        end
    end
end