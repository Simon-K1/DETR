%% 设计一个权重展开,为脉动阵列生成标准的权重输入参考
%% for loop 1,底层forLoop
KernelSize=16;
In_Channel=3;
Out_Channel=768;
Stride=16;
SA_Row=8;%输入并行度，也是脉动阵列的行数
SA_Col=8;%输出并行度，也就是脉动阵列的列数


Weight_Matrix=zeros(In_Channel*KernelSize*KernelSize,Out_Channel);
Weight_Matrix=Weight_Matrix';
%前8个输出通道放第一段缓存，第2个8输出通道放第二段缓存
%也可以认为Weight_Matrix的前8列放第一段缓存，第二个8列放第二段缓存，第9列紧跟着第1列，以此类推
for Row=1:size(Weight_Matrix,1)%遍历行，输出通道
    for k=1:ceil(In_Channel/SA_Row)%一次处理8个点
        Weight_Matrix()
        
    end
end