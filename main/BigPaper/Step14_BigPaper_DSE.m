%% 设计空间探索

if 0
   
    clear
    %测试
    MatrixA=rand(197,384);
    MatrixB=rand(size(MatrixA,2),64);
    SystolicArray_Size_Max=64;%阵列最大尺寸
    %开始打点算利用率
    Utilization_Map=zeros(SystolicArray_Size_Max,SystolicArray_Size_Max);
    GemmTime_Map=zeros(SystolicArray_Size_Max,SystolicArray_Size_Max);
    for tile=1:SystolicArray_Size_Max
        for width=1:SystolicArray_Size_Max
            if(tile*width<4*64)
                Utilization_Map(tile,width)=PE_Utilization(MatrixA,MatrixB,tile,8,width);
                [CacheTime,GemmTime_Map(tile,width),Macs]=GemmTime(size(MatrixA),size(MatrixB),[tile,8,width],200,8);
            else
                Utilization_Map(tile,width)=0;
            end
        end
    end
    Plot_HeatMap(Utilization_Map,[0,1])
    Plot_HeatMap(GemmTime_Map,[])

    %统计利用率大于80%的点的计算时间
    time_all=(Utilization_Map>0.8).*GemmTime_Map%寻找资源利用率大于0.8的点
    [Min,Location]=min((time_all==0)*max(time_all,'all')*2.+time_all,[],'all');%寻找满足条件的配置
end



% 生成示例数据
x = 1:5;
y = 1:5;
z = [2 4 3 5 1; 5 1 2 3 4; 3 5 4 1 2; 2 3 5 4 1; 4 2 1 3 5];
% 绘制三维柱状图
figure;
b = bar3(Utilization_Map);
% 设置透明度
alpha(b, 0.8);
% 设置颜色映射
colormap(jet);
% 添加坐标轴标签和标题
xlabel('X');
ylabel('Y');
zlabel('Z');
title('3D柱状图');
% 调整视角
view(45, 30);


%% 手动标几个阵列算利用率和时间
MatrixA=rand(197,384);
MatrixB=rand(size(MatrixA,2),64);
width=64;
tile=4;
Utilization=zeros(1,width/8);
Utilization_Map=[];
for j=1:tile
    for i=0:8:width
        (i==0)+i;
        Utilization(i/8+1)=PE_Utilization(MatrixA,MatrixB,j,8,(i==0)+i);
    end
Utilization_Map=[Utilization_Map;Utilization];
end

%% 计算一个阵列中，随着矩阵计算的大小增加，PE利用率的变化
A_Size=[1,1];
B_Size=[1,1];%初始大小为1*1的计算
SA_Size=[1,8,8]%脉动阵列大小
Matrix_Max=4096;%设置最大的矩阵乘法尺寸
Utilization_Map=zeros(8);
for i=0:512:Matrix_Max
    for j=0:512:Matrix_Max
        if i>1&&j>1
            Utilization_Map(i/512,j/512)=PE_Utilization(rand(i,j),rand(j,j),4,8,32);
            GemmTime(size(MatrixA),size(MatrixB),[tile,8,width],200,8);
        end
    end
end




A=[
    512,1024
    512,1024
    1024,1024
    1024,1024
    1024,1024
    1024,1024
    ]
B=[
    1024,128
    1024,192
    1024,256
    1024,257
    1024,513
    1024,1025
    ]
rst=[]
PE_U=[]
for i=1:size(A,1)
    [WeightCache_Time,Compute_Time,MACs]=GemmTime(A(i,:),B(i,:),[4,8,64],200,8)
    rst=[rst;WeightCache_Time,Compute_Time,MACs];
    PE_U=[PE_U;PE_Utilization(rand(A(i,:)),rand(B(i,:)),4,8,64)]
end
Gops=rst(:,3)./(rst(:,2)+rst(:,1))*1000
Latency=(rst(:,2)+rst(:,1))
[rst(:,3),Latency,Gops]

