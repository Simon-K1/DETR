%% 一些实用脚本
vector=[112
133
17
99
91
175
167
103]';
reshape(dec2hex(fliplr(vector))',1,[])

%% matlab读取txt转成图片
clear
fid=fopen('Picture.txt')
a=textscan(fid,'%s')%拿到每行数据--a:1,1的cell，a{1,1}:2028*1的cell，a{1,1}{1,1}直接提取，但是不能a{1,1}(1,1){1,1}
%提取cell数组---反正就是对于cell就要用{}
fclose(fid);
Single_Line_Dec=zeros(1,2);%代表2个字节
Data_Decimal=zeros(size(a{1,1},1),2);%a{1,1}为txt中所有的行
for i=1:size(a{1,1})
    Single_Line_Hex=a{1,1}{i,1};%i行1列，元组格式
    for j=1:2%第一步：先整理成左高右低的格式，按字节编码
        Single_Line_Dec(j)=hex2dec(['0x',Single_Line_Hex(2*j-1:2*j),'s8']);
    end    
    Data_Decimal(i,:)=Single_Line_Dec;
end