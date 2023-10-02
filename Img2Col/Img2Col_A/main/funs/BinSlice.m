function Output = BinSlice(bin,range)
%输入一个Bin和范围,比如bin(30,24)
    if size(bin,2)<(range(1)+1)
        bin=Fixed_Length_Bin(bin2dec(bin),range(1)+1);
    end
    Output=fliplr(bin);
    Output=fliplr(Output(:,(range(2)+1):1:(range(1)+1)));
end