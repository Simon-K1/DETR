
Cfg=[
"(1,8,8)"  
"(2,8,8)"   
"(3,8,8)"   
"(4,8,32)"
"(3,8,64)" 
"(4,8,64)"
] 
Data=[
    [7,1,4,26,8];
    [9,1,5,41,11];
    [11,1,6,55,13];
    [33,2,17,56,46];
    [47,3,24,55,66];
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
ylabel('Utilization(%)','FontWeight','bold');
% 标题
title('不同大小加速器的资源利用率和功耗','FontWeight','bold');
% 网格线
grid on;
% 添加图例


% 创建折线图
hold on;
Dly_Tiny=[
    97.351
    49.540
    33.637
    9.288
    7.457
    6.725
]
Dly_Small=[
    346.367
    174.739
    117.837
    26.146
    21.111
    16.776
]
Dly_Base=[
    1300.594
    653.159
    438.319
    90.181
    67.379
    52.170
]
Gops_Base=[
    25.161
    50.034
    74.659
    362.873
    485.679
    626.884
    ]%就是每个加速器在Vit-Base下的Gops
Gops_Small=[
    25.098
    49.750
    73.774
    332.101
    411.790
    480.702
    ]%就是每个加速器在Vit-Base下的Gops
Gops_Tiny=[
    24.955
    49.039
    72.224
    261.556
    325.805
    360.338
    ]%就是每个加速器在Vit-Base下的Gops
Power=[
  3.509
  4.002 
  4.398 
  7.5 
  8.881 
  10.28%12.0250
];
% Eff=Gops_Base./(Power)
% yyaxis right;  % 使用右边坐标轴
% ylabel('Energy efficiency(Gops/w)');
% color = rand(1,3);  % 随机生成RGB颜色
% plot(Eff, '-.o', 'LineWidth', 3,'Color',color);
% legend('LUT', 'LUTRAM', 'FF', 'BRAM', 'DSP',"GOPs/w");

%画Power曲线
Power=(Power)
yyaxis right;  % 使用右边坐标轴
ylabel('Power','FontWeight','bold');
color = rand(1,3);  % 随机生成RGB颜色
plot(Power, '-.o', 'LineWidth', 3,'Color',color);
legend('LUT', 'LUTRAM', 'FF', 'BRAM', 'DSP',"Power(W)",'FontWeight','bold');