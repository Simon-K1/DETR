%% 卷积完了之后，开始layernorm计算
%layerNorm的输入数据是一个矩二维矩阵
clear
load("tensors7.mat");


Correct=tensor1;
Fp64=tensor2;%浮点量化结果
Fpga=tensor3;%整形前向传播后Fpga的计算结果
x=Fp64;
%第一步，画柱状图
Picture_Num=3
for i=1:Picture_Num
    subplot(3,Picture_Num,i);
    load("tensors"+string(i)+".mat");
    Correct=tensor1;
    Fp64=tensor2;%浮点量化结果
    [Error,Fpga_Error_Min,Fpga_Error_Max]=AbsError(Correct,Fp64);

    %% 
    subplot(3,Picture_Num,Picture_Num+i);
    errorMatrix = abs(Error);
    tmp=[];
    if size(size(errorMatrix))>2
        for head_index=1:12%将softmax的每个头都concat起来
            tmp=[tmp,errorMatrix(head_index,:,:)];
        end
        errorMatrix=squeeze(tmp);
    end
    
    % 绘制误差图
    imagesc(errorMatrix,[Fpga_Error_Min,Fpga_Error_Max])
    % 添加颜色栏
    colorbar
    % 设置标题和轴标签
    title('Absolute Error Heatmap')
    xlabel('Column')
    ylabel('Row')
    %% 
    subplot(3,Picture_Num,Picture_Num*2+i);
    surf(errorMatrix)
    view(45, 30)
    lighting gouraud
    shading interp
    % 设置标题和轴标签
%     title('Error Surface')
    xlabel('Column')
    ylabel('Row')
    zlabel('Error')
    % 添加颜色栏
    colorbar
end
num01=sum((Correct-x)<0.1,'all');
num001=sum((Correct-x)<0.01,'all');
num0001=sum((Correct-x)<0.001,'all');
num00001=sum((Correct-x)<0.0001,'all');
%% 
figure 
bar3(nums)


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

%% 饼状图
values = [30, 20, 15, 35];
categories = {'Category 1', 'Category 2', 'Category 3', 'Category 4'};
pie(nums(1:end))
nums(1,:)/sum(nums)
