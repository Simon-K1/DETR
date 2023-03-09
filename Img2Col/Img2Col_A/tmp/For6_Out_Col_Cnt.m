%% 第二层Window_Col_Cnt for循环
clear
clc
load('保存的图片矩阵\V1\matlab.mat');
In_Col=224;
In_Row=224;
In_Channel=Feature_Channel;
Stride=16;
KernelSize=16;

Compute_OutChannel=8;%每次计算的输出通道,
Compute_OutCol=8;%每次计算的输出列数

Row_Base_Addr=0;%行基地址
Kernel_Base_Addr=0;
Kernel_Addr=0;

Out_Channel=32;
Out_Col=14;
Out_Row=14;
Out_Col_Lefted=Out_Col;
for Out_Row_Cnt=1:2%Out_Row
    fprintf('========================Out_Row_Cnt[%d]================================\n',Out_Row_Cnt)
    %每次开始前需要初始化
    Kernel_Base_Addr=0;
    Kernel_Addr=0;
    Out_Col_Lefted=Out_Col;
    for Out_Col_Cnt=1:ceil(Out_Col/Compute_OutCol)
        for Out_Channel_Cnt=1:Out_Channel/Compute_OutChannel
            for Window_Row_Cnt=1:KernelSize
                fprintf('========================New Window_Row================================\n')
                for Window_Col_Cnt=1:In_Channel:In_Channel*KernelSize
                    fprintf('========Out_Channel_Cnt-[%d] Row-[%d] Col-[%d]=========\n',Out_Channel_Cnt,Window_Row_Cnt-1,(Window_Col_Cnt-1)/3)
                    for SA_Cnt=1:8%遍历脉动阵列的每一行（这里我们的SA一共有8行，得遍历8次)
                        OutPut=Frature_In(Window_Row_Cnt+Row_Base_Addr,Window_Col_Cnt+Kernel_Addr:Window_Col_Cnt+Kernel_Addr+2);
                        OutPut_HexFormat=fliplr(OutPut);%以十六进制的格式输出，第一个通道的点放[7:0],第二个通道的点放[15:8]...
                        OutPut_HexFormat=reshape(dec2hex(OutPut_HexFormat)',1,[]);%这里记得转置一下
                        Kernel_Addr=Kernel_Addr+KernelSize*In_Channel;
                        fprintf('SA_Row_Index[%d]:%02s\n',SA_Cnt-1,OutPut_HexFormat)
                        if SA_Cnt==Out_Col_Lefted
                            break
                        end
                    end
                    Kernel_Addr=Kernel_Base_Addr;
                end
            end
        end
        Out_Col_Lefted=Out_Col_Lefted-8;
        Kernel_Base_Addr=Kernel_Base_Addr+8*In_Channel*KernelSize;
        Kernel_Addr=Kernel_Base_Addr;
    end
    Row_Base_Addr=Row_Base_Addr+Stride;%更新行基地址
end
Test=[102	59	152]
reshape(dec2hex(fliplr(Test))',1,[])