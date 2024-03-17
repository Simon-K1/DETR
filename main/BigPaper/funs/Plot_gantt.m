% 硬件计算流水线的任务及其执行时间
taskNames = {'任务1', '任务2', '任务3', '任务4', '任务5'};
taskDurations = [3, 2, 4, 2, 3]; % 任务执行时间

% 创建甘特图
figure;

% 绘制每个任务的横条
for i = 1:numel(taskDurations)
    % 绘制任务的横条
    rectangle('Position', [0, i-0.5, taskDurations(i), 1], 'FaceColor', 'blue');
    hold on;
    
    % 添加任务名称
    text(0, i, taskNames{i}, 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'left');
end

% 设置图形的标题和坐标轴标签
title('硬件计算流水线甘特图');
xlabel('时间');
ylabel('任务');

% 设置坐标轴限制
xlim([0, max(taskDurations)]);

% 设置坐标轴刻度
yticks(1:numel(taskDurations));
yticklabels(taskNames);

% 调整图形显示
axis ij;





% 任务名称
tasks = ["任务1", "任务2", "任务3", "任务4"];

% 任务开始时间
start_times = [1, 3, 5, 7];

% 任务持续时间
durations = [2, 4, 1, 3];

% 绘制甘特图条形
bar(start_times, durations);

% 添加文本标签
for i = 1:length(tasks)
    text(start_times(i) + durations(i)/2, 1, tasks(i));
end
