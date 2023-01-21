#include"stdio.h"
#include"cmath"
void Update_RowBaseAddr(int NextRow){
    printf("Row_Base_Addr已被修改为第%d行行的起始地址\n",NextRow);
}
int main(){
    int Out_Feature_Size=14;
    int Out_Channel=768;
    int Kernel_Size=16;
    int mem[512];
    int Data_Out=0;
    int Row_Base_Addr=0;//当前行起始地址
    
    int Stride=16;
    int Kernel_Base_Addr=0;//卷积核的基地址
    int KernelAddr=Kernel_Base_Addr;//卷积核相对地址，应该用一个寄存器来存
    // float a=14;
    // float b=8;
    // int ceil_ans=ceil(a/b);
    // printf("%d",ceil_ans);
    int OutFeature_Col_Lefted=14;//一个计数器，用来计数这输出特征图一行中还剩多少列没计算完
        //举个栗子：比如我们这里的输出特征图一行是14个点，但是我们的脉动阵列有8行，从第一行开始填充数据，一直填到第8行，
        //当输出特征图的一个8个点算完了，还剩下6个点，所以这时我们只需填充脉动阵列的1~6行，剩下两行就不理他了，这样又可以节省两行的时间。
        //通过这个我们就可以处理输出特征图的冗余，具体看猪皮特的图一
    for(int Out_Row_Cnt=0;Out_Row_Cnt<Out_Feature_Size;Out_Row_Cnt++){
        // printf("%d\n",Out_Row_Cnt);
        for(int Out_Col_Cnt=0;Out_Col_Cnt<2;Out_Col_Cnt++){//(int)ceil(float(Out_Feature_Size)/(float)(8))
            printf("[%d-%d]\n",Out_Row_Cnt,Out_Col_Cnt);
            for(int Out_Channel_Cnt=0;Out_Channel_Cnt<Out_Channel/8;Out_Channel++){
                for(int Window_Row_Cnt=0;Window_Row_Cnt<Kernel_Size;Window_Row_Cnt++){
                    for(int Window_Col_Cnt=0;Window_Col_Cnt<16;Window_Col_Cnt++){//此For循环用来遍历滑动窗口的所有列，每一列对应8个输入通道
                        for(int SA_Row_Cnt=0;SA_Row_Cnt<8;SA_Row_Cnt++){//此For循环用来遍历SA的所有行，每个循环向SA的一行写入8个点
                            Data_Out=mem[Row_Base_Addr+KernelAddr+Window_Col_Cnt];
                            KernelAddr+=Stride;//向SA的第一行输出了8个点，接下来向SA的第二行输出8个点。
                            OutFeature_Col_Lefted--;
                            if(OutFeature_Col_Lefted==0){
                                break;
                            }
                        }
                        KernelAddr=Kernel_Base_Addr;
                        //当前行，当8个滑动窗口一行的的一个点都输完了，更新卷积核的起始地址，卷积核的地址重新基地址开始。
                    }
                    OutFeature_Col_Lefted=14;//归位，每一行都重新算列数。
                    //Update_RowBaseAddr(Window_Row_Cnt+1);
                    //8个滑动窗口的一行输出完了，接着输出下一行，要获取下一行的数据，需要修改行的基地址
                    KernelAddr=Kernel_Base_Addr;//更新卷积核的相对地址，从头开始
                    //应该是遍历完8个滑动窗口的全部行后就更新KernelAddr
                }
                
            }
            Kernel_Base_Addr+=8*16;//8个滑动窗口同时向后移动
        }
        
        Kernel_Base_Addr=0;//又从每一行的第一个点开始，所以卷积核的基地址需要归零
    }
    printf("for 循环次数：%d",Out_Feature_Size*2*Out_Channel/8*Kernel_Size*16*8);

            
}
