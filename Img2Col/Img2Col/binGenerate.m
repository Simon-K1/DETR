%% 第二层Window_Col_Cnt for循环
clear
clc
load('保存的matlab数据\第一版随机输入数据.mat','Frature_In');
fid = fopen('binFiles/InFeature.bin');% 更改 TriLib0.dat 为星库数据774320个星库，每个星库6个参数，每个参数2字节


fwrite(fid_write,Frature_In,'uint64')