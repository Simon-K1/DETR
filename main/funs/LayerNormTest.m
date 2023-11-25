%layernorm 的浮点计算
% (X-mu_x)*Gamma/sqrt((sigma_x)^2+eps)+Beta
%先计算均值
Matrix_In=rand(197,384);
Gamma=rand(1);
Beta=rand(1);

K=3;
Sin=((max(Matrix_In,[],"all")-min(Matrix_In,[],"all")/(2^8-1)))
bitWidth=8;
Zin=clip(round(min(Matrix_In,[],"all")/((max(Matrix_In,[],"all")-min(Matrix_In,[],"all")/(2^bitWidth-1)))),0,2^bitWidth-1);

M1=sum(Matrix_In,2)%沿第二个维度计算累加和
M2=sum(Matrix_In.^2,2)%沿第二个维度计算平方和
%% 论文的量化方法
scale8=Sin;
scale4=Scale8/2;
scale2=Scale4/2;
scale1=Scale2/2;
zero_point=Zin;
scale_mask = ones(1,size(Matrix_In,2));
for i=1:size(Matrix_In,2)%遍历列
    data=Matrix_In(:,i);
    data_q1=clip(round(data/scale1+Zin),0,255)-zero_point*scale1;
    data_q2=clip(round(data/scale2+Zin),0,255)-zero_point*scale2;
    data_q4=clip(round(data/scale4+Zin),0,255)-zero_point*Scale4;
    data_q8=clip(round(data/scale8+Zin),0,255)-zero_point*scale8;
    score1 = lp_loss(data, data_q1, 2.0, "all");
    score2 = lp_loss(data, data_q2, 2.0, "all");
    score4 = lp_loss(data, data_q4, 2.0, "all");
    score8 = lp_loss(data, data_q8, 2.0, "all");
    score = [score1, score2, score4, score8]
    
    [row,col]=find(score==min(score));

    scale_mask(i) =scale_mask(i)* 2^(col-1);
end