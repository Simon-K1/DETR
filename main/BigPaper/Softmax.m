%I-Exp计算误差
p=-1*log(2):0.01:0

I_Exp=@(p)0.3585*(p+1.353).^2+0.344
range=-1:0.01:0
Error=I_Exp(range)-exp(range)

bar1=bar(range,Error,'DisplayName','误差值',...
    'FaceColor',[0.301960784313725 0.745098039215686 0.933333333333333])
ylabel('误差值','FontWeight','bold','FontSize',14,'FontName','宋体');
datatip(bar1,'DataIndex',88);
datatip(bar1,'DataIndex',32,'Location','northeast');

yyaxis right
P=plot(range,exp(range),range,I_Exp(range),'LineWidth',3)
ylabel('计算值','FontSize',14,'FontWeight','bold','FontName','宋体')
legend("误差值","exp曲线","L(p)曲线")


% 创建 line
annotation('line',[0.369642857142857 0.369642857142857],...
    [0.921428571428571 0.116666666666667],'LineStyle',':');
