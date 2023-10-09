%% 生成矩阵输入A txt,3*3阵列
fid_raw_W=fopen('SA_TestDAta\V3\Matrix_A.txt','w');

Shape=size(Matrix_A);
%由于一下进8个点也就是8个通道，需要通道补零
 for i=3:3:Shape(1)%竖着进3行数据
     for j=1:Shape(2)%遍历列
         InputData=Matrix_A(i-2:i,j);
         fprintf(fid_raw_W,'%02x%02x%02x\n',InputData(3),InputData(2),InputData(1));
     end
 end
fclose(fid_raw_W);
%% 生成矩阵输入B txt
fid_raw_W=fopen('SA_TestDAta\V3\Matrix_B.txt','w');

Shape=size(Matrix_B);
%由于一下进8个点也就是8个通道，需要通道补零
 for i=3:3:Shape(1)%竖着进3行数据
     for j=1:Shape(2)%遍历列
         InputData=Matrix_B(i-2:i,j);
         fprintf(fid_raw_W,'%02x%02x%02x\n',InputData(3),InputData(2),InputData(1));
     end
 end
fclose(fid_raw_W);

%% 