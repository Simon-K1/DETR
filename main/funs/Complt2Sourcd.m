function [bin_sourcecode] = Complt2Sourcd(bin)
%complement2 Source code
%UNTITLED3 输入一个补码格式的二进制数，返回其十进制
%   此处提供详细说明
assert(class(bin)=="char");
bin=bin-48;
sign=bin(1);
bin=fliplr(bin(2:end));
if(sign)
    bin_sourcecode=0;%char(~bin(2:end)+48);%源码无符号位，除符号位取反+1
    for i=1:size(bin,2)
        bin_sourcecode=bin_sourcecode+2^(i-1)*(~bin(i));
    end
    bin_sourcecode=(-1)^(sign)*(bin_sourcecode+1);
else
    bin_sourcecode=0;%char(~bin(2:end)+48);%源码无符号位，除符号位取反+1
    for i=1:size(bin,2)
        bin_sourcecode=bin_sourcecode+2^(i-1)*bin(i);
    end
end
end