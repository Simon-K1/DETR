import torch
import torch.nn as nn
import numpy as np
Cfg=dict(
    Gen_Picture_Wei_Output=False#是否生成权重和图
)
Wq=torch.randint(0,10,(64,32,3,3),dtype=torch.float)
Xq=torch.randint(0,10,(1,32,322,322),dtype=torch.float)
# Xq=torch.rand(1,32,322,322)
ConvLayer=nn.Conv2d(32,64,3,bias=False)
ConvLayer.weight.data=Wq
Output=ConvLayer(Xq)
print(Output.shape)
if Cfg['Gen_Picture_Wei_Output']:
    with open (r'E:\Transformer\Transformer_Arithmatic\Transformer_Main\TxT\Weight.txt','w') as ff:
        #Wq的维度：[OC,IC,K,K]
        for OC in range(Wq.shape[0]):#遍历全部输出通道
            for K_Row in range(Wq.shape[2]):#遍历行
                for K_Col in range(Wq.shape[3]):#遍历列
                    for IC in range(0,Wq.shape[1],8):#遍历通道
                        Hex0=int(Wq[OC,IC,  K_Row,K_Col].item())&0xff
                        Hex1=int(Wq[OC,IC+1,K_Row,K_Col].item())&0xff
                        Hex2=int(Wq[OC,IC+2,K_Row,K_Col].item())&0xff
                        Hex3=int(Wq[OC,IC+3,K_Row,K_Col].item())&0xff
                        Hex4=int(Wq[OC,IC+4,K_Row,K_Col].item())&0xff
                        Hex5=int(Wq[OC,IC+5,K_Row,K_Col].item())&0xff
                        Hex6=int(Wq[OC,IC+6,K_Row,K_Col].item())&0xff
                        Hex7=int(Wq[OC,IC+7,K_Row,K_Col].item())&0xff
                        #print('%02x%02x%02x%02x%02x%02x%02x%02x'%(Hex7,Hex6,Hex5,Hex4,Hex3,Hex2,Hex1,Hex0))
                        ff.write('%02x%02x%02x%02x%02x%02x%02x%02x'%(Hex7,Hex6,Hex5,Hex4,Hex3,Hex2,Hex1,Hex0))
                        ff.write("\n")
        ff.close()
    with open (r'E:\Transformer\Transformer_Arithmatic\Transformer_Main\TxT\picture.txt','w') as ff:
        #Wq的维度：[OC,IC,K,K]
        for Row in range(Xq.shape[2]):#遍历行
            print(Row)
            for Col in range(Xq.shape[3]):#遍历列
                for IC in range(0,Xq.shape[1],8):#遍历通道
                    Hex0=int(Xq[0,IC,  Row,Col].item())&0xff
                    Hex1=int(Xq[0,IC+1,Row,Col].item())&0xff
                    Hex2=int(Xq[0,IC+2,Row,Col].item())&0xff
                    Hex3=int(Xq[0,IC+3,Row,Col].item())&0xff
                    Hex4=int(Xq[0,IC+4,Row,Col].item())&0xff
                    Hex5=int(Xq[0,IC+5,Row,Col].item())&0xff
                    Hex6=int(Xq[0,IC+6,Row,Col].item())&0xff
                    Hex7=int(Xq[0,IC+7,Row,Col].item())&0xff
                    #print('%02x%02x%02x%02x%02x%02x%02x%02x'%(Hex7,Hex6,Hex5,Hex4,Hex3,Hex2,Hex1,Hex0))
                    ff.write('%02x%02x%02x%02x%02x%02x%02x%02x'%(Hex7,Hex6,Hex5,Hex4,Hex3,Hex2,Hex1,Hex0))
                    ff.write("\n")
        ff.close()

Output_Reshape1=torch.permute(Output,[0,2,3,1])
Output_Reshape2=torch.reshape(Output_Reshape1,[-1])
Output_Reshape3 = Output_Reshape2.detach().numpy()
int_output= Output_Reshape3.astype(np.int)
print(int_output.dtype)
# exit()
    #Wq的维度：[OC,IC,K,K]
ff=open (r'E:\Transformer\Transformer_Arithmatic\Transformer_Main\TxT\OutPut.bin','w')
int_output.tofile(ff)
ff.close()

ftxt = open(r'E:\Transformer\Transformer_Arithmatic\Transformer_Main\TxT\Output.txt', "w")  # 打开fp1 ab+追加写入
for Row in range(Output.shape[2]):#遍历行
    print(Row)
    for Col in range(Output.shape[3]):#遍历列
        for IC in range(Output.shape[1]):#遍历通道
            #ff.write('%08x'%(int(Output[0,IC,  Row,Col].item())&0xffffffff))#写成bin文件
            ftxt.write('%08x\n'%(int(Output[0,IC,  Row,Col].item())&0xffffffff))
ftxt.close()

                
