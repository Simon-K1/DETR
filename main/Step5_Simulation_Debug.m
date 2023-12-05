%% 用于上板测试失败，需要仿真或者上板前需要仿真
%% 将上板的bin文件转换为txt仿真文件
if 1
    PreFix="OnBoardTest";

    fid=fopen(PreFix+".bin","r");
    data=fread(fid);
    fclose(fid);
    data=reshape(data,8,[]);
    fid=fopen(PreFix+".txt",'w');
    for i=1:size(data,2)
        fprintf(fid,"%02x%02x%02x%02x%02x%02x%02x%02x\n",fliplr(data(:,i)'));
    end
    fclose(fid);


    %Switch控制
    [size(WeightMatrix,1)*size(WeightMatrix,2)/8%卷积权重的txt行数
        Out_Channel*3*4/8%卷积量化参数的txt行数
        ]
end
%% 创建全仿COE文件
if 0
    command = 'bin2coe -i Weight_Picture.bin -w 64 -o Weight_Picture.coe';
    [status,cmdout] = system(command)
end