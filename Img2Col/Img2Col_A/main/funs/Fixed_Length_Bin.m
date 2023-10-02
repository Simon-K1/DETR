function [bin] = Fixed_Length_Bin(Dec,Bin_Len)
%输入一个十进制，输出一个固定长度的二进制,不够就补零
%   此处提供详细说明
Dec_Bin=reshape(dec2bin(Dec),1,[]);
if(Bin_Len>=size(Dec_Bin,2))
    bin=[reshape(dec2bin(zeros(1,Bin_Len-size(Dec_Bin,2))),1,[]) Dec_Bin];
else
    bin=fliplr(Dec_Bin);
    bin=fliplr(bin(1:Bin_Len));
end
end