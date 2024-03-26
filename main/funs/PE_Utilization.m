function [Utilization] = PE_Utilization(MatrixA,MatrixB,SA_t,SA_h,SA_w)
%UNTITLED3 计算当前矩阵乘法在当前PE尺寸上的利用率
    A_Size=size(MatrixA);
    B_Size=size(MatrixB);
    
    Utilization_100=(SA_h*ceil(A_Size(1)/SA_h))*((SA_t*SA_w)*ceil(B_Size(2)/(SA_t*SA_w)));%当前计算模式下，利用率为100的矩阵计算
    Utilization=A_Size(1)*B_Size(2)/Utilization_100;
end