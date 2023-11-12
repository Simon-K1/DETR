function RETURN=Step8_ConvQuant%函数接口调用
    RETURN.Gen_Rand_Data=@Gen_Rand_Data;
    RETURN.ConvQuant_Compute=@ConvQuant_Compute;%接收Scale，Bias和shift以及一个二维矩阵，执行量化计算
end


function [Bias,Scale,Shift] = Gen_Rand_Data(MatrixRow,MatrixCol)%生成随机数据
%generate rand data
Bias=zeros(1,MatrixCol);%32bit  [1bit符号位][7bit 移位值][24bit实际值]
Scale=zeros(1,MatrixCol);
Shift=zeros(1,MatrixCol);

fid=fopen("Scale_Bias_Shift.txt","w");

%创建随机的Scale
for i=1:MatrixCol
    Scale_bin=Fixed_Length_Bin(randi([1,2^24-1],1),32);
    Scale(i)=bin2dec(Scale_bin);
end
%创建随机的Bias
for i=1:1:MatrixCol
    Bias_24=reshape(dec2bin(randi([0,1],[1,24])),1,[]);%低24位
    Bias_Dec=dec2bin(randi([0,16],[1]));%一个随机的移位值
    Bias_7=[reshape(dec2bin(zeros(1,7-size(Bias_Dec,2))),1,[]) Bias_Dec];%创建7bit数据，不够7bit就补零
    assert(bin2dec(Bias_Dec)<17)
    Bias_1=reshape(dec2bin(randi([0,1],[1,1])),1,[]);%符号位
    Bias(i)=bin2dec([Bias_1 Bias_7 Bias_24]);
    
end

%创建随机shift
for i=1:1:MatrixCol
    Shift(i)=bin2dec(Fixed_Length_Bin(randi([0,4],1),32));
    
end
%生成txt文件
for i=1:2:MatrixCol
    fprintf(fid,"%08s%08s\n",dec2hex(Bias(i+1)),dec2hex(Bias(i)));
end
for i=1:2:MatrixCol
    fprintf(fid,"%08s%08s\n",dec2hex(Scale(i+1)),dec2hex(Scale(i)));
end
for i=1:2:MatrixCol
    fprintf(fid,"%08s%08s\n",dec2hex(Shift(i+1)),dec2hex(Shift(i)));
end
fclose all;
end

%% 模拟卷积量化计算
function Quat_Out=ConvQuant_Compute(Scale,Bias,Shift,Matrix,ZeroPoint)
    
    Sz_Matrix=size(Matrix);
    assert(Sz_Matrix(1)==1);%输入一个向量
    
    AddZero=zeros(Sz_Matrix);
%第一步：先加Bias
    %对Bias进行处理
    Bias_Bin_All=dec2bin(Bias);

    
    Bias_Result=zeros(3,Sz_Matrix(2));
    Bias_Result(1,:)=Matrix(1,:)*2^16;
    Scale_Result=zeros(3,Sz_Matrix(2));
    DataShift_Result=zeros(3,Sz_Matrix(2));
    for i=1:Sz_Matrix(2)%遍历所有列
        %先加Bias-----------------------------------------------------------
        Bias_Bin=Bias_Bin_All(i,:);
        Bias_Shift=bin2dec(BinSlice(Bias_Bin,[30,24]));%Bias的移位值
        Bias_Shift;
        Bias_Tmp=[repmat(Bias_Bin(1),[1,8+Bias_Shift]),BinSlice(Bias_Bin,[23,0]),repmat('0',[1,16-Bias_Shift])];        
        BiasAdd=bin2dec(Bias_Tmp)+Matrix(i)*2^16;%需要注意这里的计算都是补码计算,所以出来的可能是49bit，所以还是得截后48bit
        BiasAdd=Complt2Sourcd(Fixed_Length_Bin(BiasAdd,48));%截取后48位取补码
            %需要注意的是，BiasAdd是有符号数并且是补码，所以在做有符号乘法之前需要处理一下补码的有符号计算
                %不能简单的用BiasAdd=bin2dec(Fixed_Length_Bin(BiasAdd,48))来计算。        
            %将计算数据存下来
            Bias_Result(2,i)=bin2dec(Bias_Tmp);
            Bias_Result(3,i)=BiasAdd;

        %加完Bias，再乘Scale  48bit*32bit-----------------------------------

        
        ScaleMul=Scale(i)*BiasAdd;%结果为79~48的截位
        sign=char((ScaleMul<0)+48);
        if ScaleMul<intmin('int64')
            %dec2hex无法处理int64以外的数据，只能手动转二进制
            error("dec is to big");
        end
        ScaleMul=Complt2Sourcd(BinSlice(dec2bin(ScaleMul),[79,48],sign));%补码转源码
            %同样地，将计算数据存下来
            Scale_Result(1,i)=BiasAdd;
            Scale_Result(2,i)=Scale(i);
            Scale_Result(3,i)=ScaleMul;


        %乘完Scale再shift---------------------------------------------------
        ScaleMul_Bin=dec2bin(ScaleMul);
        sign=char(49-(ScaleMul>=0));%这里就是判断有没有符号，是不是负数
        Shift(i);
            %又叒出bug了，需要注意4bit无法表示-8，因为1000可以是8也可以是-8.。。麻了
        DataShift=[BinSlice(ScaleMul_Bin,[size(ScaleMul_Bin,2)-1,Shift(i)])];%如果shift=1，那么就去掉最后那一位即可
            %还有一个四舍五入的过程，
        if bin2dec(DataShift)~=0
            DataShift=[repmat(sign,[1,32-size(DataShift,2)]),DataShift];%这里不如直接补成32bit得了
        end
        
        DataShift=Complt2Sourcd([DataShift(1) BinSlice(DataShift,[15,1],sign)])+(DataShift(end)-48);
            DataShift_Result(1,i)=ScaleMul;
            DataShift_Result(2,i)=Shift(i);
            DataShift_Result(3,i)=DataShift;
        
        
        %最后加zeropoint
        AddZero(i)=DataShift+ZeroPoint;
        if AddZero(i)<0
            AddZero(i)=0;
        else 
            if AddZero(i)>255
                AddZero(i)=255;
            end
        end
    end
    Quat_Out={Bias_Result;Scale_Result;DataShift_Result;AddZero};

end