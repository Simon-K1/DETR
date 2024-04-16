%% Gemm 测试，生成Gemm的测试数据
clear
FromPytorch=1;

PytorchPath="E:\Transformer\Matlab\main\Tests\SA_3D\Pytorch\2_Linear"%修改成Pytorch生成的bin文件地址
if(~exist("matlab.mat","file"))
    MatrixA_Size=[197,768];%修改
    MatrixB_Size=[MatrixA_Size(2),7];%修改
    BinFile_Channel=2304;%一般不修改，修改的时候必须和bin文件的Channel对应，主要用来仿真的

    if ~FromPytorch
        Matrix_A=randi(50,MatrixA_Size);
        Matrix_B=randi(50,MatrixB_Size);
        Matrix_C=Matrix_A*Matrix_B;
        save("matlab.mat")
    else

        fid=fopen(PytorchPath+"\MatrixB.bin")
        Matrix_B=fread(fid,MatrixB_Size,"int8")%列优先，不用转置
        fclose(fid);
    
        fid=fopen(PytorchPath+"\MatrixA.bin")
        Matrix_A=fread(fid,fliplr(MatrixA_Size),"uint8")'%行优先，需要转置
        fclose(fid);
    
        fid=fopen(PytorchPath+"\ConvQuant.bin",'r')
        Bias_Scale_Shift=fread(fid,'uint32')
        fclose(fid);
        Scale=zeros(1,BinFile_Channel);
        Shift=zeros(1,BinFile_Channel);
    
        Bias=Bias_Scale_Shift(1:BinFile_Channel);
        Scale=Bias_Scale_Shift(BinFile_Channel+1:2*BinFile_Channel);
        Shift=Bias_Scale_Shift(2*BinFile_Channel+1:3*BinFile_Channel);
        Bias=Bias(1:MatrixB_Size(2));
        Scale=Scale(1:MatrixB_Size(2));
        Shift=Shift(1:MatrixB_Size(2));
        
        Matrix_C=Matrix_A*Matrix_B;
    %     %再读图片
    %     fid=fopen(PytorchPath+"ImageIn.bin","r")
    %     Feature_In=fread(fid,fliplr(size(Feature_In)),"uint8")'%如果图片大小为[224*224*16]图片被展平成二维矩阵，前8个点代表图片第一行第一个点的前8通道，后8个点可就是第一个点的后8通道
    %     fclose(fid);

    end
    if mod(MatrixB_Size(2),8)
         warning('Error:B的列数必须为8的倍数,开始补零\n');%目前要求卷积输出通道必须是8的倍数，但是GEMM的话还不知道需不需要8的倍数
         %先计算权重矩阵和量化参数需要被补多少列0
         
        Padding_Cols=ceil(MatrixB_Size(2)/8)*8-MatrixB_Size(2);
        Matrix_B=[Matrix_B,zeros(MatrixB_Size(1),Padding_Cols)];
        Bias=[Bias',zeros(1,Padding_Cols)];
        Shift=[Shift',zeros(1,Padding_Cols)];
        Scale=[Scale',zeros(1,Padding_Cols)];
        MatrixB_Size=[MatrixB_Size(1),ceil(MatrixB_Size(2)/8)*8];
    end
    save("matlab.mat")
else
    load("matlab.mat");
end


%% 生成权重仿真txt
%权重也按通道优先展开,列优先存储
%先将权重矩阵展平
if 0
    Matrix_Flattened=reshape(Matrix_A',1,[]);%按列优先展平
    fid_raw_W=fopen('PictureData.txt','w');
    Shape=size(Matrix_Flattened);
     for i=8:8:Shape(2)
      %通道按从低往高排列，比如第一个通道的点放最低位
      fprintf(fid_raw_W,'%02x%02x%02x%02x%02x%02x%02x%02x\n',Matrix_Flattened(i),Matrix_Flattened(i-1),Matrix_Flattened(i-2),Matrix_Flattened(i-3),Matrix_Flattened(i-4),Matrix_Flattened(i-5),Matrix_Flattened(i-6),Matrix_Flattened(i-7));%低位第一个点，高位第二个点，
     end
    fclose(fid_raw_W);
end

%% 生成权重仿真txt
%权重也按通道优先展开,列优先存储
%先将权重矩阵展平
if 0
    Matrix_Flattened=reshape(Matrix_B,1,[]);%按列优先展平
    fid_raw_W=fopen('WeightData.txt','w');
    Shape=size(Matrix_Flattened);
     for i=8:8:Shape(2)
      %通道按从低往高排列，比如第一个通道的点放最低位
      fprintf(fid_raw_W,'%02x%02x%02x%02x%02x%02x%02x%02x\n',Matrix_Flattened(i),Matrix_Flattened(i-1),Matrix_Flattened(i-2),Matrix_Flattened(i-3),Matrix_Flattened(i-4),Matrix_Flattened(i-5),Matrix_Flattened(i-6),Matrix_Flattened(i-7));%低位第一个点，高位第二个点，
     end
    fclose(fid_raw_W);
end

%% 生成权重和激活矩阵的上板测试文件
clear 
load("matlab.mat")
A=ones(MatrixA_Size);
MatrixA_Flattened=reshape(Matrix_A',1,[]);
MatrixB_Flattened=reshape(Matrix_B,1,[]);
Scale_Flattened=reshape(Scale,1,[]);
Bias_Flattened=reshape(Bias,1,[]);
Shift_Flattened=reshape(Shift,1,[]);
fid=fopen("OnBoardTest.bin",'w');
fwrite(fid,MatrixB_Flattened,"int8");
fwrite(fid,Bias_Flattened,"uint32");%uint8和int8生成的bin文件还有区别，存在一种可能，2341694147用int32无法表示，因为int32还要1bit的符号位。。。
fwrite(fid,Scale_Flattened,"uint32");
fwrite(fid,Shift_Flattened,"uint32");
fwrite(fid,MatrixA_Flattened,"uint8");
fclose(fid);
%% 开始生成计算指令
fprintf("//矩阵计算指令：A[%d,%d]*B[%d,%d]\n",MatrixA_Size,MatrixB_Size);
%写入Gemm的A矩阵参数--GEMM_INSTRU，矩阵A的行，列
fprintf("Write_Lite(REG_Table_BASE_ADDR,0x28,0x%s%04s);\n",dec2hex(MatrixA_Size(1)),dec2hex(MatrixA_Size(2)))
%写入Gemm的B矩阵参数--IMG2COL_INSTRU3，矩阵B的列---OutFeature_Channel
fprintf("Write_Lite(REG_Table_BASE_ADDR,0x10,0x%s0000);\n",dec2hex(MatrixB_Size(2)))
fprintf("Write_Lite(REG_Table_BASE_ADDR,0x20,0x%s);\n",dec2hex(MatrixB_Size(1)))
%写入输出矩阵的行和列用于数据收回
MatrixC_Size=size(Matrix_C);
fprintf("Write_Lite(REG_Table_BASE_ADDR,0x24,0x%05s%03s);\n",dec2hex(MatrixC_Size(1)),dec2hex(MatrixC_Size(2)));
%ZeroPoint
fprintf("Write_Lite(REG_Table_BASE_ADDR,0x2C,0x%s);//写入ZeroPoint \n",dec2hex(116));
%% 地址配置---权重-量化参数-图片(这样子编排顺序是为了仿真的时候方便)
SendWeight_Len=MatrixB_Size(1)*MatrixB_Size(2);
SendQuantFactor_Len=MatrixB_Size(2)*3*4;
SendPicture_Len=MatrixA_Size(1)*MatrixA_Size(2);

MEM_BASE_ADDR           =0x01000000;
WEIGHT_BASE_ADDR		=(MEM_BASE_ADDR + 0x00100000);
QUANT_BASE_ADDR         =(WEIGHT_BASE_ADDR + SendWeight_Len);
PICTURE_BASE_ADDR		=(QUANT_BASE_ADDR + SendQuantFactor_Len);
CONV_RESULT_BASE_ADDR	=(MEM_BASE_ADDR + 0x10000000);

fprintf("//bin文件写入地址:%d bin文件大小：%d\n",WEIGHT_BASE_ADDR,MatrixA_Size(1)*MatrixA_Size(2)+MatrixB_Size(1)*MatrixB_Size(2)+SendQuantFactor_Len);
ReceivePicture_Len=size(Matrix_C,1)*size(Matrix_C,2);


%% 启动计算并接收结果

%先发权重
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
Ctrl=[OutSwitchCtrl,QuantSwitch,SwitchCtrl,0,0,0];
fprintf("Write_Lite(REG_Table_BASE_ADDR,0x4,0x%s);\n//解除Start\n",dec2hex(bin2dec(char(Ctrl+48))))
Write_DMA(SendWeight_Len,string(WEIGHT_BASE_ADDR));%发送权重数据

%发完权重后继续发量化参数
Start=1;
InSwitch_Weight=0;
InSwitch_Img2col=0;
InSwitch_Quant=1;
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
fprintf("Write_Lite(REG_Table_BASE_ADDR,0x4,0x%s);//发送量化参数\n",dec2hex(bin2dec(char(Ctrl+48))))
Ctrl=[OutSwitchCtrl,QuantSwitch,SwitchCtrl,0,0,0];%Strat拉低
fprintf("Write_Lite(REG_Table_BASE_ADDR,0x4,0x%s);//解除Start\n",dec2hex(bin2dec(char(Ctrl+48))))
Write_DMA(SendQuantFactor_Len,string(QUANT_BASE_ADDR));%发送量化参数

%最后发送MatrixA数据并且接收计算结果
Start=1;
InSwitch_Weight=0;
InSwitch_Img2col=0;
InSwitch_Quant=0;
InSwitch_Layernorm=0;
InSwitch_Gemm=1;

QuantSwicth_LayerNorm=0;
QuantSwicth_Softmax=0;
QuantSwitch_DataArrange=1;

OutSwitch_LayerNorm=0;
OutSwitch_Softmax=0;
OutSwitch_DataArrange=1;
SwitchCtrl=[InSwitch_Gemm,InSwitch_Layernorm,InSwitch_Img2col,InSwitch_Quant,InSwitch_Weight];
Ctrl=[OutSwitchCtrl,QuantSwitch,SwitchCtrl,0,0,Start];
fprintf("Write_Lite(REG_Table_BASE_ADDR,0x4,0x%s);//发送图片数据并接收计算结果\n",dec2hex(bin2dec(char(Ctrl+48))))
Ctrl=[OutSwitchCtrl,QuantSwitch,SwitchCtrl,0,0,0];
fprintf("Write_Lite(REG_Table_BASE_ADDR,0x4,0x%s);//解除Start\n",dec2hex(bin2dec(char(Ctrl+48))))
ReadWrite_DMA(string(PICTURE_BASE_ADDR),SendPicture_Len,string(CONV_RESULT_BASE_ADDR),ReceivePicture_Len);

%% 存储和Split测试
if 0

Method=Split_Method(Matrix_B,64*24576,1,8,8)
Method.Section

% %% 局部函数
% function [SwitchCtrl]=GetCtrl(Start,InSwitch_Weight,InSwitch_Img2col,InSwitch_Quant,InSwitch_Layernorm,InSwitch_Gemm)
%     SwitchCtrl=[InSwitch_Gemm,InSwitch_Layernorm,InSwitch_Img2col,InSwitch_Quant,InSwitch_Weight];
% end

A_Size=size(Matrix_A);
B_Size=size(Matrix_B);
Weight_Txt_Row=B_Size(1)*B_Size(2)/8+B_Size(2)*3/2;
Total_Txt_Len=Weight_Txt_Row+A_Size(1)*A_Size(2)/8;

end