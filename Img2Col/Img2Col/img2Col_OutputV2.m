%% 前5层for循环txt输出
clear
load('保存的matlab数据\第一版随机输入数据.mat','Frature_In');
In_Col=224;
In_Row=224;
Stride=16;
KernelSize=16;
In_Channel=3;
Out_Channel=768;
Compute_OutChannel=8;%每次计算的输出通道
Row_Base_Addr=0;%行基地址
Kernel_Base_Addr=0;
Kernel_Addr=0;
Out_Col=14;
Out_Col_Lefted=Out_Col;
fid=fopen('Img2Col_Txt\img2Col第一版输出数据.txt','w');
for Out_Col_Cnt=1:2
    for Out_Channel_Cnt=1:Out_Channel/Compute_OutChannel
        Out_Channel_Cnt
        for Window_Row_Cnt=1:KernelSize
%             fprintf('========================New Col================================\n')
            for Window_Col_Cnt=1:In_Channel:In_Channel*KernelSize
%                 fprintf('========Row-[%d] Col-[%d]=========\n',Window_Row_Cnt-1,(Window_Col_Cnt-1)/3)
                for SA_Cnt=1:8
                    OutPut=Frature_In(Window_Row_Cnt,Window_Col_Cnt+Kernel_Addr:Window_Col_Cnt+Kernel_Addr+2);
                    OutPut_HexFormat=fliplr(OutPut);%以十六进制的格式输出，第一个通道的点放[7:0],第二个通道的点放[15:8]...
                    OutPut_HexFormat=reshape(dec2hex(OutPut_HexFormat)',1,[]);%这里记得转置一下
                    Kernel_Addr=Kernel_Addr+KernelSize*In_Channel;
                    fprintf(fid,'0000000000%s\n',lower(OutPut_HexFormat));%低位第一个点，高位第二个点，
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
fclose(fid);
Test=[102	59	152]
reshape(dec2hex(fliplr(Test))',1,[])