function [OutData] = SoftMax(Matrix)
%UNTITLED 输入一个二维矩阵，返回二维矩阵的Softmax结果（按行）
%   此处提供详细说明
Matrix=exp(Matrix);
OutData=zeros(size(Matrix));
    assert(length(size(Matrix))==2)
    for i=1:size(Matrix,1)
        for j=1:size(Matrix,2)
            OutData(i,j)=exp(Matrix(i,j))/sum(Matrix(i,:));
        end
    end
end