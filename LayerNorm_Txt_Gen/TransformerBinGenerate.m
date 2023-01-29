%% 生成txt仿真文件（创建随机32 bit输入,每个点8bit）
InputMatrix_Rand=rand(197,384)*10;%创建一个随机矩阵
InputMatrix_Fixed=zeros(197,384)
for i=1:384
    InputMatrix_Fixed(i,:)=ceil(rand(1,384)*250);
end

fid_raw_W=fopen('Generated_Files\DmaTest32bit.txt','w');
Matrix_Flattened=reshape(InputMatrix_Fixed',1,[])%展平
Shape=size(Matrix_Flattened);
 for i=4:4:Shape(2)
  fprintf(fid_raw_W,'%02x%02x%02x%02x\n',Matrix_Flattened(i),Matrix_Flattened(i-1),Matrix_Flattened(i-2),Matrix_Flattened(i-3));%低位第一个点，高位第二个点，
 end
fclose(fid_raw_W);

%% 创建顺序32bit输入
fid_raw_W=fopen('Generated_Files\DmaTest32bit.txt','w');
Matrix_Flattened=0:1:197*384-1;%展平
Shape=size(Matrix_Flattened);
 for i=1:1:Shape(2)
  fprintf(fid_raw_W,'%08x\n',Matrix_Flattened(i));%低位第一个点，高位第二个点，
 end
fclose(fid_raw_W);
%% 创建相同行的顺序32bit输入(一般用这个作为仿真文件)
InputMatrix_Fixed=zeros(197,384)
for i=1:384
    InputMatrix_Fixed(i,:)=0:1:383;
end
fid_raw_W=fopen('Generated_Files\DmaTest32bit.txt','w');
Matrix_Flattened=reshape(InputMatrix_Fixed',1,[])%展平
Shape=size(Matrix_Flattened);
 for i=1:1:Shape(2)
  fprintf(fid_raw_W,'%08x\n',Matrix_Flattened(i));%低位第一个点，高位第二个点，
 end
fclose(fid_raw_W);
%% 创建相同行的顺序8bit输入(一般用这个作为仿真文件)
InputMatrix_Fixed=zeros(197,384)
for i=1:384
    InputMatrix_Fixed(i,:)=0:1:383;
end
fid_raw_W=fopen('Generated_Files\Layernorm顺序8bit.txt','w');
Matrix_Flattened=reshape(InputMatrix_Fixed',1,[])%展平
Shape=size(Matrix_Flattened);
 for i=1:1:Shape(2)
  fprintf(fid_raw_W,'%02x\n',Matrix_Flattened(i));%低位第一个点，高位第二个点，
 end
fclose(fid_raw_W);
%% 创建layernorm随机197*384输入（8bit）以及生成平方和，方差等计算结果
load('InputMatrix_Rand_197_384.mat')
fid_raw_W=fopen('Generated_Files\Layernorm随机8bit.txt','w');
Matrix_Flattened=reshape(InputMatrix',1,[])%展平
Shape=size(Matrix_Flattened);
 for i=1:1:Shape(2)
  fprintf(fid_raw_W,'%02x\n',Matrix_Flattened(i));%低位第一个点，高位第二个点，
 end
fclose(fid_raw_W);
%% 创建随机8bit scale和Bias 8bit 输入
% Scale_Bias=randi([0,255],[2,384]);%第一行是Scale，第二行是Bias
fid_raw_W=fopen('Generated_Files\Scale_Bias_8bit.txt','w');
Matrix_Flattened=reshape(Scale_Bias,1,[])%Scale和Bias组合成16 bit输入
Shape=size(Matrix_Flattened);
 for i=1:2:Shape(2)
  fprintf(fid_raw_W,'%02x%02x\n',Matrix_Flattened(i),Matrix_Flattened(i+1));%低位第一个点，高位第二个点，
    %高8bit为Bias，低8bit为Scale
 end
fclose(fid_raw_W);
%% 读取pytorch生成的Scale_Bias.txt文件

fid=fopen('Scale_Bias.txt')
a=textscan(fid,'%s')%拿到每行数据--a:1,1的cell，a{1,1}:2028*1的cell，a{1,1}{1,1}直接提取，但是不能a{1,1}(1,1){1,1}
%提取cell数组---反正就是对于cell就要用{}
fclose(fid);
Single_Line_Dec=zeros(1,2);%代表2个字节
Data_Decimal=zeros(size(a{1,1},1),2);%a{1,1}为txt中所有的行
for i=1:size(a{1,1})
    Single_Line_Hex=a{1,1}{i,1};%i行1列，元组格式
    for j=1:2%第一步：先整理成左高右低的格式，按字节编码
        Single_Line_Dec(j)=hex2dec(['0x',Single_Line_Hex(2*j-1:2*j),'s8']);
    end    
    Data_Decimal(i,:)=Single_Line_Dec;
end
%数据按行优先：转置一下
Data_Decimal=Data_Decimal';
Scale=Data_Decimal(1,:);%约定高8位为Scale，低8位为Bias
Bias=Data_Decimal(2,:);
% if False%暂时不写成bin文件
%     fid=fopen('Npu_Inst.bin','w');
%     fwrite(fid,Data_Decimal,'uint16');
%     fclose(fid);
% end
%% 读取Pytorch生成的Xq txt文件
fid=fopen('Xq_LayerNorm_未处理掩码.txt')
a=textscan(fid,'%s')%拿到每行数据--a:1,1的cell，a{1,1}:2028*1的cell，a{1,1}{1,1}直接提取，但是不能a{1,1}(1,1){1,1}
%提取cell数组---反正就是对于cell就要用{}
fclose(fid);
ByteNum=1%每一行有多少个字节
Single_Line_Dec=zeros(1,ByteNum);%代表2个字节
Data_Decimal=zeros(size(a{1,1},1),ByteNum);%a{1,1}为txt中所有的行
for i=1:size(a{1,1})%遍历所有行的字符串
    Single_Line_Hex=a{1,1}{i,1};%i行1列，元组格式
    for j=1:ByteNum%一下获取8bit数据也就是在这一行中从左往右每次拿两个字符作为一字节，因为是按字节编码的
        Single_Line_Dec(j)=hex2dec(['0x',Single_Line_Hex(2*j-1:2*j),'s8']);%有符号
    end    
    Data_Decimal(i,:)=Single_Line_Dec;
end
%数据按行优先：转置一下
InputMatrix=reshape(Data_Decimal,384,197)';%列优先排布，一次先拿384个点，排成一列，所以需要将384放前面，
% if False%暂时不写成bin文件
%     fid=fopen('Npu_Inst.bin','w');
%     fwrite(fid,InputMatrix,'uint16');
%     fclose(fid);
% end
%% 读取Pytorch生成的Xq txt文件，处理掩码，最后的数据变成11（12）bit
fid=fopen('Xq_LayerNorm处理掩码16bit.txt')
a=textscan(fid,'%s')%拿到每行数据--a:1,1的cell，a{1,1}:2028*1的cell，a{1,1}{1,1}直接提取，但是不能a{1,1}(1,1){1,1}
%提取cell数组---反正就是对于cell就要用{}
fclose(fid);
Data_Decimal=zeros(size(a{1,1},1),1);%a{1,1}为txt中所有的行，一行代表一个数，不再按字节拆分
for i=1:size(a{1,1})%遍历所有行的字符串
    Single_Line_Hex=a{1,1}{i,1};%i行1列，元组格式
    Data_Decimal(i,1)=hex2dec(['0x',Single_Line_Hex,'s16']);%有符号 
end
InputMatrix=reshape(Data_Decimal,384,197)';%列优先排布，一次先拿384个点，排成一列，所以需要将384放前面，

%% 测试
%load('InputMatrix_Rand_197_384.mat')
clear
load('InputMatrix_Pytorch处理掩码.mat')
XqC=InputMatrix*384;
Xq=InputMatrix
Xq_Sum=sum(Xq,2)
Xq2C=Xq.^2*384
Xq2C_Sum=sum(Xq2C,2)
A=XqC-Xq_Sum
Sqrt_In=Xq2C_Sum-Xq_Sum.^2
Scale_A=A.*Scale
%Sqrt part========================================
Sqrt_In_Hex=dec2hex(Sqrt_In)
Sqrt_Out_Hex=num2hex(single(1./sqrt(Sqrt_In)))

Sqrt_Out_Bin=dec2bin(hex2dec(Sqrt_Out_Hex))
tmp=fliplr(Sqrt_Out_Bin)
Recipro_Exp_Part=fliplr(tmp(:,24:end))
Recipro_Frac_Part=bin2dec(fliplr(tmp(:,1:23)))+2^23
Scale_AB_64bit=Scale_A.*Recipro_Frac_Part

Sqrt_Out_Bin_Tmp=cell(197,1)
% %对SqrtOut bin补零
% for i=1:size(Sqrt_Out_Bin,1)
%     if size(Sqrt_Out_Bin(i,:),2)~=32
%         Sqrt_Out_Bin_Tmp(i,1)=([repmat(['0'],[1,32-size(Sqrt_Out_Bin(i,:),2)]),Sqrt_Out_Bin(i,:)])
%     end
% end
% Sqrt_Out_Frac_Hex=dec2hex(bin2dec([repmat(['1'],[size(Sqrt_Out_Bin,1),1]),]))
Sqrt_In_SingleHex=num2hex(single(Sqrt_In))
Recipro_std_Xq=single(1./sqrt(Sqrt_In))
Recipro_std_Xq_Round=round(Recipro_std_Xq*2^23)
%Scale*A*B

ScaleAB=floor(Scale_A.*floor(Recipro_std_Xq*2^64)/2^64)
ScaleAB_Bias=ScaleAB+Bias

% dec2bin(hex2dec('af83e8'))
% dec2bin(hex2dec('6f83e8'))

%最后一个点数据
Last_ReciproResult='00111000001110111101010100000001'
Frac_Part=Last_ReciproResult(10:end)
B_Hex=dec2hex(bin2dec(['1',Frac_Part]))
%% 多并行度数据生成
%InputMatrix
% InputMatrix=abs(InputMatrix)
fid_raw_W=fopen('Generated_Files\多并行度仿真数据_88bit.txt','w');
Shape=size(InputMatrix);
%  for i=1:1:8:Shape(1)-8%遍历行，行数小的放低位
%      for j=1:1:Shape(2)%遍历列,
%         fprintf(fid_raw_W,'%03s',dec2hex(InputMatrix(i+7,j)),InputMatrix(i+6,j),InputMatrix(i+5,j),InputMatrix(i+4,j),InputMatrix(i+3,j),InputMatrix(i+2,j),InputMatrix(i+1,j),InputMatrix(i,j));%低位第一个点，高位第二个点，
%      end
%  end
InputMatrix_Padded=[InputMatrix;zeros(8-mod(size(InputMatrix,1),8),384)]
%由于是有符号数，先转十六进制再转回无符号数
InputMatrix_Hex=dec2hex(InputMatrix_Padded)
InputMatrix_Hex2Dec=reshape(hex2dec(InputMatrix_Hex),size(InputMatrix_Padded))

for i=1:8:Shape(1)%对于每一行来说
    for j=1:Shape(2)%对于每一列来说
        for k=7:-1:0
            fprintf(fid_raw_W,'%04x',InputMatrix_Hex2Dec(i+k,j));%因为是按字节输出的
        end
        fprintf(fid_raw_W,'\n');
    end
end
fclose(fid_raw_W);

%% 模拟硬件根号分之一的定点计算
clear
A=4567
Scale=78
Recipro_sqrt=4.9170162020e-05
NumResult=round(round(Scale*A*Recipro_sqrt*2^32)/2^32)
A_Scale_Hex=[dec2hex(A*Scale)]
SqrtResult_Bin=['11',dec2bin(hex2dec(num2hex(single(Recipro_sqrt))))]
SqrtResut_Hex_Frac=['1',SqrtResult_Bin(10:end)]
A_Scale_Sqrt=dec2hex(hex2dec(A_Scale_Hex)*bin2dec(SqrtResut_Hex_Frac))