clear
load("保存的权重矩阵\V1\matlab.mat")
%% 查看权重矩阵所占资源(KB)
fprintf("权重数据所占资源数量:%d KB\n",Row*Col/1024)


%% 生成仿真txt
%权重也按通道优先展开,列优先存储
%先将权重矩阵展平
Matrix_Flattened=reshape(WeightMatrix,1,[]);%按列优先展平
fid_raw_W=fopen('WeightData.txt','w');
Shape=size(Matrix_Flattened);
 for i=8:8:Shape(2)
  %通道按从低往高排列，比如第一个通道的点放最低位
  fprintf(fid_raw_W,'%02x%02x%02x%02x%02x%02x%02x%02x\n',Matrix_Flattened(i),Matrix_Flattened(i-1),Matrix_Flattened(i-2),Matrix_Flattened(i-3),Matrix_Flattened(i-4),Matrix_Flattened(i-5),Matrix_Flattened(i-6),Matrix_Flattened(i-7));%低位第一个点，高位第二个点，
 end
fclose(fid_raw_W);