function Output = BinSlice(bin,range,varargin)
%输入一个Bin和范围,比如bin(30,24)
    if range(1)<range(2)
        warning("range(1)<range(2)")
        Output=Fixed_Length_Bin(0,range(1)+1);
        return
    end
    if size(bin,2)<(range(1)+1)
        %bin=Fixed_Length_Bin(bin2dec(bin),range(1)+1);
        
        Dec_Bin=bin;
        Bin_Len=range(1)+1;
        if((range(1)+1)>=size(Dec_Bin,2))
            if nargin==2
                bin=[repmat('0',[1,range(1)+1-size(Dec_Bin,2)]) Dec_Bin];
            else
                sign=varargin{1};%符号位
                bin=[repmat(sign,[1,range(1)+1-size(Dec_Bin,2)]) Dec_Bin];
            end
        else
            bin=fliplr(Dec_Bin);
            bin=fliplr(bin(1:Bin_Len));
        end
    end
    Output=fliplr(bin);
    Output=fliplr(Output(:,(range(2)+1):1:(range(1)+1)));
end