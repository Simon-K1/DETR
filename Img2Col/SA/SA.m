%% 单独仿真SA
clear

SA_Row=8;%脉动阵列行数
SA_Col=8;%脉动阵列列数
Matrix_A=zeros(SA_Row,16*16*3);%创建脉动阵列的左输入测试数据
Matrix_B=zeros(SA_Col,16*16*3);%创建脉动阵列的上输入测试数据


Row=size(Matrix_A,1);
Col=size(Matrix_A,2);


Row=size(Matrix_B,1);
Col=size(Matrix_B,2);
Matrix_B=randi([0,255],Row,Col)

Matrix_C=Matrix_A*Matrix_B';


