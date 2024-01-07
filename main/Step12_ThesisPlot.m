% 定义属性的名称和数据
subplot(1, 2, 1);

Cfg=[
"(1,8,8)"  
"(2,8,8)"   
"(3,8,8)"   
"(3,8,64)"  
"(4,8,32)"
"(4,8,64)"
] 
Data=[
    [7,1,4,26,8];
    [9,1,5,41,11];
    [11,1,6,55,13];
    [47,3,24,55,66];
    [33,2,17,56,46];
    [62,4,30,70,87];
    ]
%用Struct创建一个有序字典
orderedDict = struct('Cfg', Cfg, 'Data', Data);
%Cfg=dictionary(Cfg,Data);%创建一个字典---dictionary 只能在2023a以上的版本使用
Cfg_nums=size(Cfg,1);


b=bar(Data,'FaceColor','flat');
% for i=1:5
%     b.CData(i,:)=rand(1,3);
% end
% 设置 x 轴标签
xticks(1:Cfg_nums);
xticklabels(Cfg);
% 设置 y 轴标签
ylabel('Utilization(%)');
% 标题
title('A:The resource utilization and energy efficiency of accelerators of different sizes');
% 网格线
grid on;
% 添加图例


% 创建折线图
hold on;
Dly_Tiny=[
    97.320
    49.543
    33.637
    7.457
    9.288
    6.725
]
Dly_Small=[
   346.670
    175.010
    117.837
    21.111
    26.146
    16.776
]
Dly_Base=[
    1301.488
    654.045
    438.319
    67.379
    90.181
    52.170
]
Gops=[25.144
    50.034
    74.659
    485.679
    362.873
    626.884
    ]%就是每个加速器在Vit-Base下的Gops
Power=[
  4.509
  5.002 
  5.398 
  10.881 
  8.5 
  13.225%12.0250
];
Power=Power-1.2;
Eff=Gops./(Power-2.2)
yyaxis right;  % 使用右边坐标轴
ylabel('Energy efficiency(Gops/w)');
color = rand(1,3);  % 随机生成RGB颜色
plot(Eff, '-.o', 'LineWidth', 3,'Color',color);
legend('LUT', 'LUTRAM', 'FF', 'BRAM', 'DSP',"Gops/w");


subplot(1, 2, 2);

color = rand(1,3);  % 随机生成RGB颜色
plot(Dly_Tiny, '-.o', 'LineWidth', 3,'Color',color);
hold on
color = rand(1,3);  % 随机生成RGB颜色
plot(Dly_Small, '-.o', 'LineWidth', 3,'Color',color);
hold on
color = rand(1,3);  % 随机生成RGB颜色
plot(Dly_Base, '-.o', 'LineWidth', 3,'Color',color);

% legend("Vit-Base","Vit-Small","Vit-Tiny");
xticks(1:Cfg_nums);
xticklabels(Cfg);
ylabel('Latency(ms)');

yyaxis right;  % 使用右边坐标轴
ylabel('Throughput（Gop/s)');
hold on
color = rand(1,3);  % 随机生成RGB颜色
plot(Gops, '-.p', 'LineWidth', 3,'Color',color);
legend("Vit-Base","Vit-Small","Vit-Tiny","Throughput")
title("B:Performance of accelerator with different sizes")
%% 卷积3*3~16*16的计算时间统计

Strides = [];
times = [];
figure
for KernelSize = 3:16
    Strides = [1:KernelSize,zeros(1,16-KernelSize)];
    times = [times;[randi(10,[1,KernelSize]),zeros(1,16-KernelSize)]];
    bar3(times);
    hold on
end


figure
for KernelSize = 3:16
    Strides = 1:KernelSize;
    times = randi(10,[1,KernelSize]);
    color = rand(1,3);  % 随机生成RGB颜色
    plot3([Strides; times],'Color',color);
     
    hold on
end
grid on

xlabel('Kernel Size');
ylabel('Stride');
zlabel('Time');
title('Computational Time for Different Kernel Sizes and Strides');

grid on;

%% 画4*4的大图用于展示对不同尺度和不同大小卷积的支持
clear
figure;
Freq=200;
CLK_CYCLE=((1/(Freq*10^6))*10^9)/10^6 ;%时钟周期：单位用ms来表示
Slice=4;
Height=8;
Width=64;
DMA_WDITH=24;
for i = 1:14
    subplot(4, 4, i);
    KernelSize=i+2;
    times=[];
    Gops=[];
    OutSize=[];
    Feature_Channel=8;
    Out_Channel=768;
    
    for Strides = 1:KernelSize;
        [InSize,OutFeatureSize]=BuildPicture(480,Feature_Channel,Out_Channel,KernelSize,Strides);
      
        OutSize=[OutSize,OutFeatureSize];%获取输入图片大小图片大小
        
        
        A_Size=[OutFeatureSize^2,KernelSize^2*Feature_Channel];
        B_Size=[KernelSize^2*Feature_Channel,Out_Channel];
        %% 卷积计算
        [Conv_Cache,Conv_Compute,Conv_MACS]=GemmTime(A_Size,B_Size,[Slice,Height,Width],Freq,DMA_WDITH);
        Conv_Gops=Conv_MACS/(Conv_Compute+Conv_Cache)*10^3%B矩阵缓存时间时间不应该考虑，因为在计算的时候可以同时缓存权重
        Total_Time=Conv_Compute+Conv_Cache;
        Total_Macs=Conv_MACS;

        times = [times,Conv_Gops];
        Gops=[Gops,Total_Macs];
    end
    color = rand(1,3);  % 随机生成RGB颜色
    plot(1:KernelSize, times,'-p','LineWidth',1,'Color',color);
    ylabel("Gops")
    hold on
    color = rand(1,3);  % 随机生成RGB颜色
    yyaxis right;
%     semilogy(1:KernelSize, Gops, 'r-o');
%     hold on

%     gca.YAxis(2).Scale = 'log';  % 设置右边坐标轴为对数刻度
    plot(1:KernelSize, Gops,'-o','LineWidth',1,'Color',color);
    %xlabel("kernelsize");
    ylabel("Macs")
    title("KernelSize="+string(KernelSize)+";Stride=1~"+string(KernelSize),'FontWeight','bold')
    grid on
end
legend('Gops','MAC');

