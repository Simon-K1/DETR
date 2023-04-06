%% 第六步骤：结果对比
    % 读取fpga回来的数据进行逐字节对比
clear
load("../matlab.mat")
load("../matlab_Conv.mat","OutFeature_3D_UnArranged")
fid=fopen("ConvResult.bin");
ConvOutput_Fpga=fread(fid,[Out_Col*Out_Channel,Out_Row]);    
fclose(fid);
