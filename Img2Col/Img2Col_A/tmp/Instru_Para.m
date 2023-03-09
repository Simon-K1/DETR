% Test=[195    65    73]
% reshape(dec2hex(fliplr(Test))',1,[])
%% 生成所有计算参数
clear
Feature_Size=224;
Feature_Channel=32;
KernelSize=16;
Stride=2;
Compute_OutChannel=8;
Compute_OutCol=8;
Out_Channel=32;
OutFeatureSize=14;


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
%% io输入参数
fprintf("io.Stride                        (%d),\n",io_Stride                        )
fprintf("io.KernelSize                    (%d),\n",io_KernelSize                    )
fprintf("io.Window_Size                   (%d),\n",io_Window_Size                   )
fprintf("io.InFeature_Size                (%d),\n",io_InFeature_Size                )
fprintf("io.InFeature_Channel             (%d),\n",io_InFeature_Channel             )
fprintf("io.OutFeature_Channel            (%d),\n",io_OutFeature_Channel            )
fprintf("io.OutFeature_Size               (%d),\n",io_OutFeature_Size               )
fprintf("io.OutCol_Count_Times            (%d),\n",io_OutCol_Count_Times            )
fprintf("io.InCol_Count_Times             (%d),\n",io_InCol_Count_Times             )
fprintf("io.OutFeature_Channel_Count_Times(%d),\n",io_OutFeature_Channel_Count_Times)
fprintf("io.Sliding_Size                  (%d),\n",io_Sliding_Size)