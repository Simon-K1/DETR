function createfigure(xvector1, yvector1, X1, YMatrix1)
%CREATEFIGURE(xvector1, yvector1, X1, YMatrix1)
%  XVECTOR1:  bar xvector
%  YVECTOR1:  bar yvector
%  X1:  plot x 数据的向量
%  YMATRIX1:  plot y 数据的矩阵

%  由 MATLAB 于 01-Apr-2024 20:21:55 自动生成

% 创建 figure
figure1 = figure;

% 创建 axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');
colororder([0 0 0]);

% 激活坐标区的 left 侧
yyaxis(axes1,'left');
% 创建 bar
bar1 = bar(xvector1,yvector1,'DisplayName','误差值',...
    'FaceColor',[0.301960784313725 0.745098039215686 0.933333333333333]);

% 下面一行演示创建数据提示的另一种方法。
% datatip(bar1,-0.69,9.4174339444475e-06);
% 创建 datatip
datatip(bar1,'DataIndex',32,'Location','northeast');

% 下面一行演示创建数据提示的另一种方法。
% datatip(bar1,-0.13,0.00212341557943851);
% 创建 datatip
datatip(bar1,'DataIndex',88);

% 创建 ylabel
ylabel('误差值','FontWeight','bold','FontSize',12,'FontName','宋体');
% 取消以下行的注释以保留坐标区的 Y 范围
% ylim(axes1,[-0.00543731778425656 0.0245626822157434]);

% 设置其余坐标区属性
set(axes1,'YColor',[0 0 0]);
% 激活坐标区的 right 侧
yyaxis(axes1,'right');
% 使用 plot 的矩阵输入创建多个 line 对象
plot1 = plot(X1,YMatrix1);
set(plot1(1),'DisplayName','exp曲线','LineWidth',2);
set(plot1(2),'DisplayName','i-exp曲线','LineWidth',3,'Color',[1 0 1]);

% 取消以下行的注释以保留坐标区的 Y 范围
% ylim(axes1,[0.356657223796034 1.15665722379603]);

% 设置其余坐标区属性
set(axes1,'YColor',[0.85 0.325 0.098]);
% 取消以下行的注释以保留坐标区的 X 范围
% xlim(axes1,[-1.01532467532468 0.0086753246753243]);
box(axes1,'on');
hold(axes1,'off');
% 创建 legend
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.663578507229215 0.729767001997938 0.163522009617128 0.150115469311456],...
    'FontWeight','bold',...
    'FontSize',12,...
    'FontName','宋体');

% 创建 line
annotation(figure1,'line',[0.369642857142857 0.369642857142857],...
    [0.921428571428571 0.116666666666667],'LineStyle',':');

