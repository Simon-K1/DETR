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
%% 第二步：生成对应的指令(用于仿真)
clear
    %开关-------------------------------------------
Matrix2Img=1;%将矩阵转化为通道优先的3D图片
ConvTest=1;%如果测试卷积，则生成卷积指令，否则生成MM指令
    %-----------------------------------------------
load("matlab.mat")
io_Stride=Stride;
io_KernelSize=KernelSize;
io_Window_Size=KernelSize*Feature_Channel/(Height);
if io_Window_Size<1
    io_Window_Size=0;%这里考虑的情况是：存在计算输出通道大于网络输出通道的可能
                        %比如8*8*8的脉动阵列，一下能算64个输出通道
else
    io_Window_Size=ceil(io_Window_Size);
end
io_InFeature_Size=Feature_Size;
io_InFeature_Channel=Feature_Channel;
io_OutFeature_Channel=Out_Channel;
io_OutFeature_Size=OutFeatureSize;
io_OutCol_Count_Times=OutFeatureSize/(Height);%输出列计数器：比如输出8*8*8阵列，可以同时处理8个输出点的64通道
if io_OutCol_Count_Times<1
    io_OutCol_Count_Times=0;
else
    io_OutCol_Count_Times=ceil(io_OutCol_Count_Times);
end
io_InCol_Count_Times=Feature_Channel*Feature_Size/Height;%目前还是要求输入通道必须是8的倍数
io_OutFeature_Channel_Count_Times=ceil(Out_Channel/(Slice*Width));
io_Sliding_Size=Feature_Channel*Stride/Height;
io_OutRow_Count_Times=OutFeatureSize;
%% io输入参数
fprintf(".Stride                        (%d),\n",io_Stride                        )
fprintf(".Kernel_Size                   (%d),\n",io_KernelSize                    )
fprintf(".Window_Size                   (%d),\n",io_Window_Size                   )
fprintf(".InFeature_Size                (%d),\n",io_InFeature_Size                )
fprintf(".InFeature_Channel             (%d),\n",io_InFeature_Channel             )
fprintf(".OutFeature_Channel            (%d),\n",io_OutFeature_Channel            )
fprintf(".OutFeature_Size               (%d),\n",io_OutFeature_Size               )
fprintf(".Sliding_Size                  (%d),\n",io_Sliding_Size)
fprintf(".OutCol_Count_Times            (%d),\n",io_OutCol_Count_Times            )
fprintf(".InCol_Count_Times             (%d),\n",io_InCol_Count_Times             )
fprintf(".OutRow_Count_Times            (%d),\n",io_OutRow_Count_Times            )
fprintf(".OutFeature_Channel_Count_Times(%d),\n",ceil(io_OutFeature_Channel_Count_Times))
fprintf("===================================================\n")

%% 权重对应指令,全部统一用矩阵表示
[Row,Col]=size(WeightMatrix);
io_WeightMatrix_Row=Row;
io_WeightMatrix_Col=Col;
io_OutMatrix_Row=Out_Row*Out_Col;
io_OutMatrix_Col=Out_Col;
fprintf(".WeightMatrix_Row                 (%d),\n",io_WeightMatrix_Row)
fprintf(".OutMatrix_Col                    (%d),\n",io_WeightMatrix_Col)
fprintf(".OutMatrix_Row                    (%d),\n",io_OutMatrix_Row)
fprintf("===================================================\n")

%% 生成上板测试数据+指令
%Instru1:两个5bit拼起来


if ConvTest
Stride_Bin=sprintf("%05s",dec2bin(io_Stride));
KernelSize_Bin=sprintf("%05s",dec2bin(io_KernelSize));
fprintf("Write_Lite(REG_Table_BASE_ADDR,0x8,0x%s);\n",dec2hex(bin2dec([KernelSize_Bin+Stride_Bin])))

%Instru2：两个16bit拼起来
fprintf("Write_Lite(REG_Table_BASE_ADDR,0xc,0x%s%04s);\n",dec2hex(io_InFeature_Size),dec2hex(io_Window_Size))

%Instru3：两个16bit拼起来
fprintf("Write_Lite(REG_Table_BASE_ADDR,0x10,0x%s%04s);\n",dec2hex(io_OutFeature_Channel),dec2hex(io_InFeature_Channel))

%Instru4：16+13bit
Sliding_Size=sprintf("%013s",dec2bin(io_Sliding_Size));
OutFeature_Size=sprintf("%016s",dec2bin(io_OutFeature_Size));
IMG2COL_INSTRU4=dec2hex(bin2dec([Sliding_Size+OutFeature_Size]));
fprintf("Write_Lite(REG_Table_BASE_ADDR,0x14,0x%s);\n",IMG2COL_INSTRU4)

%Instru5：两个16bit拼起来
fprintf("Write_Lite(REG_Table_BASE_ADDR,0x18,0x%s%04s);\n",dec2hex(io_InCol_Count_Times),dec2hex(io_OutCol_Count_Times))

%Instru6：两个16bit拼起来
fprintf("Write_Lite(REG_Table_BASE_ADDR,0x1c,0x%s%04s);\n",dec2hex(io_OutFeature_Channel_Count_Times),dec2hex(io_OutRow_Count_Times	))

%Instru7：1个16bit
fprintf("Write_Lite(REG_Table_BASE_ADDR,0x20,0x%s);\n",dec2hex(io_WeightMatrix_Row))

%Instru8:20+12
ReceivePicture_Len=Out_Col*Out_Row*Out_Channel;
if Matrix2Img
    OutMatrix_Row=sprintf("%020s",dec2bin(io_OutMatrix_Row));%图片行数
    OutMatrix_Col=sprintf("%012s",dec2bin(io_OutMatrix_Col));%图片列数
    IMG2COL_INSTRU8=dec2hex(bin2dec([OutMatrix_Row+OutMatrix_Col]));
    fprintf("Write_Lite(REG_Table_BASE_ADDR,0x24,0x%s);\n",IMG2COL_INSTRU8)
else
    error("已失效");
    OutMatrix_Col=sprintf("%012s",dec2bin(Out_Channel));%图片列数
    %行数是8的倍数,假如输出图片大小为14*14，那么收回去的数据的行数应该是ceil(14*14/8)*8
    OutMatrix_Row=sprintf("%012s",dec2bin(ceil(Out_Row*Out_Col/8)));%图片行
    IMG2COL_INSTRU8=dec2hex(bin2dec([OutMatrix_Row+OutMatrix_Col]));
    fprintf("Write_Lite(REG_Table_BASE_ADDR,0x24,0x%s);\n",IMG2COL_INSTRU8)
    ReceivePicture_Len=Out_Channel*ceil(Out_Row*Out_Col/8)*8;
end
else
    ["在Step7中实现矩阵测试"]
end
%发送接收长度
SendPicture_Len=size(Feature_In,1)*size(Feature_In,2);%单位：字节
SendWeight_Len=size(WeightMatrix,1)*size(WeightMatrix,2);
SendQuantFactor_Len=Out_Channel*3*4;%Scale，Shift，Zp，每个参数4字节，每个通道都有一个Factor
% ReceivePicture_Len=Out_Col*Out_Row*Out_Channel;
[SendPicture_Len,SendWeight_Len,SendPicture_Len+SendWeight_Len,ReceivePicture_Len];
fprintf("SendLength=%d;\n",SendPicture_Len+SendWeight_Len+SendQuantFactor_Len)
fprintf("ReceiveLength=%d;\n",ReceivePicture_Len)