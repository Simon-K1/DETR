%% 生成每一轮的输出数据
clear
clc
% load('保存的matlab数据\第一版随机输入数据.mat','Frature_In');
load('matlab.mat')
fid=fopen('MatrixA输入.txt','w');
%% ============开关（只改这里）===========
Compare_By_Row=1;%逐行对比，如果关闭就是直接生成全部的对比数据
Compare_Row=1;%需要修改
%% =======================================

Row_Base_Addr=0;
if ~Compare_By_Row
    Compare_Row=Out_Row;
end
%% =======================================
Present_Row=1;
for Out_Row_Cnt=1:Compare_Row
    %每次开始前需要初始化
    Out_Row_Cnt
    Kernel_Base_Addr=1;
    Kernel_Addr=1;
    Out_Col_Lefted=Out_Col;%112
    Window_Col_BaseAddr=0;%滑动窗口列 基地址
    if Compare_By_Row
        fprintf(fid,'===========OutPut Row %d==========\n',Out_Row_Cnt);%低位第一个点，高位第二个点，
    end
    for Out_Col_Cnt=1:ceil(Out_Col/Height)%112/8=14 每次的8个滑窗能出输出的8列 112列需要14次
        for Out_Channel_Cnt=1:ceil(Out_Channel/Height)%每次是8个滑动窗口和8个卷积核做运算 64个卷积核需要8次循环
            for Window_Row_Cnt=1:KernelSize
                for Window_Col_Cnt=1:KernelSize
                    for InChannel_Process_Cnt=1:Feature_Channel/8
                        for SA_Cnt=1:8

                            OutPut=Feature_In_padding(Window_Row_Cnt+Row_Base_Addr,Kernel_Addr:Kernel_Addr+8-1);
                            OutPut_HexFormat=fliplr(OutPut);%以十六进制的格式输出，第一个通道的点放[7:0],第二个通道的点放[15:8]...
                            Kernel_Addr=Kernel_Addr+Stride*Feature_Channel;
                            if Compare_By_Row
                                if Compare_Row==Present_Row
                                      fprintf(fid,'%02x%02x%02x%02x%02x%02x%02x%02x\n',OutPut_HexFormat);
                                end
                            else
                                  fprintf(fid,'%02x%02x%02x%02x%02x%02x%02x%02x\n',OutPut_HexFormat);
                            end

                            if SA_Cnt==Out_Col_Lefted
                                break
                            end
                        end
                        Kernel_Addr=Kernel_Base_Addr+InChannel_Process_Cnt*8+(Window_Col_Cnt-1)*Feature_Channel;
                    end
                    Kernel_Addr=Kernel_Base_Addr+Window_Col_Cnt*Feature_Channel;
                end
                Kernel_Addr=Kernel_Base_Addr;%从新的一行开始，卷积核地址复位
            end

        end
        Out_Col_Lefted=Out_Col_Lefted-8;%
        Kernel_Base_Addr=Kernel_Base_Addr+8*Feature_Channel*Stride;%下一组滑动窗口的基地址
        Kernel_Addr=Kernel_Base_Addr;
    end
    Row_Base_Addr=Row_Base_Addr+Stride;%更新行基地址 一行输出完
    Present_Row=Present_Row+1;
end
fclose(fid);



%% 测试工具

addr=[16:31]*224*32/8;
addr=addr';

Test=[152	255	174	160	139	250	112	158]%aa(4,:)
reshape(dec2hex(fliplr(Test))',1,[])
