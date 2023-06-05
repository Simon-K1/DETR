clear
dec2bin(hex2dec("0e910de0"))
dec2bin(9550736)
Bias_In=sprintf("%032s",dec2bin(hex2dec("0e910de0")))
% 0001110
BiasIn_Flip=fliplr(Bias_In{1})
Bias_Shift=bin2dec(fliplr(BiasIn_Flip(25:31)))
Bias_Data=bin2dec(fliplr(BiasIn_Flip(1:24)))