%% 单独仿真SA
clear

SA_Row=8;%脉动阵列行数
SA_Col=8;%脉动阵列列数
Matrix_A=zeros(SA_Row,16*16*3);%创建脉动阵列的左输入测试数据
Matrix_B=zeros(SA_Col,16*16*3);%创建脉动阵列的上输入测试数据


Row=size(Matrix_A,1);
Col=size(Matrix_A,2);
for row=1:Row%遍历矩阵所有行
    Row_Data=rand(1,Col)*5;
    Row_Data_Outer=(Row_Data>255)*5;%将大于255的数变成255
    Row_Data_Inner=Row_Data.*(Row_Data<=5);%将小于255的数保留
    Row_Data=Row_Data_Outer+Row_Data_Inner;
    Row_Data=round(Row_Data);
    Matrix_A(row,:)=Row_Data;
end

Row=size(Matrix_B,1);
Col=size(Matrix_B,2);
for row=1:Row%遍历矩阵所有行
    Row_Data=rand(1,Col)*5;
    Row_Data_Outer=(Row_Data>255)*5;%将大于255的数变成255
    Row_Data_Inner=Row_Data.*(Row_Data<=5);%将小于255的数保留
    Row_Data=Row_Data_Outer+Row_Data_Inner;
    Row_Data=round(Row_Data);
    Matrix_B(row,:)=Row_Data;
end

Matrix_C=Matrix_A*Matrix_B';


