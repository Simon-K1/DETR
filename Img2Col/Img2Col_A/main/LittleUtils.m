%% 一些实用脚本
vector=[112
133
17
99
91
175
167
103]';
reshape(dec2hex(fliplr(vector))',1,[])

%% 读取输出特征图的bin文件
clear
fid=fopen('OutPut.bin','r')
OutFeature=fread(fid,[160*64,160],'int32');
OutFeature=OutFeature';
fclose(fid)