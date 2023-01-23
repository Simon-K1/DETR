In_Col=224;
In_Row=224;
Stride=16;
KernelSize=16;
In_Channel=3;
Row_Base_Addr=0;%行基地址
Kernel_Base_Addr=0;
Kernel_Addr=0;
Out_Col=14;
Out_Col_Lefted=Out_Col;
fid=fopen('Img2Col_Txt\img2Col第一版输出数据.txt','w');
for Out_Row_Cnt=1:14
    for Out_Col_Cnt=1:2%这地方卡了一天，，，，把14改成2就行了，bl dog.
        for Out_Channel_Cnt=1:96
            for Window_Row_Cnt=1:16
                for Window_Col_Cnt=1:16
                    for SA_Cnt=1:8
                        OutPut=Frature_In(Window_Row_Cnt+Row_Base_Addr,Window_Col_Cnt+Kernel_Addr:SA_Cnt+Kernel_Addr+2);
                        fprintf(fid,'%02x%02x%02x%02x%02x%02x%02x%02x\n',0,0,0,0,0,OutPut(3),OutPut(2),OutPut(1));%低位第一个点，高位第二个点，
                        Kernel_Addr=Kernel_Addr+KernelSize*In_Channel;%先第一个滑动窗口的第一行第一列的点，然后是第二个滑动窗口第一行第一列的点，以此类推
                        if SA_Cnt==Out_Col_Lefted
                            break
                        end
                    end
                    Kernel_Addr=Kernel_Base_Addr+1;%遍历完8个滑动窗口的一个点后，再遍历下一个点，地址得加一
                end
                Kernel_Addr=Kernel_Base_Addr;%遍历完滑动窗口的一行后也要复位
            end
            Kernel_Addr=Kernel_Base_Addr;%拿到一个完整的输出通道，还要重新复用这8个滑动窗口，所以卷积核的地址要复位
        end
        Kernel_Base_Addr=Kernel_Base_Addr+KernelSize*In_Channel*8;
    end
    Row_Base_Addr=Row_Base_Addr+Stride;
    Kernel_Base_Addr=0;%拿到一行完整的输出矩阵，卷积核基地址复位
    Out_Col_Lefted=Out_Col_Lefted-8;
end
fclose(fid_raw_W);


