days = 0:5:35;
conc = [515 420 370 250 135 120 60 20];
temp = [29 23 27 25 20 23 23 17];
yyaxis right%控制左纵轴
b = bar(days,temp);%绘柱状图，赋值图形句柄给b
yyaxis left%控制右纵轴
p = plot(days,conc);%绘折线图，赋值图形句柄给p