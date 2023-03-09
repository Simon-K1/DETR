% Test=[195    65    73]
% reshape(dec2hex(fliplr(Test))',1,[])
% %% 生成所有计算参数
% clear
% Feature_Size=224;
% Feature_Channel=32;
% KernelSize=16;
% Stride=16;
% Compute_OutChannel=8;
% Compute_OutCol=8;
% Out_Channel=32;
% OutFeatureSize=14;
%% 第二步：生成对应的指令
clear
load("matlab.mat")
io_Stride=Stride
io_KernelSize=KernelSize
io_Window_Size=KernelSize*Feature_Channel/Compute_OutChannel
io_InFeature_Size=Feature_Size
io_InFeature_Channel=Feature_Channel
io_OutFeature_Channel=Out_Channel
io_OutFeature_Size=OutFeatureSize
io_OutCol_Count_Times=ceil(OutFeatureSize/Compute_OutChannel)
io_InCol_Count_Times=Feature_Channel*Feature_Size/Compute_OutChannel
io_OutFeature_Channel_Count_Times=Out_Channel/Compute_OutCol
io_Sliding_Size=Feature_Channel*Stride/Compute_OutChannel
io_OutRow_Count_Times=OutFeatureSize
%% io输入参数
fprintf(".Stride                        (%d),\n",io_Stride                        )
fprintf(".Kernel_Size                   (%d),\n",io_KernelSize                    )
fprintf(".Window_Size                   (%d),\n",io_Window_Size                   )
fprintf(".InFeature_Size                (%d),\n",io_InFeature_Size                )
fprintf(".InFeature_Channel             (%d),\n",io_InFeature_Channel             )
fprintf(".OutFeature_Channel            (%d),\n",io_OutFeature_Channel            )
fprintf(".OutFeature_Size               (%d),\n",io_OutFeature_Size               )
fprintf(".OutCol_Count_Times            (%d),\n",io_OutCol_Count_Times            )
fprintf(".InCol_Count_Times             (%d),\n",io_InCol_Count_Times             )
fprintf(".OutRow_Count_Times            (%d),\n",io_OutRow_Count_Times            )
fprintf(".OutFeature_Channel_Count_Times(%d),\n",io_OutFeature_Channel_Count_Times)
fprintf(".Sliding_Size                  (%d),\n",io_Sliding_Size)

