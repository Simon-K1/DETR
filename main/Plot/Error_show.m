% 创建示例矩阵
A = [1, 2, 3; 4, 5, 6; 7, 8, 9];
B = [1.1, 1.9, 3.1; 4.2, 5.2, 6.1; 7.1, 7.9, 9.2];

% 计算矩阵之间的误差
errorMatrix = abs(A - B);

% 绘制误差图
imagesc(errorMatrix)

% 添加颜色栏
colorbar

% 设置标题和轴标签
title('Error Map')
xlabel('Column')
ylabel('Row')

%%
%%
Z = 10 + peaks;
surf(Z)
hold on
imagesc(Z)

%%
% 创建示例矩阵
A = [1, 2, 3; 4, 5, 6; 7, 8, 9];
B = [1.1, 1.9, 3.1; 4.2, 5.2, 6.1; 7.1, 7.9, 9.2];
% 计算矩阵之间的误差
errorMatrix = abs(A - B);
% 创建网格
[X, Y] = meshgrid(1:size(errorMatrix, 2), 1:size(errorMatrix, 1));
% 绘制立体误差图
surf(X, Y, errorMatrix)
% 设置视角和光照
view(45, 30)
lighting gouraud
shading interp
% 设置标题和轴标签
title('Error Surface')
xlabel('Column')
ylabel('Row')
zlabel('Error')
% 添加颜色栏
colorbar