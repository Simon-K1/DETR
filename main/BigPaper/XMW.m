% clear
clc

% 当前路径
folder_path = pwd;
[ul_path, ~, ~] = fileparts(folder_path);
[upper_level_path, ~, ~] = fileparts(ul_path);
% 获得公共颜色包的路径
color_data = load(fullfile(upper_level_path, 'common-color.mat'));

% color甘特图颜色
% color=['r','g','b','c','m','y', 'k', 'w'];
color=color_data.color;

test_data_name = 'matlab-IMPA-684-16-59-6.8958.mat';
file_path = fullfile(folder_path, test_data_name);
data = load(file_path);
gantt = data.gantt;

% 设备数量
equsize = data.equsize;
equsize_total = sum(equsize);
piecetime = data.piecetime;
[piecesize, prosize] = size(piecetime);
% 任务数量
task_num = piecesize*prosize;

% 坐标轴
f1 = figure;
[ha, pos] = tight_subplot(1, 1, [0 0], [0.02 0.02], [0.06 0.015]);
[y_axis, x_axis] = size(gantt);
axis([0, x_axis+size(gantt, 2)*0.015, 0, y_axis+1]);
% ylim([0.2, equsize_total+1]);
% set(gca, 'XTick', 0:500:x_axis);
set(gca, 'XTick', []);
set(gca, 'YTick', 0:1:y_axis);
set(gcf, 'Position', [100, 100, 1050, 550]);
% 设置坐标轴方向向下
% set(gca, 'YDir', 'reverse');
% 消除白边
% set(gca, 'LooseInset', [0,0,0,0]);
xy_font_size = 11;
% xlabel('加工时间', 'FontSize', xy_font_size);
ylabel('Device Number', 'FontSize', xy_font_size, 'FontName', 'Times New Roman');
% title('WEHFSP 01 实例的加工甘特图', 'FontSize', xy_font_size)

% 设置纵坐标轴
y_axis_str = cell(1, equsize_total+1);
y_axis_str{1, 1} = '';
for i=1:equsize_total
    temp = ['M', num2str(i)];
    y_axis_str{1, i+1} = temp;
end
yticklabels(y_axis_str');
ax = gca;
ax.YAxis.FontName = 'Times New Roman';
% 添加rectangle样式


[x_start_time, y_start_time, task_duration_time, task_job_id] = cal_task_info(gantt, task_num);

% 矩形框的数据
rec=[0,0,0,0];
rec_height = 0.5;
rec_height_half = rec_height/2;
% 字体
font_name = 'FixedWidth';

for i =1:task_num
    % 矩形的横坐标
    rec(1) = x_start_time(i);
    % 矩形的纵坐标
    rec(2) = y_start_time(i) - rec_height_half;
    % 矩形的x轴方向的长度
    rec(3) = task_duration_time(i);
    rec(4) = rec_height;

    % 将工序加工时间输出
    txt_start=sprintf('%d', x_start_time(i));
    txt_end=sprintf('%d', x_start_time(i)+task_duration_time(i));
    x_txt = x_start_time(i);
    y_txt = (y_start_time(i)-0.2-rec_height_half);
    % 绘制矩形
    rectangle('Position', rec, 'LineWidth', 0.5, 'LineStyle', '-', 'FaceColor', color(task_job_id(i), :));
    % 字体坐标
    if x_txt~=1
        text(x_txt, y_txt, txt_start, 'FontWeight', 'normal', 'FontSize', 7, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    end
    text(x_txt+task_duration_time(i), y_txt, txt_end, 'FontWeight', 'normal', 'FontSize', 7, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    % 输出工件的工序信息
    x_job = x_start_time(i)+task_duration_time(i)/2;
    y_job = (y_start_time(i));
    % 计算是第几道工序
    flag = task_job_id(1:i)==task_job_id(1, i);
    job_pro_num = size(find(flag), 2);
    str_job = ['J', num2str(task_job_id(i)), ', ', num2str(job_pro_num)];
    text(x_job, y_job, str_job, 'FontWeight', 'Bold', 'FontSize', 7, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
end

% 输出图片
currentTime = clock;
d1 = currentTime(4);
d2 = currentTime(5);
d3 = floor(currentTime(6));
[~, data_name, ~] = fileparts(folder_path);
resolution = '500';
st = '-';
file_name = [data_name, st, test_data_name, st, num2str(d1), st, num2str(d2), st, num2str(d3), st, resolution, '.png'];
% print(file_name, '-dpng', ['-r', resolution]);


function [x_start_time, y_start_time, task_duration_time, task_job_id] = cal_task_info(gantt, task_num)
    arr_length = task_num;
    % 横坐标
    x_start_time = zeros(1, arr_length);
    % 纵坐标
    y_start_time = zeros(1, arr_length);
    % 加工时间
    task_duration_time = zeros(1, arr_length);
    % 工件编号
    task_job_id = zeros(1, arr_length);
    
    % 遍历加工时间表
    i = 1;
    k = 0;
    while i<=size(gantt, 1)
        [~, process_time_length] = cal_task_num_info(gantt(i, :));

        for j=1:size(process_time_length, 2)
            info = process_time_length{1, j};
            x_start_time(1, k+j) = info(1, 3);
            y_start_time(1, k+j) = i;
            task_duration_time(1, k+j) = info(1, 2);
            task_job_id(1, k+j) = info(1, 1);
        end
        k = k+size(process_time_length, 2);
        i = i + 1;
    end
end

% 计算每个设备加工工件信息
function [task_num, process_time_length] = cal_task_num_info(equ_state)
    nonzero = find(equ_state);
    istart = nonzero(1, 1);
    iend = nonzero(1, size(nonzero, 2));
    
    % 加工工件数量
    task_num = 0;
    % 加工工件时长
    process_time_length = cell(1, 1);
    i = istart;
    while i<iend
        if equ_state(i)~=0
            % 当前加工工件编号
            piece_no = equ_state(i);

            task_num = task_num + 1;
            counter = 0;
            for j=i:iend
                if equ_state(j) == equ_state(i)
                    counter = counter + 1;
                else
                    break;
                end
            end
            info = zeros(1, 3);
            info(1, 1) = piece_no;
            info(1, 2) = counter;
            info(1, 3) = i;
            if task_num > 1
                process_time_length{1, end+1} = info;
            else
                process_time_length{1, 1}=info;
            end
            % 必须更新i的索引, 因为待机时间段长度一般不是1, 如果t和t+1位置均是0, 那么会计算成两端待机时间段, 实际上是一段待机时间
            i = j;
        else
            i = i + 1;
            continue;
        end
    end
end

