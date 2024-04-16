% 创建任务的起始时间和持续时间
taskNames = {'Img2Col', 'A', 'B', 'C','LayerNorm','SoftMax'};
startTimes = [0, 2, 4, 6]; % 任务的起始时间
durations = [3, 2, 4, 2]; % 任务的持续时间

% 计算任务的结束时间
endTimes = startTimes + durations;

% 创建甘特图
figure;
hold on;
barh(1:numel(taskNames), [startTimes; durations]', 'stacked');
yticks(1:numel(taskNames));
yticklabels(taskNames);
xlabel('时间');
ylabel('任务');
title('硬件计算流水线甘特图');

% 添加任务的结束时间标签
for i = 1:numel(taskNames)
    text(endTimes(i), i, sprintf('%d', endTimes(i)), 'VerticalAlignment', 'middle');
end

% 调整图表的样式
grid on;




%% 第二个版本
% 创建一个示例的任务列表
taskNames = {'任务1', '任务2', '任务3', '任务4', '任务5'};
startTimes = [0, 2, 4, 6, 8]; % 任务开始时间
durations = [3, 2, 4, 3, 2]; % 任务持续时间

% 计算任务的结束时间
endTimes = startTimes + durations;

% 创建甘特图
figure;
hold on;
for i = 1:numel(taskNames)
    % 绘制甘特图条形
    barh(i, [startTimes(i), durations(i)], 'stacked');
    text(startTimes(i) + durations(i)/2, i, taskNames{i}, ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
end

% 设置图表属性
ylim([0.5, numel(taskNames) + 0.5]);
yticks(1:numel(taskNames));
yticklabels(taskNames);
xlabel('时间');
ylabel('任务');
title('计算流水线甘特图');

% 绘制网格线
grid on;

% 添加时间轴
xticks(0:max(endTimes));
xticklabels(0:max(endTimes));


%%
