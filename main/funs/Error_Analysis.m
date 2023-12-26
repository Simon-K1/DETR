function [outputArg1,outputArg2] = Error_Analysis(Correct,x)
%UNTITLED3 误差分析
%   输入两个二维矩阵
% 第一步：检查最大误差和最小误差
Error=abs(Correct-x);
Fpga_Error_Max=max(Error,[],'all');
Fpga_Error_Min=min(Error,[],'all');

nums=size(Fpga_Error_Min:0.01:Fpga_Error_Max,2)
k=1;
for i=Fpga_Error_Min:0.01:Fpga_Error_Max
    
    nums(k)=sum(Error<i,'all');
    k=k+1;
end
plot(Fpga_Error_Min:0.01:Fpga_Error_Max,nums);
%然后再统计每个区间内的数据有多少
for i=size(nums,2):-1:2
    nums(i)=nums(i)-nums(i-1)
end
%% 
figure 
bar(nums);
set(gca, 'XTick', 1:length(nums), 'XTickLabel', Fpga_Error_Min:0.01:Fpga_Error_Max)
num01=sum((Correct-x)<0.1,'all');
num001=sum((Correct-x)<0.01,'all');
num0001=sum((Correct-x)<0.001,'all');
num00001=sum((Correct-x)<0.0001,'all');


%%
figure 
x=Fpga_Error_Min:0.01:Fpga_Error_Max
z=nums
y=ones(1,size(nums,2))
plot3(x, y, z, 'b-', 'LineWidth', 2)
grid on
hold on
plot3(x, y+1, z, 'b-', 'LineWidth', 2)
hold on
plot3(x+0.1, y+2, z, 'b-', 'LineWidth', 2)


%% 绘制误差热度图
figure 
errorMatrix = abs(Error);
% 绘制误差图
imagesc(errorMatrix,[Fpga_Error_Min,Fpga_Error_Max])
% 添加颜色栏
colorbar
% 设置标题和轴标签
title('Error Map')
xlabel('Column')
ylabel('Row')

%% 绘制三维误差分布
%% 
figure 
surf(Error)
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

end

