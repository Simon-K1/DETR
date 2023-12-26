% 创建示例数据
x1 = [1, 2, 3, 4, 5];
y1 = [1, 2, 3, 4, 5];
z1 = [1, 4, 9, 16, 25];

x2 = [1, 2, 3, 4, 5];
y2 = [1, 4, 9, 16, 25];
z2 = [1, 2, 3, 4, 5];

% 创建新的图形窗口
figure

% 绘制第一个二维坐标图
plot3(x1, y1, z1, 'b-', 'LineWidth', 2)
hold on

% 绘制第二个二维坐标图
plot3(x2, y2, z2, 'r-', 'LineWidth', 2)

% 添加标题和轴标签
title('Combined 3D Plot')
xlabel('X')
ylabel('Y')
zlabel('Z')

% 设置图例
legend('Data 1', 'Data 2')

% 设置视角
view(45, 30)

% 设置坐标轴范围
xlim([1, 5])
ylim([1, 25])
zlim([1, 25])

% 添加网格
grid on



