function [InFeatureSize,OutFeatureSize] = BuildPicture(Feature_Size,Feature_Channel,Out_Channel,KernelSize,Stride)
%UNTITLED7 就是输入卷积步长，卷积核大小，然后自动推理出输入和输出图片的大小（来自Step1）
    Drop_Message=1;%将图片继续补零以匹配卷积不丢失信息
    assert(Stride<=KernelSize,"Stride must be less than kernelSize");
    OutFeatureSize=75;%无需修改，在后面自动推理出来
    assert(mod(Feature_Channel,8)==0,"输入通道必须是8的倍数");
    assert(mod(Out_Channel,8)==0,"输出通道必须是8的倍数");
    %Strdie1
    InFeatureSize=Feature_Size;
    if Stride==KernelSize
    %     OutFeatureSize=Feature_Size/KernelSize;
        if(mod(Feature_Size,KernelSize)==0)
            OutFeatureSize=Feature_Size/KernelSize;
        else
    %         fprintf("Error:kernelSize必须和FeatureSize匹配\n")
            InFeatureSize=ceil(Feature_Size/KernelSize)*KernelSize;
            OutFeatureSize=ceil(Feature_Size/KernelSize);
            warning('警告:kernelSize必须和FeatureSize没有匹配\n')
        end
    else 
        if Stride==1
        OutFeatureSize=size(1:Feature_Size-KernelSize+1,2);
        else 
            Tmp=1:Stride:Feature_Size;
            if ~Drop_Message%若不丢失信息，继续补零
                if(Tmp(end)~=Feature_Size)
                    Feature_Size=Tmp(end)+KernelSize-1%修改图片大小
                    InFeatureSize=Feature_Size;
                end
            else%若丢失信息，则修改输出图片大小
                %说明：比如3*3卷积，步长为2，输入图片322*322，
                    %对于3*3的步长为2的卷积来说是无法覆盖全部图片的（321*321->160*160,323*323->161*161)
                    %这里就是将322*322的图片变成321*321的图片，得到160*160的输出。
                    %上面就是将322*322的图片变成323*323的图片，得到161*161的输出。
                %do nothing
            end
            OutFeatureSize=size(Tmp,2)-1
        end
    end
end