%% 模拟卷积计算
for row=1:Stride:In_Row-KernelSize+1
    for col=1:Stride:In_Col-KernelSize+1
        Window=reshape(Feature_In(row:row+KernelSize-1,(col-1)*Feature_Channel+1:(col+KernelSize-1)*Feature_Channel)',1,[]);
        ConvResult=Window*WeightMatrix
    end
end
