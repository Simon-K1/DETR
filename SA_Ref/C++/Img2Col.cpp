#include<iostream>
using namespace std;
int main(){
    int Data_In=0;
    int Waddr_Offset=0;//读地址偏移，初始化为0
    int mem[4096];
    for (int k=0;k<3-1;k++){//存储k行数据
        for(int Waddr=0;Waddr<224-1;Waddr++){//写入一行数据
            mem[Waddr+Waddr_Offset]=Data_In;
        }
        Waddr_Offset+=224;//写完一行，修改下一行的写地址偏移
    }
    //img2col展开
    int Stride=1;//步长为1
    int Data_Out=0;
    for(int Kernel_Addr=0;Kernel_Addr<(224-3)-1;Kernel_Addr+=Stride){//Kernel_Addr对于的是卷积滑动窗口top-left点的地址
        //分析↑：比如一个3*3的卷积，如果步长是1，那么3*3的卷积top-left的点对应的列地址应该是从0到(224-3)-1
        //分析↓：下面的两层循环用来控制卷积输出
        for(int Raddr=0;Raddr<3-1;Raddr++){//Raddr控制列
            for(int Row=0;Row<3-1;Row++){//获取一列用于卷积的数据，Row控制行
                Data_Out=Data_Out=mem[Raddr+224];
            }
        }
    }

}