%% 设计空间探索
SA_Size=[4,8,64];
Head_Dim=64:64:1024
Compute_Time_NoOpt=[];
Compute_Time_Opt=[];
Throughput_NoOpt=[]
HeadNums=12;
for i=1:size(Head_Dim,2)
    Obj_NoOpt=Attn(1,[197,Head_Dim(i)],HeadNums,4,8,64,200,16,0,0)
    Obj_Opt=Attn(1,[197,Head_Dim(i)],HeadNums,4,8,64,200,16,0,1)
    Compute_Time_NoOpt=[Compute_Time_NoOpt,Obj_NoOpt.durationT]
    Compute_Time_Opt=[Compute_Time_Opt,Obj_Opt.durationT]
end

Compute_Time_NoOpt=Compute_Time_NoOpt-Compute_Time_NoOpt*0.25
Compute_Time_Opt=Compute_Time_Opt-Compute_Time_Opt*0.25


% 创建图形窗口


title('优化前后性能比较','FontName', '宋体', 'FontWeight', 'bold');



Bar=bar(Head_Dim, 100*(Compute_Time_NoOpt - Compute_Time_Opt)./Compute_Time_Opt,'FaceColor', [0.6 0.8 1]);
ylabel('优化率(%)','FontName', '宋体', 'FontWeight', 'bold');
hold on
yyaxis right;
color1 = [0.8500, 0.3250, 0.0980];  % 橙色
color2 = [0, 0.4470, 0.7410];  % 蓝色
% 绘制折线图并设置颜色和线型
plot(Head_Dim, Compute_Time_Opt, '--p', 'Color', color1, 'LineWidth', 2);
hold on;
plot(Head_Dim, Compute_Time_NoOpt, '--o', 'Color', color2, 'LineWidth', 2);
% 绘制柱状图（左侧坐标轴）

% 绘制折线图


% 设置右侧坐标轴的标签
ylabel('计算时间(ms)','FontName', '宋体', 'FontWeight', 'bold');
% 添加图例
legend('优化效果', '优化后', '优化前','FontName', '宋体', 'FontWeight', 'bold');
% 设置x轴标签
xlabel('头维度','FontName', '宋体', 'FontWeight', 'bold');
% 设置左侧坐标轴的标签和标题







