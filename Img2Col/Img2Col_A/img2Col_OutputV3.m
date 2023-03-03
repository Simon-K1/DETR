%% 生成每一轮的输出数据
clear
clc
% load('保存的matlab数据\第一版随机输入数据.mat','Frature_In');
load('matlab.mat')
fid=fopen('C:\Users\25073\Desktop\compare\Matlab输出数据.txt','w');
%% =======================================
Compare_By_Row=1;%逐行对比，如果关闭就是直接生成全部的对比数据
Compare_Row=1;

if ~Compare_By_Row
    Compare_Row=Out_Row;
end
%% =======================================
Present_Row=1;
for Out_Row_Cnt=1:Compare_Row
    %每次开始前需要初始化
    Out_Row_Cnt
    Kernel_Base_Addr=0;
    Kernel_Addr=0;
    Out_Col_Lefted=Out_Col;
    if Compare_By_Row
        fprintf(fid,'===========OutPut Row %d==========\n',Out_Row_Cnt);%低位第一个点，高位第二个点，
    end
    for Out_Col_Cnt=1:2
        for Out_Channel_Cnt=1:Out_Channel/Compute_OutChannel
            for Window_Row_Cnt=1:KernelSize
                %             fprintf('========================New Col================================\n')
                for Window_Col_Cnt=1:8:Feature_Channel*KernelSize
                    %                 fprintf('========Row-[%d] Col-[%d]=========\n',Window_Row_Cnt-1,(Window_Col_Cnt-1)/3)
                    for SA_Cnt=1:8
                        OutPut=Feature_In(Window_Row_Cnt+Row_Base_Addr,Window_Col_Cnt+Kernel_Addr:Window_Col_Cnt+Kernel_Addr+8-1);
                        OutPut_HexFormat=fliplr(OutPut);%以十六进制的格式输出，第一个通道的点放[7:0],第二个通道的点放[15:8]...
                        OutPut_HexFormat=reshape(dec2hex(OutPut_HexFormat)',1,[]);%这里记得转置一下
                        Kernel_Addr=Kernel_Addr+KernelSize*Feature_Channel;
                        if Compare_By_Row
                            if Compare_Row==Present_Row
                                fprintf(fid,'%016s\n',lower(OutPut_HexFormat));%低位第一个点，高位第二个点，
                            end
                        else
                            fprintf(fid,'%016s\n',lower(OutPut_HexFormat));%低位第一个点，高位第二个点，
                        end
                 
                        if SA_Cnt==Out_Col_Lefted
                            break
                        end
                    end
                    Kernel_Addr=Kernel_Base_Addr;
                end
            end
        end
        Out_Col_Lefted=Out_Col_Lefted-8;
        Kernel_Base_Addr=Kernel_Base_Addr+8*Feature_Channel*Stride;
        Kernel_Addr=Kernel_Base_Addr;
    end
    Row_Base_Addr=Row_Base_Addr+Stride;%更新行基地址
    Present_Row=Present_Row+1;
end
fclose(fid);
Test=[138	7	109]
reshape(dec2hex(fliplr(Test))',1,[])