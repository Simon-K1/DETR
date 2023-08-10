%% Encoder计算量分析

Embedding_Dim=768;%Linear维度
heads=12;
Token_Nums=197;
Depth=12;
LayerNorm_Pipeline=1;%layernorm流水线
SA_Size=8*8*8;
%% 构建Q，K，V以及各自的head数
head_dim=[Token_Nums,Embedding_Dim/heads];%每个头的维度
%% 每个头的计算时间：
% Head_Compute_Time=(head_dim(1)*head_dim(2))/(SA_Size)*(8-1+Embedding_Dim)*5/1000000;

%% 位置编码和cls_tk时间计算
pos_Cls_Time=((Token_Nums+1)*Embedding_Dim/8)*5/1000000
%% 先进layernorm
LayerNorm_Time=(Token_Nums+1)*Embedding_Dim/LayerNorm_Pipeline*5/1000000
%% 再算Linear
Linear_Time=(Token_Nums+1)*(Embedding_Dim*3)/(SA_Size)*(8-1+Embedding_Dim)*5/1000000;
%% Linear完了后开始算QKV多头
    %一共heads个[token_nums,embedding/heads]的矩阵计算
    QK_Time=(Token_Nums+1)*(Token_Nums+1)/(SA_Size)*(8-1+Embedding_Dim/heads)*5/1000000
    QK_SoftMax_Time=LayerNorm_Time;
    QKV_Time=QK_Time+QK_SoftMax_Time+(Token_Nums+1)*(Embedding_Dim/heads)/(SA_Size)*(8-1+Token_Nums)*5/1000000
    QKV_Time=QKV_Time*heads
%% QKV完了后继续算linear
    QKV_Linear=(Token_Nums+1)*(Embedding_Dim)/(SA_Size)*(8-1+Embedding_Dim)*5/1000000
%% 再算加上add后的总时间
    Total_Time_888=LayerNorm_Time+QKV_Time+QKV_Linear+pos_Cls_Time*3
    Total_Time_88=Total_Time_888*8+pos_Cls_Time*10
%% 
[Total_Time_888*Depth+3.0223,Total_Time_88*Depth+24.1786]