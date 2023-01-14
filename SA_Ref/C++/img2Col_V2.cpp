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
    for(int Out_Row_Cnt=0;Out_Row_Cnt<Out_Feature_Size;Out_Row_Cnt++){
        for(int Out_Col_Cnt=0;Out_Col_Cnt<ceil(float(Out_Feature_Size/8));Out_Col_Cnt++){
            for(int Out_Channel_Cnt=0;Out_Channel_Cnt<Out_Channel/8;Out_Channel++){
                for(int Window_Row_Cnt=0;Window_Row_Cnt<Kernel_Size-1;Window_Row_Cnt++){
                    for(int Window_Col_Cnt=0;Window_Col_Cnt<16;Window_Col_Cnt++){//此For循环用来遍历滑动窗口的所有列，每一列对应8个输入通道
                        for(int SA_Row_Cnt=0;SA_Row_Cnt<8;SA_Row_Cnt++){//此For循环用来遍历SA的所有行，每个循环向SA的一行写入8个点
                            Data_Out=mem[Row_Base_Addr+KernelAddr+Window_Col_Cnt];
                            KernelAddr+=Stride;//向SA的第一行输出了8个点，接下来向SA的第二行输出8个点。
                        }
                        KernelAddr=Kernel_Base_Addr;
                        //当前行，当8个滑动窗口一行的的一个点都输完了，更新卷积核的起始地址，卷积核的地址重新基地址开始。
                    }
                    Update_RowBaseAddr(Window_Row_Cnt+1);
                    //8个滑动窗口的一行输出完了，接着输出下一行，要获取下一行的数据，需要修改行的基地址
                }
                KernelAddr=Kernel_Base_Addr;//更新卷积核的相对地址，从头开始
            }
            Kernel_Base_Addr+=8*16;//8个滑动窗口同时向后移动
        }
        Kernel_Base_Addr=0;//又从每一行的第一个点开始，所以卷积核的基地址需要归零
    }
}