% 指定文件夹路径
folder = 'E:\Transformer\Spinal\OnBoard\1_8_8_32_5_288\tcl';

% 获取文件夹中的所有 txt 文件
fileList = dir(fullfile(folder, '*.tcl'));

% 创建一个空字符串来保存合并后的文本
mergedText = '';
% 将合并后的文本保存到一个新的文件中
outputFilePath = fullfile(folder, '合并后的文件.txt');
fid = fopen(outputFilePath, 'w');
% 循环遍历每个文件并将其内容合并到 mergedText 中
for i = 1:numel(fileList)
    filePath = fullfile(folder, fileList(i).name);
    fileContent = fileread(filePath);
    fprintf(fid, '%s\n', fileContent);
end
fclose(fid);