%% 大论文的设计实现与优化
%% 矩阵融合计算，消除Bias影响
A=randi(127,197,768);
B=rand(768,64);
Bias=rand(1,64);
C1=A*B+Bias;
C2=[A ones(197,1)]*[B;Bias]
C1-C2

W_Q=rand(size(A,2),64);
Bias_Q=rand(1,64);
W_K=rand(size(A,2),64);
Bias_K=rand(1,64);

Q=A*W_Q+Bias_Q;
K=A*W_K+Bias_K;
QK=Q*K'
fused_Q=fuse_bias(A,W_Q,Bias_Q);
Q-fused_Q
fused_K=fuse_bias(A,W_K,Bias_K);
K-fused_K
QK-fused_Q*fused_K'%加一融合没问题

error1=QK-[A ones(size(A,1),1)]*[W_Q;Bias_Q]*[W_K;Bias_K]'*[A ones(size(A,1),1)]'%不对，有误差
error2=QK-[A ones(size(A,1),1)]*[W_Q;Bias_Q]*([A ones(size(A,1),1)]*[W_K;Bias_K])'
error3=QK-[A ones(size(A,1),1)]*[W_Q;Bias_Q]*([W_K;Bias_K]'*[A ones(size(A,1),1)]')


%关于matlab转置计算的误差
aa=(A*W_Q)'-W_Q'*A'

W_fused=[W_Q;Bias_Q]*[W_K;Bias_K]';
Fused_QK1=(A*W_fused(1:end-1,:)+W_fused(end,:))*[A ones(size(A,1),1)]';
QK-Fused_QK1

Fused_QK2=(A*W_fused(1:end-1,1:end-1)+W_fused(end,1:end-1))*A'+z;



%% 资源利用率计算
if 0
    MatrixA=rand(197,385);
    MatrixB=rand(size(MatrixA,1),385);
    SA_t=4;
    SA_h=8;
    SA_w=64;
    Utilization=Resource_Utilization(MatrixA,MatrixB,SA_t,SA_h,SA_w)
end

function [fused]=fuse_bias(MatrixA,MatrixB,Bias)
    fused=[MatrixA ones(size(MatrixA,1),1)]*[MatrixB;Bias]
end

function [Utilization]=Resource_Utilization(MatrixA,MatrixB,SA_t,SA_h,SA_w)
    A_Size=size(MatrixA);
    B_Size=size(MatrixB);
    Utilization_100=(SA_h*ceil(A_Size(1)/SA_h))*((SA_t*SA_w)*ceil(B_Size(2)/(SA_t*SA_w)));%当前计算模式下，利用率为100的矩阵计算
    Utilization=A_Size(1)*B_Size(2)/Utilization_100;
end




