%% 构建随机矩阵，一下选1列的8行数据进行输出
Matrix_B=zeros(163,40);
Row=size(Matrix_B,1);
Col=size(Matrix_B,2);
Matrix_B=randi([0,255],Row,Col)
Matrix_B=[Matrix_B;zeros(5,40)];
fid_raw_W=fopen('MatrixData.txt','w');
for i=1:8:size(Matrix_B,1)
    for j=1:size(Matrix_B,2)
        
        Matrix_Flattened=Matrix_B(i:i+7,j);%fliplr(');
        fprintf(fid_raw_W,'%02x%02x%02x%02x%02x%02x%02x%02x\n',Matrix_Flattened(8),Matrix_Flattened(7),Matrix_Flattened(6),Matrix_Flattened(5),Matrix_Flattened(4),Matrix_Flattened(3),Matrix_Flattened(2),Matrix_Flattened(1));%低位第一个点，高位第二个点，
    end
end
fclose(fid_raw_W);
dec2hex(Matrix_B(1:8,1));