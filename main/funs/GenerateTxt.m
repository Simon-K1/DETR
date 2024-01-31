function [outputArg1,outputArg2] = GenerateTxt(PreFix)
    fid=fopen(PreFix+".bin","r");
    data=fread(fid);
    fclose(fid);
    data=reshape(data,8,[]);
    fid=fopen(PreFix+".txt",'w');
    for i=1:size(data,2)
        fprintf(fid,"%02x%02x%02x%02x%02x%02x%02x%02x\n",fliplr(data(:,i)'));
    end
    fclose(fid);

end