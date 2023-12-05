function [bin] = Fixed_Length_Hex(Dec,Hex_Len)
%输入一个十进制，输出一个固定长度的十六进制,不够就补零,或者补符号位
%   此处提供详细说明
Dec_Hex=reshape(dec2hex(Dec),1,[]);
if(Hex_Len>=size(Dec_Hex,2))
    if Dec>0
        bin=[repmat('0',1,Hex_Len-size(Dec_Hex,2)) Dec_Hex];
    else
        bin=[repmat('F',1,Hex_Len-size(Dec_Hex,2)) Dec_Hex];
    end
else
    bin=fliplr(Dec_Hex);
    bin=fliplr(bin(1:Hex_Len));
end
end