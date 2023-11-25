%% Gemm 测试，生成Gemm的测试数据
clear
if(~exist("MM_Data.mat","file"))
    MatrixA_Size=[4096,256];%修改
    MatrixB_Size=[MatrixA_Size(2),256];%修改

    if mod(MatrixB_Size(2),8)
        error('Error:B的列数必须为8的倍数\n');%目前要求卷积输出通道必须是8的倍数，但是GEMM的话还不知道需不需要8的倍数
    end

    Matrix_A=randi(50,MatrixA_Size);
    Matrix_B=randi(50,MatrixB_Size);
    Matrix_C=Matrix_A*Matrix_B;
    save("MM_Data.mat");
else
    load("MM_Data.mat");
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
load("MM_Data.mat")
A=ones(MatrixA_Size);
C=A*Matrix_B;
MatrixA_Flattened=reshape(A',1,[]);
MatrixB_Flattened=reshape(Matrix_B,1,[]);
MatrixAB=[MatrixB_Flattened,MatrixA_Flattened];
fid=fopen("MatrixAB.bin",'w');
fwrite(fid,MatrixAB,"int8");
fclose(fid);

%写入Gemm的A矩阵参数--GEMM_INSTRU，矩阵A的行，列
fprintf("Write_Lite(REG_Table_BASE_ADDR,0x28,0x%s%04s);\n",dec2hex(MatrixA_Size(1)),dec2hex(MatrixA_Size(2)))
%写入Gemm的B矩阵参数--IMG2COL_INSTRU3，矩阵B的列---OutFeature_Channel
fprintf("Write_Lite(REG_Table_BASE_ADDR,0x10,0x%s0000);\n",dec2hex(MatrixB_Size(2)))
fprintf("Write_Lite(REG_Table_BASE_ADDR,0x20,0x%s);\n",dec2hex(MatrixB_Size(1)))
%写入输出矩阵的行和列用于数据收回
MatrixC_Size=size(Matrix_C);
fprintf("Write_Lite(REG_Table_BASE_ADDR,0x24,0x%05s%03s);\n",dec2hex(MatrixC_Size(1)),dec2hex(MatrixC_Size(2)));
%量化因子
QuantSize=MatrixB_Size(2)*3*4;
ReceivePicture_Len=size(Matrix_C,1)*size(Matrix_C,2);
fprintf("SendLength=%d;\n",MatrixA_Size(1)*MatrixA_Size(2)+MatrixB_Size(1)*MatrixB_Size(2)+QuantSize);
fprintf("ReceiveLength=%d;\n",ReceivePicture_Len)

A_Size=size(Matrix_A);
B_Size=size(Matrix_B);
Weight_Txt_Row=B_Size(1)*B_Size(2)/8+B_Size(2)*3/2;
Total_Txt_Len=Weight_Txt_Row+A_Size(1)*A_Size(2)/8;

