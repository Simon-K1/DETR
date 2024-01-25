#上板
import torch
from models import *
import numpy as np
def Generate_Bin(Tensor,Type,Path):
    #生成权重和图片的bin文件
    #Tensor:输入的tensor
    #Type：可选：Image，ConvWeight，LinearWeight，QuantData
    #path:存储路径
    if Type=="Image":
        Output_Reshape1=torch.permute(Tensor,[0,2,3,1])
        Output_Reshape2=torch.reshape(Output_Reshape1,[-1])
        Output_Reshape3 = Output_Reshape2.numpy()
        int_output= Output_Reshape3.astype(np.uint8)#转为int，因为之前的tensor是float
        print(int_output.dtype)
        ff=open (Path+"/Image.bin",'w')
        int_output.tofile(ff)
        ff.close()
    elif Type=="ConvWeight":
        Output_Reshape1=torch.permute(Tensor,[0,2,3,1])
        Output_Reshape2=torch.reshape(Output_Reshape1,[-1])
        Output_Reshape3 = Output_Reshape2.numpy()
        int_output= Output_Reshape3.astype(np.uint8)#转为int，因为之前的tensor是float
        print(int_output.dtype)
        ff=open (Path+"ConvWeight.bin",'w')
        int_output.tofile(ff)
        ff.close()
def main():
    print("上板")
if __name__ == '__main__':



    main()