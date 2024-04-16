%% 模拟卷积计算
clear
load("matlab.mat")
OutFeature=zeros(Out_Row,Out_Col*Out_Channel);
i=1;
j=1;
In_Row=Feature_Size_padding;
In_Col=Feature_Size_padding;
%% 硬件卷积输出（标准的图片格式），数据未量化
for row=1:Stride:In_Row-KernelSize+1%遍历行
    for col=1:Stride:In_Col-KernelSize+1%遍历列
        Window=reshape(Feature_In_padding(row:row+KernelSize-1,(col-1)*Feature_Channel+1:(col+KernelSize-1)*Feature_Channel)',1,[]);%计算一个滑窗对应的全部输出点
        OutFeature(i,j:j+Out_Channel-1)=Window*WeightMatrix;
        j=j+Out_Channel;
    end
    i=i+1;
    j=1;
end
%% ⭐⭐⭐⭐⭐⭐⭐创建ConvOutput的输入txt和脉动阵列输出对比（也就是脉动阵列的输出）⭐⭐⭐⭐⭐⭐⭐
%脉动阵列输出的完整一列数据
OutFeature_3D_UnArranged=cell(OutFeatureSize,1);%将输出特征图每一行的数据都用元胞数组存起来，这样方便以后检查，其中每一列对应一个点的所有通道，
%图片有多少列，每个元胞包含的数组就是多少列，行数则代表每个点的通道数
OutFeature_3D_Arranged=cell(OutFeatureSize,1);
OutFeature_3D_Quan=cell(OutFeatureSize,1);
for Row=1:size(OutFeature,1)%遍历行
    RowData_2D=reshape(OutFeature(Row,:),Out_Channel,OutFeatureSize);%获取一行的数据，转化为2D格式,一共有OutFeatureSize列,没有重新排列
    OutFeature_3D_UnArranged(Row)={RowData_2D};
    Temp_Block=[];
    SA_OutPut_Row=[];
    for ColTimes=1:ceil(OutFeatureSize/8)%每8列为一组
        if(ColTimes==ceil(OutFeatureSize/8))%比如输出图片大小为14，脉动阵列一下输出图片的8列，所以需要2次才能输出图片的完整一行
            Temp_Block=RowData_2D(:,(ColTimes-1)*8+1:end);%这个if是为了处理输出图片的size不是8的倍数的情况，这里补零是因为可能拿不到8列数据，为了和前面的8列进行拼接就需要补零
            zeros_padding=zeros(size(Temp_Block,1),8-size(Temp_Block,2));%注意这里补零只是将图片的列size补零成8的倍数，而没有进行通道的补零，这与硬件实现需要区分开，硬件实现则是对通道进行了补零
            Temp_Block=[Temp_Block,zeros_padding];%TODO：以后还要在这里补充和硬件对应的通道补零
            SA_OutPut_Row=[SA_OutPut_Row;Temp_Block];%这里进行数组拼接
        else
            Temp_Block=RowData_2D(:,(ColTimes-1)*8+1:ColTimes*8);
            SA_OutPut_Row=[SA_OutPut_Row;Temp_Block];
        end
    end
    OutFeature_3D_Arranged(Row)={SA_OutPut_Row'};
end


%生成输出对比文件
    %第一步：将矩阵展平，得到连续的数据，模拟连续的数据流
%     for i=1:size(OutFeature_3D_Quan,1)%遍历行
%         OutFeature_3D_Quan_Flatten=reshape(OutFeature_3D_Quan{i},1,[]);
%         for j=1:8:
%     end
%  reshape(dec2hex(fliplr(reshape([137;153;29;229;187;239;49;59],1,[])))',1,[])
%创建脉动阵列输出的随机仿真数据
if 0
    ConvOutput=randi([0,255],ceil(OutFeatureSize/8)*OutFeatureSize*8*32,8);
    fid=fopen("阵列输出仿真数据.txt","w");
    for i=1:size(ConvOutput,1)
        fprintf(fid,"%02x%02x%02x%02x%02x%02x%02x%02x\n",ConvOutput(i,8),ConvOutput(i,7),ConvOutput(i,6),ConvOutput(i,5),ConvOutput(i,4),ConvOutput(i,3),ConvOutput(i,2),ConvOutput(i,1));
    end
end
% a=fliplr(dec2hex([1000,300]))
% a=fliplr(a(1:2,1:2))
% fprintf("%02s\n%02s\n",a(1,:),a(2,:))
%% 构建随机矩阵，一下选1列的8行数据进行输出(For 卢浩）
if 0
    Matrix_B=zeros(163,40);
    Row=size(Matrix_B,1);
    Col=size(Matrix_B,2);
    Matrix_B=randi([0,255],Row,Col)
    Matrix_B=[Matrix_B;zeros(5,40)];
    fid_raw_W=fopen('MatrixData.txt','w');
    for i=1:8:size(Matrix_B,1)
        for j=1:size(Matrix_B,2)

            Matrix_Flattened=Matrix_B(i:i+7,j);%fliplr(');
            fprintf(fid_raw_W,'%02x%02x%02x%02x%02x%02x%02x%02x\n',Matrix_Flattened(8),Matrix_Flattened(7),Matrix_Flattened(6),Matrix_Flattened(5),Matrix_Flattened(4),Matrix_Flattened(3),Matrix_Flattened(2),Matrix_Flattened(1));%低位第一个点，高位第二个点，
        end
    end
    fclose(fid_raw_W);
    dec2hex(Matrix_B(1:8,1));
end
%% 检查中间数据
%需要输入连续的三个数据，输出这三个数据对应的行列
if 0
    data1=28519;
    data2=27458;
    data3=29533;
    for i=1:size(OutFeature,1)
        for j=1:size(OutFeature,2)-2
            if OutFeature(i,j)==data1&&OutFeature(i,j+1)==data2&&OutFeature(i,j+2)==data3
                [i,j]
                break
            end
        end
    end
end
%% 全仿输出数据对比
if 0
    Check_Row=14;
    Check_All=1;
    fid_raw_W=fopen('阵列输出数据.txt','w');
    OutNum=8;%设置一下出多少个点
    %数据重排，按通道优先格式输出
    for i=1:Out_Row %遍历输出图片的行
        fprintf(fid_raw_W,'======================Row%d======================\n',i);
        Matrix_Flattened=OutFeature_3D_UnArranged{i};
        if i==Check_Row||(Check_All)
            for j=1:Out_Col%遍历列
                for k=1:(OutNum):Out_Channel-7%遍历输出通道
%                     fprintf(fid_raw_W,'%08x%08x%08x%08x%08x%08x%08x%08x\n',Matrix_Flattened(k+7,j),Matrix_Flattened(k+6,j),Matrix_Flattened(k+5,j),Matrix_Flattened(k+4,j),Matrix_Flattened(k+3,j),Matrix_Flattened(k+2,j),Matrix_Flattened(k+1,j),Matrix_Flattened(k,j));%低位第一个点，高位第二个点，
                      fprintf(fid_raw_W,'%08x%08x\n',Matrix_Flattened(k+1,j),Matrix_Flattened(k,j));%低位第一个点，高位第二个点，
                end
            end
        end
    end
    fclose(fid_raw_W);
end

if 0
    %检查第一个点的卷积计算
    reshape(Feature_In_padding(1:KernelSize,1:(Feature_Channel*KernelSize))',1,[])*WeightMatrix(:,1)
end
