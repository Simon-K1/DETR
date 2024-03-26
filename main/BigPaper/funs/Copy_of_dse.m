%% 设计空间探索
SA_Size=[4,8,64];
Head_Dim=64:64:1024
Compute_Time_NoOpt=[];
Compute_Time_Opt=[];
Throughput_NoOpt=[]
HeadNums=12;
for i=1:size(Head_Dim,2)
    %构建Q，K
    [WeightCache,Compute_Time,Macs]=GemmTime([197,Head_Dim(i)],[Head_Dim(i),64],[4,8,64],200,24);
    Compute_Time_NoOpt=[Compute_Time_NoOpt,(Compute_Time+WeightCache)*2*HeadNums];
    %Q*K^T
    [WeightCache,Compute_Time,Macs]=GemmTime([197,64],[64,197],[4,8,64],200,24);
    Compute_Time_NoOpt(end)=Compute_Time_NoOpt(end)+(Compute_Time+WeightCache)*HeadNums

    [WeightCache,Compute_Time,Macs]=GemmTime([197,Head_Dim(i)],[Head_Dim(i),Head_Dim(i)+1],[4,8,64],200,24);
    Compute_Time_Opt=[Compute_Time_Opt,(Compute_Time+WeightCache)*HeadNums];
    [WeightCache,Compute_Time,Macs]=GemmTime([197,Head_Dim(i)+1],[Head_Dim(i)+1,197],[4,8,64],200,24);
    Compute_Time_Opt(end)=Compute_Time_Opt(end)+(Compute_Time+WeightCache)*HeadNums;
end
plot(Head_Dim,Compute_Time_Opt)
hold on
plot(Head_Dim,Compute_Time_NoOpt)

