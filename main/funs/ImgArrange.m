function [outputArg1,outputArg2] = ImgArrange(Img,inputArg2)
%UNTITLED3 此处提供此函数的摘要
%   将2D图片重新排列成3D
%% ⭐⭐⭐⭐⭐⭐⭐创建ConvOutput的输入txt和脉动阵列输出对比（也就是脉动阵列的输出）⭐⭐⭐⭐⭐⭐⭐
%脉动阵列输出的完整一列数据
    OutFeatureSize=size(Img,1);
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
        OutFeature_3D_Arranged(Row)={SA_OutPut_Row};
    end
end