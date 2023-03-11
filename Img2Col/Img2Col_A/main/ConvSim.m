%% 模拟卷积计算
clear
load("matlab.mat")
OutFeature=zeros(Out_Row,Out_Col*Out_Channel);
i=1;
j=1;
%% 这几行破代码调了3天，，，
for row=1:Stride:In_Row-KernelSize+1%遍历行
    for col=1:Stride:In_Col-KernelSize+1%遍历列
        Window=reshape(Feature_In(row:row+KernelSize-1,(col-1)*Feature_Channel+1:(col+KernelSize-1)*Feature_Channel)',1,[]);%计算一个滑窗对应的全部输出点
        OutFeature(i,j:j+Out_Channel-1)=Window*WeightMatrix;
        j=j+Out_Channel;
    end
    i=i+1;
    j=1;
end
