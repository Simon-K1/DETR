#include<iostream>
using namespace std;
void Fifo_Update(int *,char*){
    cout<<"Fifo loop over"<<endl;
}
int main(){
    int Data_In=0;
    int Waddr_Offset=0;//读地址偏移，初始化为0
    int mem[4096];//也就是32kb的Bram
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
        for(int Raddr=Kernel_Addr;Raddr<3-1;Raddr++){//Raddr控制列
            for(int Row=0;Row<3-1;Row++){//获取一列用于卷积的数据，Row控制行
                Data_Out=mem[Raddr+224];
            }
        }
    }

    cout<<"fuck"<<endl;


    //先解决步长循环
    //如果步长为1，0~k回环
        //0,1,2...k-1 -> 1,2,...k -> ... ->k,0,...k-2(0~k-2有k-1行，再加一个k就是k行)->0,1,2...k-1->...循环
    int Row_Read_Index[32];//这可以认为是一个fifo，比如k=3，也就是卷积核大小为3，那么先向fifo中写入0，1，2，3
                            //然后从fifo中读0，读出来的0对应当前的行index，也就是第0行
                            //读出的0还要写回fifo中，这样就形成了行index的回环
                            //以此类推，可以通过Row_Read_Index控制Bram的读写地址
                        //-------------------------------------------------------------------
                            //Row_Read_Index=0,读地址为0，第0行第0个点
                            //Row_Read_Index=1,读地址为224，第1行第0个点
                            //以此类推:012,123,230,301,012...
                        //于是,这个Row_Read_Index中存的可以是读起始地址,0,224,224*2,224*3...
    //关键是复用Bram地址空间，，，啊啊啊痛苦
    //每处理一行（输出数据）后读写地址偏移都要改变
    int Out_Feature_Size=14;//输出特征图的大小
    int Kernel_Size=16;//卷积核大小为16
    Stride=16;//步长为16
    int In_Feature_Size=224;//输入特征图大小（未padding)----我艹，还tm要padding
    int In_Feature_Size_Padded=224;//补零之后的特征图大小---暂时先不考虑补零
    const bool Row_Unroll=true;//卷积滑动窗口按行展开
                                //这里很重要,需要确定滑动窗口是按行展开还是按列展开,因为需要和后面算卷积对应起来
                                //按行展开叭
    for(int Out_Row=0;Out_Row<Out_Feature_Size;Out_Row++){//对于输出特征图的每一行来说,假如后面的数据已经被缓存了，直接执行img2col
        for(int Kernel_Addr=0;Kernel_Addr<(In_Feature_Size-Kernel_Size)-1;Kernel_Addr+=Stride){
            //Kernel_Addr对于的是卷积滑动窗口top-left点的相对地址(注意是相对地址,后面读写时相对地址加上地址偏移就是绝对地址)
            for(int Window_Row=0;Window_Row<Kernel_Size;Window_Row++){//滑动窗口的行循环,比如kernel_size=16,需要循环16次
                                                                        //剩下的内部循环用于行展开
                int Raddr=Kernel_Addr+Row_Read_Index[0];
                for(int Window_Col=0;Window_Col<Kernel_Size;Window_Col++){
                    Data_Out=mem[Raddr];    
                    Raddr++;
                }
                Fifo_Update(Row_Read_Index,"Read");//出完一行的3个点后,继续出下一行的三个点
                                            //要出下一行的3个点,那么读地址要变,而读地址由Row_Read_Index控制          
                //将来可以在HLS上实现      
            }
        }
    }

    //现在想想写数据怎么处理,最终实现读写并行
    int Row_Write_OffSet[32];
    for(int In_Row=0;In_Row<In_Feature_Size;In_Row++){
        //入数据行计数器
        int Waddr=Row_Write_OffSet[0];//循环写
        for(int In_Col=0;In_Col<In_Feature_Size;In_Col++){
            //入数据列计数器
            mem[Waddr+In_Col]=Data_In;
        }
        Fifo_Update(Row_Write_OffSet,"Write");
            
    }
}