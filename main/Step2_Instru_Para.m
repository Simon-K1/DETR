%% 第二步：生成对应的指令(用于仿真)
clear
% addpath("funs\");
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
QuantInstru_zeroIn=59;%待修改
%% io输入参数
fprintf(".QuantInstru_zeroIn            (%d),\n",QuantInstru_zeroIn                         )

fprintf(".Img2Col_Stride                        (%d),\n",io_Stride                        )
fprintf(".Img2Col_Kernel_Size                   (%d),\n",io_KernelSize                    )
fprintf(".Img2Col_Window_Size                   (%d),\n",io_Window_Size                   )
fprintf(".Img2Col_InFeature_Size                (%d),\n",io_InFeature_Size                )
fprintf(".Img2Col_InFeature_Channel             (%d),\n",io_InFeature_Channel             )
fprintf(".Img2Col_OutFeature_Channel            (%d),\n",io_OutFeature_Channel            )
fprintf(".Img2Col_OutFeature_Size               (%d),\n",io_OutFeature_Size               )
fprintf(".Img2Col_Sliding_Size                  (%d),\n",io_Sliding_Size)
fprintf(".Img2Col_OutCol_Count_Times            (%d),\n",io_OutCol_Count_Times            )
fprintf(".Img2Col_InCol_Count_Times             (%d),\n",io_InCol_Count_Times             )
fprintf(".Img2Col_OutRow_Count_Times            (%d),\n",io_OutRow_Count_Times            )
fprintf(".Img2Col_OutFeature_Channel_Count_Times(%d),\n",ceil(io_OutFeature_Channel_Count_Times))
fprintf("===================================================\n")

%% 权重对应指令,全部统一用矩阵表示
[Row,Col]=size(WeightMatrix);
io_WeightMatrix_Row=Row;
io_WeightMatrix_Col=Col;
io_OutMatrix_Row=Out_Row*Out_Col;
io_OutMatrix_Col=Out_Col;
fprintf(".Img2Col_WeightMatrix_Row                 (%d),\n",io_WeightMatrix_Row)
fprintf(".Img2Col_OutMatrix_Col                    (%d),\n",io_WeightMatrix_Col)
fprintf(".Img2Col_OutMatrix_Row                    (%d),\n",io_OutMatrix_Row)
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
% ReceivePicture_Len=Out_Col*Out_Row*Out_Channel;
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

% QUANTREG1:0x2c,量化因子
fprintf("Write_Lite(REG_Table_BASE_ADDR,0x2C,0x%s);\n",dec2hex(QuantInstru_zeroIn))
%% 收发数据量计算
%单位：字节
SendPicture_Len=size(Feature_In,1)*size(Feature_In,2);
SendWeight_Len=size(WeightMatrix,1)*size(WeightMatrix,2);
SendQuantFactor_Len=Out_Channel*3*4;%Scale，Shift，Zp，每个参数4字节，每个通道都有一个Factor
ReceivePicture_Len=Out_Col*Out_Row*Out_Channel;
[SendPicture_Len,SendWeight_Len,SendPicture_Len+SendWeight_Len,ReceivePicture_Len];
fprintf("SendLength=%d;\n",SendPicture_Len+SendWeight_Len+SendQuantFactor_Len)
fprintf("ReceiveLength=%d;\n",ReceivePicture_Len)

%% 地址配置---权重-量化参数-图片(这样子编排顺序是为了仿真的时候方便)
MEM_BASE_ADDR           =0x01000000;
WEIGHT_BASE_ADDR		=(MEM_BASE_ADDR + 0x00100000);
QUANT_BASE_ADDR         =(WEIGHT_BASE_ADDR + SendWeight_Len);
PICTURE_BASE_ADDR		=(QUANT_BASE_ADDR + SendQuantFactor_Len);
CONV_RESULT_BASE_ADDR	=(MEM_BASE_ADDR + 0x10000000);
fprintf("bin文件写入地址:%d bin文件大小：%d\n",WEIGHT_BASE_ADDR,SendPicture_Len+SendWeight_Len+SendQuantFactor_Len);

%% 仿真switch时间控制
SendWeight_Len/8;
SendQuantFactor_Len/8;

%% 卷积计算：先发权重，再发量化参数，最后发送图片
%输入switch
MASK_SWITCH_WEIGHT  =0;%代表的bit位置，第0bit，第1bit。。。
MASK_SWITCH_QUANT   =1;
MASK_SWITCH_IMG2COL =2;
MASK_SWITCH_LAYERNORM=3;
MASK_SWITCH_SOFTTMAX=4;


%0x4 控制寄存器
%第一步：启动权重缓存：,配置下面这些开关：
    %配置方法：比如要算卷积，那么需要启动的模块有权重缓存模块，量化模块，Img2Col模块和DataArrange模块共4个模块
    %首先需要启动权重缓存模块，InSwitch_Weight=1,在启动完权重缓存模块的调试还需要启动DataArrange模块

    %然后向权重缓存模块发送权重数据
    %发送完权重数据后，需要将输入数据通路切换到量化模块，继续缓存量化数据
    %量化数据缓存完后，即可将输入数据通路切换到Img2Col，开始启动卷积计算即可
Start=1;
InSwitch_Weight=1;
InSwitch_Img2col=0;
InSwitch_Quant=0;
InSwitch_Layernorm=0;
InSwitch_Gemm=0;

QuantSwicth_LayerNorm=0;
QuantSwicth_Softmax=0;
QuantSwitch_DataArrange=1;

OutSwitch_LayerNorm=0;
OutSwitch_Softmax=0;
OutSwitch_DataArrange=1;

SwitchCtrl=[InSwitch_Gemm,InSwitch_Layernorm,InSwitch_Img2col,InSwitch_Quant,InSwitch_Weight];
QuantSwitch=[0,QuantSwicth_Softmax,QuantSwicth_LayerNorm,QuantSwitch_DataArrange];
OutSwitchCtrl=[0,QuantSwicth_Softmax,QuantSwicth_LayerNorm,QuantSwitch_DataArrange];
Ctrl=[OutSwitchCtrl,QuantSwitch,SwitchCtrl,0,0,Start];

fprintf("Write_Lite(REG_Table_BASE_ADDR,0x4,0x%s);\n//启动权重缓存并且启动DataArrange分路\n",dec2hex(bin2dec(char(Ctrl+48))))
Write_DMA(SendWeight_Len,string(WEIGHT_BASE_ADDR));%发送权重数据

%发完权重后继续发量化参数
Start=1;
InSwitch_Weight=0;
InSwitch_Img2col=0;
InSwitch_Quant=1;
InSwitch_Layernorm=0;

SwitchCtrl=[InSwitch_Gemm,InSwitch_Layernorm,InSwitch_Img2col,InSwitch_Quant,InSwitch_Weight];
QuantSwitch=[0,QuantSwicth_Softmax,QuantSwicth_LayerNorm,QuantSwitch_DataArrange];
OutSwitchCtrl=[0,QuantSwicth_Softmax,QuantSwicth_LayerNorm,QuantSwitch_DataArrange];
Ctrl=[OutSwitchCtrl,QuantSwitch,SwitchCtrl,0,0,Start];
fprintf("Write_Lite(REG_Table_BASE_ADDR,0x4,0x%s);//发送量化参数\n",dec2hex(bin2dec(char(Ctrl+48))))
Write_DMA(SendQuantFactor_Len,string(QUANT_BASE_ADDR));%发送量化参数

%最后发送图片数据并且接收计算结果
Start=1;
InSwitch_Weight=0;
InSwitch_Img2col=1;
InSwitch_Quant=0;
InSwitch_Layernorm=0;
SwitchCtrl=[InSwitch_Gemm,InSwitch_Layernorm,InSwitch_Img2col,InSwitch_Quant,InSwitch_Weight];
Ctrl=[OutSwitchCtrl,QuantSwitch,SwitchCtrl,0,0,Start];
fprintf("Write_Lite(REG_Table_BASE_ADDR,0x4,0x%s);//发送图片数据并接收计算结果\n",dec2hex(bin2dec(char(Ctrl+48))))
ReadWrite_DMA(string(PICTURE_BASE_ADDR),SendPicture_Len,string(CONV_RESULT_BASE_ADDR),ReceivePicture_Len);
