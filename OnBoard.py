#上板
import os
import torch
from models import *
import numpy as np
def Generate_Bin(Tensor,Type,Path):
    #生成权重和图片的bin文件
    #Tensor:输入的tensor
    #Type：可选：Image，ConvWeight，LinearWeight，ConvQuant
    #path:存储路径
    if not os.path.exists(Path):#如果文件夹不存在则创建
        os.makedirs(Path)
    if Type=="ImageIn":
        if Tensor.device.type=="cuda":
            Tensor=Tensor.to("cpu")
        Output_Reshape1=torch.permute(Tensor,[0,2,3,1])
        Output_Reshape2=torch.reshape(Output_Reshape1,[-1])
        Output_Reshape3 = Output_Reshape2.numpy()
        int_output= Output_Reshape3.astype(np.uint8)#转为int，因为之前的tensor是float
        print(int_output.dtype)
        ff=open (Path+"/ImageIn.bin",'w')
        int_output.tofile(ff)
        ff.close()
    elif Type=="ImageOut":
        if Tensor.device.type=="cuda":
            Tensor=Tensor.to("cpu")
        Output_Reshape1=torch.permute(Tensor,[0,2,3,1])
        Output_Reshape2=torch.reshape(Output_Reshape1,[-1])
        Output_Reshape3 = Output_Reshape2.numpy()
        int_output= Output_Reshape3.astype(np.uint8)#转为int，因为之前的tensor是float
        print(int_output.dtype)
        ff=open (Path+"/ImageOut.bin",'w')
        int_output.tofile(ff)
        ff.close()
    elif Type=="ConvWeight":
        if Tensor.device.type=="cuda":
            Tensor=Tensor.to("cpu")
        Output_Reshape1=torch.permute(Tensor,[0,2,3,1])
        Output_Reshape2=torch.reshape(Output_Reshape1,[-1])
        Output_Reshape3 = Output_Reshape2.numpy()
        int_output= Output_Reshape3.astype(np.uint8)#转为int，因为之前的tensor是float
        print(int_output.dtype)
        ff=open (Path+"/ConvWeight.bin",'w')
        int_output.tofile(ff)
        ff.close()
    elif Type=="ConvQuant":
        #Tensor=[Bias,Scale,Shift],注意这里的Bias,Scale,Shift均为Numpy
        Bias=Tensor[0].astype(np.uint32)
        Scale=Tensor[1].astype(np.uint32)
        Shift=Tensor[2].astype(np.uint32)
        ff=open (Path+"/ConvQuant.bin",'a')
        Bias.tofile(ff)
        Scale.tofile(ff)
        Shift.tofile(ff)
        ff.close()
    # elif Type=="ImageIn":#图片
    #     if Tensor.device.type=="cuda":
    #         Tensor=Tensor.to("cpu")
    #     assert(Tensor.shape[0]==1)#只能有一个Batch
    #     #输出的为四维图片tensor[B,C,H,W]，拿到这些数据后需要将其重新排列成二维矩阵格式[H,W,C]
    #     Tensor=Tensor.squeeze()#[C,H,W]
    #     Tensor=Tensor.permute(1,2,0).numpy()
    #     int_output= Tensor.astype(np.uint8)
    #     ff=open (Path+"/ImageIn.bin",'w')
    #     int_output.tofile(ff)
    #     ff.close()
    # elif Type=="ImageOut":#图片
    #     if Tensor.device.type=="cuda":
    #         Tensor=Tensor.to("cpu")
    #     assert(Tensor.shape[0]==1)#只能有一个Batch
    #     #输出的为四维图片tensor[B,C,H,W]，拿到这些数据后需要将其重新排列成二维矩阵格式[H,W,C]
    #     Tensor=Tensor.squeeze()#[C,H,W]
    #     Tensor=Tensor.permute(1,2,0).numpy()
    #     int_output= Tensor.astype(np.uint8)
    #     ff=open (Path+"/ImageOut.bin",'w')
    #     int_output.tofile(ff)
    #     ff.close()

def main():
    print("上板")
if __name__ == '__main__':



    main()