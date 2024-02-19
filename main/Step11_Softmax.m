%% 绘制误差图
load("Softmax_tensors.mat")
Error_Analysis(squeeze(tensor1(1,:,:)),squeeze(tensor2(1,:,:)))


%% 研究Softmax补零之后的影响
MatrixA=rand(197,197)
MatrixA_Padding=[MatrixA,zeros(197,3)];
A=SoftMax(MatrixA)
B=SoftMax(MatrixA_Padding)


%% 移位取整和原始代码中的直接取整的误差区别
Xq=-21;
Scale=0.3344;
Z_Tmp=Xq*floor(-1*Scale/log(2)*2^16)/2^16;


x0_int=floor(-1*log(2)/Scale);
Z=Xq/x0_int

%% 读取来源于pytorch的Softmax标准输入
PreFix="Softmax";
fid=fopen(PreFix+".bin","r");
data=fread(fid,[197,197],'uint8');
data=data';%因为按列优先读取
fclose(fid);



data_flatten=reshape(data',1,[]);
fid=fopen(PreFix+".txt",'w');
for i=1:size(data_flatten,2)
    fprintf(fid,"%s\n",dec2hex(data_flatten(i)));
end
fclose(fid);


%开始模拟论文的计算
Max=max(data,[],2);
data_sub_Max=data-Max;
ln2=0.6931;
Scaling_Factor=0.2550701201
data_sub_Max=max(data_sub_Max,30*floor(-1*ln2/Scaling_Factor))
Z_Scale=floor(-1*(Scaling_Factor/0.6931)*2^16)
Z_Tmp=data_sub_Max*Z_Scale
Z=floor(Z_Tmp/2616)