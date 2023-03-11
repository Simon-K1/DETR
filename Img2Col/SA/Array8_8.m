%% 生成矩阵输入A txt,8*8阵列
fid_raw_W=fopen('Matrix_A.txt','w');

Shape=size(Matrix_A);
%由于一下进8个点也就是8个通道，需要通道补零
 for i=8:8:Shape(1)%竖着进3行数据
     for j=1:Shape(2)%遍历列
         InputData=Matrix_A(i-7:i,j);
         fprintf(fid_raw_W,'%02x%02x%02x%02x%02x%02x%02x%02x\n',InputData(8),InputData(7),InputData(6),InputData(5),InputData(4),InputData(3),InputData(2),InputData(1));
     end
 end
fclose(fid_raw_W);
%% 生成矩阵输入B txt
fid_raw_W=fopen('Matrix_B.txt','w');
InputMatrix_Hex=dec2hex(Matrix_B)
InputMatrix_Hex2Dec=reshape(hex2dec(InputMatrix_Hex),size(Matrix_B))
Shape=size(InputMatrix_Hex2Dec);
%由于一下进8个点也就是8个通道，需要通道补零
 for i=8:8:Shape(1)%竖着进3行数据
     for j=1:Shape(2)%遍历列
         InputData=InputMatrix_Hex2Dec(i-7:i,j);
         fprintf(fid_raw_W,'%02x%02x%02x%02x%02x%02x%02x%02x\n',InputData(8),InputData(7),InputData(6),InputData(5),InputData(4),InputData(3),InputData(2),InputData(1));
     end
 end
fclose(fid_raw_W);
% %% 生成有符号的矩阵输入B txt
% InputMatrix_Hex=dec2hex(Matrix_B)
% InputMatrix_Hex2Dec=reshape(hex2dec(InputMatrix_Hex),size(Matrix_B))