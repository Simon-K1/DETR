function [outputArg1,outputArg2] = Plot_HeatMap(HeatMatrix,Min_Max)
%专门画热度图

if 0
    clear
    %测试
    MatrixA=rand(197,384);
    MatrixB=rand(size(MatrixA,2),64);
    SystolicArray_Size_Max=256;%阵列最大尺寸
    %开始打点算利用率
    Utilization_Map=zeros(SystolicArray_Size_Max,SystolicArray_Size_Max);
    for i=1:SystolicArray_Size_Max
        for j=1:SystolicArray_Size_Max
            Utilization_Map(i,j)=PE_Utilization(MatrixA,MatrixB,1,i,j);
        end
    end
    Plot_HeatMap(Utilization_Map,[0,1])
end




figure 

% 绘制误差图
if isempty(Min_Max)
    imagesc(HeatMatrix);
else
    imagesc(HeatMatrix,Min_Max);
end
% 添加颜色栏
colorbar
% 设置标题和轴标签
title('Error Map')
xlabel('Column')
ylabel('Row')

%% 绘制三维误差分布
%% 
figure 
surf(HeatMatrix)
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

