clear
%% 读取Pytorch生成的Xq txt文件，处理掩码，最后的数据变成11（12）bit
fid=fopen('Xq_LayerNorm乘掩码19bit.txt')
TokenNums=197;
ChannelNums=768;
a=textscan(fid,'%s')%拿到每行数据--a:1,1的cell，a{1,1}:2028*1的cell，a{1,1}{1,1}直接提取，但是不能a{1,1}(1,1){1,1}
%提取cell数组---反正就是对于cell就要用{}
fclose(fid);
Data_Decimal=zeros(size(a{1,1},1),1);%a{1,1}为txt中所有的行，一行代表一个数，不再按字节拆分
for i=1:size(a{1,1})%遍历所有行的字符串
    Single_Line_Hex=a{1,1}{i,1};%i行1列，元组格式
    Data_Decimal(i,1)=hex2dec(['0x',Single_Line_Hex,'s32']);%有符号 ,s32,s16,s8作后缀
end
InputMatrix=reshape(Data_Decimal,ChannelNums,TokenNums)';%列优先排布，一次先拿384个点，排成一列，所以需要将384放前面，
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
%% 仿真计算数据检查
%第一步：计算sumX
Xq_Sum=sum(InputMatrix,2);
%第二步：检查XqC
XqC=InputMatrix*ChannelNums;
%第三步：检查Xq2C
Xq2C=InputMatrix.^2*ChannelNums;
%第四步：检查Xq2C_Sum
Xq2C_Sum=sum(Xq2C,2);
%第五步：检查XqSum_Pow
XqSum_Pow=Xq_Sum.^2;
%第六步：检查Sqrt_In
Sqrt_In=Xq2C_Sum-XqSum_Pow;
%------------------stage1到此结束，stage2开始---------------------
%第七步：检查A=XqC-Xq_Sum
A=XqC-Xq_Sum;
%第八步：检查Scale*A
Scale_Mul_A=((A').*Scale')';
%第九步：检查根号计算（浮点）
Recipro_Sqrt_Result_Hex=num2hex(single(1./sqrt(Sqrt_In)));
Recipro_Sqrt_Result_Dec=hex2dec(Recipro_Sqrt_Result_Hex);
Recipro_Sqrt_Result_Bin=dec2bin(Recipro_Sqrt_Result_Dec);
%第十步：拿到Recipro_Sqrt(B),还有Scale*A后就能算SAB：
    %先拿尾数部分和Scale_Mul_A计算
    %获取指数部分(30:23)和尾数部分(22:0)：
    bintmp=fliplr(Recipro_Sqrt_Result_Bin);
    Exp_Part=fliplr(bintmp(:,24:end));
    Exp_Part_Dec=bin2dec(Exp_Part);
    Frac_Part=fliplr(bintmp(:,1:23));
    Frac_Part_Dec=bin2dec(Frac_Part)+2^23;
    
    %拿到指数部分和尾数部分后，继续计算Scale*A*B
    ScaleA_Mul_ReSqrt_Result=Scale_Mul_A.*Frac_Part_Dec;
    %再缩放回去：
    SAB_Shifted=floor(ScaleA_Mul_ReSqrt_Result./2.^(150-Exp_Part_Dec))%这里向下取整，，，可行吗？23/5/23/16:27
%第十一步：计算SAB_Shifted+Bias
SAB_Add_Bias=((SAB_Shifted')+Bias')';
%% 查询
value=318561
for i=1:197
    if XqSum_Pow(i)==value
        i
    end
end
%% 用Pytorch生成的Xq继续生成仿真txt(单并行度直接用pytorch生成的数据，多并行度数据需要再用matlab重新处理一下)

fid_raw_W=fopen('LayernormInput_19bit.txt','w');
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