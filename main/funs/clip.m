function Matrix_Out = clip(Matrix_In,Lower,Upper)
%UNTITLED7 此处提供此函数的摘要
%   此处提供详细说明
Size=size(Matrix_In);
Matrix_In_Flattened=reshape(Matrix_In,1,[]);
Matrix_Out=zeros(size(Matrix_In_Flattened));
for i=1:size(Matrix_In_Flattened,2)
    if Matrix_In_Flattened(i)>Upper
        Matrix_Out(i)=Upper;
    else
        if Matrix_In_Flattened<Lower
            Matrix_Out(i)=Lower;
        else
            Matrix_Out(i)=Matrix_In_Flattened(i);
        end
    end
end
Matrix_Out=reshape(Matrix_Out,Size);
end

