# Copyright (c) MEGVII Inc. and its affiliates. All Rights Reserved.
import math
import numpy as np
import torch
import torch.nn as nn
from torch.nn import functional as F
import matplotlib.pyplot as plt
from .bit_type import BIT_TYPE_DICT
from .observer import build_observer
from .quantizer import build_quantizer
import struct
import scipy.io as sio
class QConv2d(nn.Conv2d):

    def __init__(self,
                 in_channels,
                 out_channels,
                 kernel_size,
                 stride=1,
                 padding=0,
                 dilation=1,
                 groups=1,
                 bias=True,
                 quant=False,
                 calibrate=False,
                 last_calibrate=False,
                 bit_type=BIT_TYPE_DICT['int8'],
                 calibration_mode='layer_wise',
                 observer_str='minmax',
                 quantizer_str='uniform'):
        super(QConv2d, self).__init__(
            in_channels=in_channels,
            out_channels=out_channels,
            kernel_size=kernel_size,
            stride=stride,
            padding=padding,
            dilation=dilation,
            groups=groups,
            bias=bias,
        )
        self.quant = quant
        self.calibrate = calibrate
        self.last_calibrate = last_calibrate
        self.bit_type = bit_type
        self.calibration_mode = calibration_mode
        self.observer_str = observer_str
        self.quantizer_str = quantizer_str

        self.module_type = 'conv_weight'
        self.observer = build_observer(self.observer_str, self.module_type,
                                       self.bit_type, self.calibration_mode)
        self.quantizer = build_quantizer(self.quantizer_str, self.bit_type,
                                         self.observer, self.module_type)
        self.GeneratMat=True
    #卷积整形前向传播
    # def Conv_IntForward(x,in_quantizer=None,
    #             out_quantizer=None):
    #     #进来时激活x维度为[1,3,224,224]
    #     #
    #     print("输入激活的维度:",x.shape)
    #     print("ScaleIn 维度:",in_quantizer.scale.shape)
    #     print("ZeroPoint 维度:",in_quantizer.zero_point.shape)
    #     print("ScaleOut 维度:",out_quantizer.scale.shape)
    #     print("ZeroPoint_Out 维度:",out_quantizer.zero_point.shape)
        
    #     ScaleIn = in_quantizer.scale #ScaleIn
    #     ScaleOut=out_quantizer.scale#ScaleOut
        
    #     print("ConvInt Forward\n")
    #     return 0

    def forward(self, x,in_quantizer=None,out_quantizer=None):
        if self.calibrate:
            self.quantizer.observer.update(self.weight)
            if self.last_calibrate:
                self.quantizer.update_quantization_params(x)
        if not self.quant:
            return F.conv2d(
                x,
                self.weight,
                self.bias,
                self.stride,
                self.padding,
                self.dilation,
                self.groups,
            )
        weight =self.quantizer(self.weight)#先对权重量化，再反量化回浮点
        #校准完后，Scale，Zp等量化参数都被固定，接下来就是生成权重文件
            #目前还是采用先生成.mat文件，然后导入matlab里做验证
        if self.GeneratMat:
            device="cuda"
            self.GeneratMat=False
            #更新完量化参数后，开始生成量化参数
            S1 = in_quantizer.scale #ScaleIn 
            Z1   =in_quantizer.zero_point
            S2=self.quantizer.scale
            Z2=0#self.quantizer.zero_point
            S3= out_quantizer.scale #ScaleOut
            Z3=out_quantizer.zero_point
            #先重新取得所有量化为8bit的q1
            q1=x/S1+Z1
            weight_quanted=self.quantizer.quant(self.weight)#量化回去
            
            
            Scale, Shift = gen_M_N(S1, S2, S3)#Scale就是Scale，N_Real其实就是Shift
            Bias_Int=gen_int_bias(S1,S2.squeeze(),self.bias)#获取bias/(S1S2)
            [Bias,out_bias_bin] = new_bias(Z1, weight_quanted, Bias_Int)#Bias也需要被放大
            weight_quanted=weight_quanted.permute(0,2,3,1).reshape(weight_quanted.shape[0],-1)
            # 通道补零
            weight_quanted=torch.cat((torch.zeros(weight.shape[0],1280).to(device),weight_quanted),dim=1)
            if weight_quanted.device.type=="cuda":
                weight_quanted=weight_quanted.to("cpu")
            Tensors = [Scale,Shift,Bias,weight_quanted.numpy()]
            var_name=["Scale","Shift","Bias","weight_quanted"]
            data = {}
            for i, array in enumerate(Tensors):
                data[var_name[i]] = array
            # 保存为 .mat 文件
            sio.savemat(r'matlab\Embedding_Conv.mat', data)
        if False:#模拟硬件量化计算，重写整形前向传播公式，
            Shift_Num=torch.tensor(32)#放大移位
            # print("输入激活的维度:",x.shape)
            # print("ScaleIn 维度:",in_quantizer.scale.shape)
            # print("ZeroPoint 维度:",in_quantizer.zero_point.shape)
            # print("ScaleOut 维度:",out_quantizer.scale.shape)
            # print("ZeroPoint_Out 维度:",out_quantizer.zero_point.shape)
            

            #开始实现整形前向传播并计算误差=======2023、3、30==============================
            S1 = in_quantizer.scale #ScaleIn 
            Z1   =in_quantizer.zero_point
            
            S2=torch.reshape(self.quantizer.scale,[-1,1,1,1])
            Z2=0#self.quantizer.zero_point

            S3= out_quantizer.scale #ScaleOut
            Z3=out_quantizer.zero_point
            #目前可以暂时认为输入输出的S，Z的维度都是1。
            
            Xq=x/S1+Z1#量化后的激活值
            
            Wq=self.quantizer.quant(self.weight)
            # print(Wq)
            
            Wq=torch.pow(2,Shift_Num)*(weight*S1)/S3#[768,3,16,16]
            Xq=Xq-Z1
            #self.bias.data=(self.bias.data/S3+Z3)
            Cq=(F.conv2d(Xq, Wq.round(), ((self.bias/S3+Z3)*torch.pow(2,Shift_Num)).round(), self.stride, self.padding,
                        self.dilation, self.groups))/torch.pow(2,Shift_Num)
            
            


            return (Cq.round()-Z3)*S3
        else:
            if False:#祖传代码量化移植
                device="cuda"
                #移植祖传代码的量化========================================================================
                S1 = in_quantizer.scale #ScaleIn 
                Z1   =in_quantizer.zero_point
                S2=torch.reshape(self.quantizer.scale,[-1,1,1,1])
                Z2=0#self.quantizer.zero_point

                S3= out_quantizer.scale #ScaleOut
                Z3=out_quantizer.zero_point

                #先重新取得所有量化为8bit的q1
                q1=x/S1+Z1
                weight_quanted=self.quantizer.quant(weight)#量化回去
                #目前可以暂时认为输入输出的S，Z的维度都是1。
            #第一步：获取Scale，Shift和Bias
                #先加Bias，再乘Scale，然后Shfit回去，最后加ZP
                SCALE, N_REAL = gen_M_N(S1, S2, S3)#Scale就是Scale，N_Real其实就是Shift
                Bias_Int=gen_int_bias(S1,S2.squeeze(),self.bias)#获取bias/(S1S2)
                [Bias,out_bias_bin] = new_bias(Z1, weight_quanted, Bias_Int)#Bias也需要被放大
                OC=len(Bias)

                Bias_Tmp_All=torch.zeros(OC)
                for i in range(OC):#计算Bias_Add
                    Bias_Bin = bin(Bias[i])[2:].zfill(32)#需要注意的是，这里直接用bin函数，会包含0b这种字符
                    #↑这里直接截取2：end而不考虑“-0b”这种情况是因为我们自己再new_bias里面重新定义了Bias的格式，仔细看看就明白了
                    #当然这里也能直接用out_bias_bin
                    #zfill好像只会补零

                    # assert(len(Bias_Bin)==32)
                    Sign=Bias_Bin[0]
                    # print(Sign)
                    Bias_Shift=int(Bias_Bin[1:8],2)#二进制转化为十进制
                    Bias_Tmp=Sign*(8+Bias_Shift)+Bias_Bin[8:32]+'0'*(16-Bias_Shift)#带符号移位
                    # 补码转十进制
                    # Bias_Tmp=compbin2hex(Bias_Tmp)
                    # if Bias_Tmp[0] == "1":
                    #     # 将二进制字符串作为无符号整数解释，然后减去2的补码位数次方
                    #     Bias_Tmp = int('-0b'+Bias_Tmp, 2)
                    # else:
                    #     # 直接将二进制字符串作为无符号整数解释
                    #     Bias_Tmp = int(Bias_Tmp, 2)
                    Bias_Tmp_All[i]=compbin2hex(Bias_Tmp)
                
                
                #第二步；计算BiasAdd

                
                
                q1q2=F.conv2d(q1, weight_quanted, stride=self.stride, padding=self.padding,
                            dilation=self.dilation, groups=self.groups)#这里不再计算Bias
                BiasAdd=torch.zeros(q1q2.shape[0],q1q2.shape[1],q1q2.shape[2],q1q2.shape[3]).to(device)
                ScaleMul=torch.zeros(q1q2.shape[0],q1q2.shape[1],q1q2.shape[2],q1q2.shape[3]).to(device)
                DataShift_Result=torch.zeros(q1q2.shape[0],q1q2.shape[1],q1q2.shape[2],q1q2.shape[3]).to(device)
                AddZero=torch.zeros(q1q2.shape[0],q1q2.shape[1],q1q2.shape[2],q1q2.shape[3]).to(device)
                X3=torch.zeros(q1q2.shape[0],q1q2.shape[1],q1q2.shape[2],q1q2.shape[3]).to(device)
                # q1q2=q1q2.flatten(2).transpose(1, 2)
                

                #第一步：先加Bias
                # BiasAdd=Bias_Tmp_All+q1q2.permute(0,3,2,1)*65536
                # BiasAdd=BiasAdd.permute(0,3,2,1)

                # ScaleMul=torch.mul(BiasAdd.permute(0,3,2,1),torch.tensor(SCALE.astype(np.float32)).to(device))
                # ScaleMul=ScaleMul.permute(0,3,2,1)

                for B in range(q1q2.shape[0]):
                    for H in range(q1q2.shape[2]):
                        for W in range(q1q2.shape[3]):
                            for C in range(q1q2.shape[1]):
                                BiasAdd[B,C,H,W]=Bias_Tmp_All[C]+q1q2[B,C,H,W]*65536#左移16位
                            #BiasAdd完后开始乘Scale
                            ScaleMul[B,:,H,W]=torch.mul(BiasAdd[B,:,H,W],torch.tensor(SCALE.astype(np.float32)).to(device))
                            
                            
                            #乘完Scale后做Shift
                            for i in range(OC):
                                ScaleMul_Bin=convert_to_binary(int(ScaleMul[B,i,H,W]), 80)#应该是补成80bit后的高32位
                                ScaleMul_Bin=ScaleMul_Bin[0:32]
                                length=len(ScaleMul_Bin)
                                
                                # if ScaleMul[B,i,H,W]<0:#如果是负数
                                # ScaleMul_Bin=ScaleMul_Bin[2:].zfill(80)
                                #先移位再取高十五位做四舍五入
                                ScaleMul_Bin=ScaleMul_Bin[0]*(N_REAL[i])+ScaleMul_Bin[0:32-N_REAL[i]]#带符号移位
                                ScaleMul_Bin=ScaleMul_Bin[-16:]#取低16位
                                DataShift_Result[B,i,H,W]=compbin2hex(ScaleMul_Bin[0:15])+int(ScaleMul_Bin[15],2)
                                # print("Detect negative","[",i,"]:",DataShift_Result[i])
                                # negnum+=1#负数有多少个
                                # else:
                                #     DataShift_Result[B,i,H,W]=int(ScaleMul_Bin[0:32-N_REAL[i]],2)+int(ScaleMul_Bin[0:32-N_REAL[i]][16],2)#取高15位，并且四舍五入，看要不要加一
                            #Shift完后就AddZero
                                AddZero[B,i,H,W]=torch.clamp(DataShift_Result[B,i,H,W]+Z3,0,255)
                                #现在AddZero=q3，然后再反量化回去
                                X3[B,i,H,W]=(AddZero[B,i,H,W]-Z3)*S3
                return X3                    
                # #接下来开始计算Scale*Bias_Add
                # ScaleMul=torch.mul(torch.tensor(SCALE.astype(np.float32)),BiasAdd)

                # #乘完SCALE后再Shift
                # DataShift_Result=torch.zeros(OC)
                # negnum=0;
                # for i in range(OC):
                #     #先获取二进制值
                #     ScaleMul_Bin=bin(int(ScaleMul[i]))#python的bin函数可以记录正数还是负数
                #     length=len(ScaleMul_Bin)
                #     if ScaleMul_Bin[0]=='-':#如果是负数
                #         DataShift_Result[i]=int('-0b'+ScaleMul_Bin[3:length-N_REAL[i]][0:15],2)+int(ScaleMul_Bin[3:length-N_REAL[i]][15],2)#取高15位
                #         print("Detect negative","[",i,"]:",DataShift_Result[i])
                #         negnum+=1#负数有多少个
                #     else:
                #         DataShift_Result[i]=int(ScaleMul_Bin[2:length-N_REAL[i]][0:15],2)+int(ScaleMul_Bin[2:length-N_REAL[i]][15],2)#取高15位，并且四舍五入，看要不要加一
                # #shift完后拿得到的16bit继续和zeropoint相加并且做clip(0,255)
                # AddZero=[]
                # for i in range(OC):
                #     AddZero.append(torch.clamp(DataShift_Result[i]+Zero,0,255))
                # # exit()
                # print(AddZero)
                #获取量化后的权重和激活值==================================================================================
                if False:
                    with open (r'E:\Transformer\Transformer_Arithmatic\Transformer_Main\TxT\Weight.txt','w') as ff:
                        #Wq的维度：[OC,IC,K,K]
                        for OC in range(Wq.shape[0]):#遍历全部输出通道
                            for K_Row in range(Wq.shape[2]):#遍历行
                                for K_Col in range(Wq.shape[3]):#遍历列
                                    for IC in range(0,Wq.shape[1],8):#遍历通道
                                        Hex0=Wq[OC,IC,K_Row,K_Col].item()&0xff
                                        Hex1=Wq[OC,IC+1,K_Row,K_Col].item()&0xff
                                        Hex2=Wq[OC,IC+2,K_Row,K_Col].item()&0xff
                                        Hex3=Wq[OC,IC+3,K_Row,K_Col].item()&0xff
                                        Hex4=Wq[OC,IC+4,K_Row,K_Col].item()&0xff
                                        Hex5=Wq[OC,IC+5,K_Row,K_Col].item()&0xff
                                        Hex6=Wq[OC,IC+6,K_Row,K_Col].item()&0xff
                                        Hex7=Wq[OC,IC+7,K_Row,K_Col].item()&0xff
                                        #print('%02x%02x%02x%02x%02x%02x%02x%02x'%(Hex7,Hex6,Hex5,Hex4,Hex3,Hex2,Hex1,Hex0))
                                        ff.write('%02x%02x%02x%02x%02x%02x%02x%02x'%(Hex7,Hex6,Hex5,Hex4,Hex3,Hex2,Hex1,Hex0))
                                        ff.write("\n")
                        ff.close()
                
                return (F.conv2d(x, weight, self.bias, self.stride, self.padding,
                            self.dilation, self.groups))
            else:
                return (F.conv2d(x, weight, self.bias, self.stride, self.padding,
                            self.dilation, self.groups))
    





class QLinear(nn.Linear):

    def __init__(self,
                 in_features,
                 out_features,
                 bias=True,
                 quant=False,
                 calibrate=False,
                 last_calibrate=False,
                 bit_type=BIT_TYPE_DICT['int8'],
                 calibration_mode='layer_wise',
                 observer_str='minmax',
                 quantizer_str='uniform'):
        super(QLinear, self).__init__(in_features, out_features, bias)

        self.quant = quant
        self.calibrate = calibrate
        self.last_calibrate = last_calibrate
        self.bit_type = bit_type
        self.calibration_mode = calibration_mode
        self.observer_str = observer_str
        self.quantizer_str = quantizer_str

        self.module_type = 'linear_weight'
        self.observer = build_observer(self.observer_str, self.module_type,
                                       self.bit_type, self.calibration_mode)
        self.quantizer = build_quantizer(self.quantizer_str, self.bit_type,
                                         self.observer, self.module_type)

    def forward(self, x):
        if self.calibrate:
            self.quantizer.observer.update(self.weight)
            if self.last_calibrate:
                self.quantizer.update_quantization_params(x)
        if not self.quant:
            return F.linear(x, self.weight, self.bias)
        weight = self.quantizer(self.weight)
        return F.linear(x, weight, self.bias)


class QAct(nn.Module):

    def __init__(self,
                 quant=False,
                 calibrate=False,
                 last_calibrate=False,
                 bit_type=BIT_TYPE_DICT['int8'],
                 calibration_mode='layer_wise',
                 observer_str='minmax',
                 quantizer_str='uniform'):
        super(QAct, self).__init__()

        self.quant = quant
        self.calibrate = calibrate
        self.last_calibrate = last_calibrate
        self.bit_type = bit_type
        self.calibration_mode = calibration_mode
        self.observer_str = observer_str
        self.quantizer_str = quantizer_str

        self.module_type = 'activation'
        self.observer = build_observer(self.observer_str, self.module_type,
                                       self.bit_type, self.calibration_mode)
        self.quantizer = build_quantizer(self.quantizer_str, self.bit_type,
                                         self.observer, self.module_type)

    def forward(self, x):
        if self.calibrate:
            self.quantizer.observer.update(x)
            if self.last_calibrate:
                # import ipdb;ipdb.set_trace()
                self.quantizer.update_quantization_params(x)
        if not self.quant:
            return x
        x = self.quantizer(x)
        return x


class QIntLayerNorm(nn.LayerNorm):

    def __init__(self, normalized_shape, eps=1e-5, elementwise_affine=True):
        super(QIntLayerNorm, self).__init__(normalized_shape, eps,
                                            elementwise_affine)
        assert isinstance(normalized_shape, int)
        self.mode = 'ln'

    def get_MN(self, x):
        bit = 7
        N = torch.clamp(bit - torch.floor(torch.log2(x)), 0, 31)
        M = torch.clamp(torch.floor(x * torch.pow(2, N)), 0, 2**(bit + 1) - 1)
        return M, N

    def forward(self,
                x,
                in_quantizer=None,
                out_quantizer=None,
                in_scale_expand=1):
        x1=0
        if self.mode == 'ln':
            x = F.layer_norm(x, self.normalized_shape, self.weight, self.bias,
                             self.eps)
        
        elif self.mode == 'int':#
            if True:
                in_scale = in_quantizer.scale
                if in_scale_expand != 1:
                    in_scale = in_scale.unsqueeze(-1).expand(
                        -1, in_scale_expand).T.reshape(-1)
                out_scale = out_quantizer.scale
                assert in_scale is not None and out_scale is not None
                channel_nums = x.shape[-1]
                in_scale = in_scale.reshape(1, 1, -1)
                out_scale = out_scale.reshape(1, 1, -1)
                x_q = (x / in_scale).round()
                in_scale1 = in_scale.min()
                in_scale_mask = (in_scale / in_scale1).round()

                x_q = x_q * in_scale_mask

                mean_x_q = x_q.mean(dim=-1) * in_scale1
                std_x_q = (in_scale1 / channel_nums) * torch.sqrt(
                    channel_nums * (x_q**2).sum(dim=-1) - x_q.sum(dim=-1)**2)

                A = (in_scale1 / std_x_q).unsqueeze(-1) * \
                    self.weight.reshape(1, 1, -1) / out_scale
                A_sign = A.sign()
                M, N = self.get_MN(A.abs())
                B = ((self.bias.reshape(1, 1, -1) -
                    (mean_x_q / std_x_q).unsqueeze(-1) *
                    self.weight.reshape(1, 1, -1)) / out_scale *
                    torch.pow(2, N)).round()

                x_q = ((A_sign * M * x_q + B) / torch.pow(2, N)).round()
                x1 = x_q * out_scale

            if True:
                in_scale = in_quantizer.scale
                if in_scale_expand != 1:
                    in_scale = in_scale.unsqueeze(-1).expand(
                        -1, in_scale_expand).T.reshape(-1)
                out_scale = out_quantizer.scale
                assert in_scale is not None and out_scale is not None
                channel_nums = x.shape[-1]#获取通道数
                in_scale = in_scale.reshape(1, 1, -1)#将inscale数放到最后一个维度，对应通道数
                out_scale = out_scale.reshape(1, 1, -1)
                x_q = (x / in_scale).round()#注意：Matlab的round(10.5)=11,二pytorch则为10，获取整形
                in_scale1 = in_scale.min()
                in_scale_mask = (in_scale / in_scale1).round()

                #行优先生成xq，8bit=================================================================
                # with open ('Xq_LayerNorm.txt','a') as ff:
                #     for i in range(x_q.shape[-2]):
                #         for j in range(x_q.shape[-1]):
                #             ff.write('%02x'%(int(x_q[0,i,j].item())&0xff))
                #             ff.write("\n")
                # ff.close()
                #=================================================================================
                x_q = x_q * in_scale_mask#最后一个维度的对应元素相乘，不相加,这个Xq就是上一层量化后的整形（xq-zeropint），in_scale_mask即Ptf量化因子
                M1=x_q.sum(dim=-1)#按行求和[16,197]
                Sqrt_In=channel_nums * (x_q**2).sum(dim=-1) - x_q.sum(dim=-1)**2
                #行优先生成xq,乘了掩码mask的，12bit=================================================================
                # with open ('Xq_LayerNorm.txt','w') as ff:
                #     for i in range(x_q.shape[-2]):
                #         for j in range(x_q.shape[-1]):
                #             ff.write('%04x'%(int(x_q[0,i,j].item())&0xffff))
                #             ff.write("\n")
                # ff.close()
                # #=================================================================================
                std_x_q = torch.sqrt(Sqrt_In)#[B,197]#std标准差也就是加入alpha后每一行的标准差，
                # print('std_x_q dtype is',std_x_q.dtype)
                # std_x_q.dtype=torch.float32
                batch=x_q.shape[0]
                Shift_Num=32
                std_x_q_round=((1/std_x_q)*torch.pow(2, torch.tensor(Shift_Num))).floor()#(((1/std_x_q)*torch.pow(2, torch.tensor(32))).round()/torch.pow(2, torch.tensor(32)))
                for i in range(M1.shape[-1]):#对于每一行来说，都是[16,384]维，对于M1的每一行来说，都是[16]维
                    x_q[:,i,:]=(channel_nums*x_q[:,i,:]-M1[:,i].reshape(batch,-1))#A
                Gama=((self.weight.reshape(1, 1, -1)/out_scale*torch.pow(2, torch.tensor(32))).round()/torch.pow(2, torch.tensor(32))).round()
                Beta=((self.bias.reshape(1,1,-1)/out_scale*torch.pow(2, torch.tensor(32))).round()/torch.pow(2, torch.tensor(32))).round()
                # with open ('Scale_Bias.txt','a') as ff:
                #     for i in range(Gama.shape[-1]):
                #         ff.write('%02x%02x'%(int(Gama[0,0,i].item())&0xff,int(Beta[0,0,i].item())&0xff))
                #         ff.write("\n")
                # ff.close()



                
                # 验证Scale和Bias的位宽
                # for i in Gama[0,0,:]:
                #     if i>127 or i<-128:
                #         print("Gama is",i,":>255")
                # for i in Beta[0,0,:]:
                #     if i>127 or i<-128:
                #         print("Beta is",i,":>255")               
                
                for i in range(x_q.shape[1]):#对于每一行来说
                    x_q[:,i,:]=(((x_q[:,i,:]*Gama)))#+Beta).round()# (((.round()))+Beta).round()#使用放大2^32倍的1/sqrt计算
                for i in range(M1.shape[-1]):#对于每一行来说，都是[16,384]维，对于M1的每一行来说，都是[16]维
                    x_q[:,i,:]=((x_q[:,i,:]*(std_x_q_round[:,i].reshape(batch,-1))/torch.pow(2, torch.tensor(Shift_Num))).floor()+Beta).floor()
                
                #二进制模拟硬件截位计算
                Recipro_Std_Xq=1/std_x_q
                    #获取尾数部分
                Recipro_Std_Xq_Frac_Part=Recipro_Std_Xq
                # for i in range(Recipro_Std_Xq.shape[-1]):
                #     Recipro_Std_Xq_Frac_Part[:,i]=struct.pack('>f' ,float(s)).hex()

                x = x_q * out_scale
                # mean_x_q = x_q.mean(dim=-1) * in_scale1
                # std_x_q = (in_scale1 / channel_nums) * torch.sqrt(#std标准差也就是加入alpha后每一行的标准差，
                #     channel_nums * (x_q**2).sum(dim=-1) - x_q.sum(dim=-1)**2)#[B,197]
                # # for i in range(std_x_q.shape[1]):
                # #     if(std_x_q[0][i]==0):
                # #         print("detected")
                # #所以这里的in_scale1可以被约掉。。。。
                # A = (in_scale1 / std_x_q).unsqueeze(-1) * \
                #     self.weight.reshape(1, 1, -1) / out_scale#weight就是每个通道的gama，下面还要加一个bias，就是beta
                # #A=torch.floor(torch.floor(A*1024)/1024),很奇怪，随便动一下精度就没了
                # A_sign = A.sign()#每一行算标准差，每一通道都有一个gama和beta，所以A是一个[197,384]维的矩阵
                # M, N = self.get_MN(A.abs())
                # # N=torch.tensor(32)
                # # M=torch.floor(A.abs() * torch.pow(2, N))
                # B = ((self.bias.reshape(1, 1, -1) -
                #       (mean_x_q / std_x_q).unsqueeze(-1) *
                #       self.weight.reshape(1, 1, -1)) / out_scale *
                #      torch.pow(2, N)).round()

                # x_q = ((A_sign * M * x_q + B) / torch.pow(2, N)).round()
                # x = x_q * out_scale
                #统计误差
                if False:
                    Correct=F.layer_norm(x, self.normalized_shape, self.weight, self.bias,self.eps)
                    matrices = [Correct.squeeze().to('cpu'), x1.squeeze().to('cpu'), x.squeeze().to('cpu')]
                    # plot_heatmaps(matrices)    
                    error1=(x1-Correct).sum()
                    error2=(x-Correct).sum()
                    error3=(x-x1).sum()

                    Correct=Correct.view(1,-1)
                    fp64=x1.view(1,-1)
                    fpga=x
                    fpga=fpga.view(1,-1)
                    
                    similarity1 = F.cosine_similarity(fp64, Correct)
                    similarity2 = F.cosine_similarity(Correct, fpga)
                    similarity3 = F.cosine_similarity(fp64, fpga)
                    print("余弦距离1:", similarity1.item())
                    print("余弦距离2:", similarity2.item())
                    print("余弦距离3:", similarity3.item())


                if False: #将tensor转化为matlab格式
                    tensors_to_mat(matrices, r'E:\Transformer\Transformer_Arithmatic\Transformer_Main\matlab\tensors.mat')
        else:
            raise NotImplementedError
        



        
        return x


class QIntSoftmax(nn.Module):

    def __init__(self,
                 log_i_softmax=False,
                 quant=False,
                 calibrate=False,
                 last_calibrate=False,
                 bit_type=BIT_TYPE_DICT['int8'],
                 calibration_mode='layer_wise',
                 observer_str='minmax',
                 quantizer_str='uniform'):
        super(QIntSoftmax, self).__init__()

        self.log_i_softmax = log_i_softmax
        self.quant = quant
        self.calibrate = calibrate
        self.last_calibrate = last_calibrate
        self.bit_type = bit_type#这里是4bit，也就是最大可支持的移位值为15
        self.calibration_mode = calibration_mode
        self.observer_str = observer_str
        self.quantizer_str = quantizer_str

        self.module_type = 'activation'
        self.observer = build_observer(self.observer_str, self.module_type,
                                       self.bit_type, self.calibration_mode)
        self.quantizer = build_quantizer(self.quantizer_str, self.bit_type,
                                         self.observer, self.module_type)

    @staticmethod
    def log_round(x):
        x_log_floor = x.log2().floor()
        big = x_log_floor
        extra_mask = (x - 2**big) >= 2**(big - 1)
        big[extra_mask] = big[extra_mask] + 1#这里其实是在做四舍五入，你自己手算一下就明白了2023.12.17
        return big

    @staticmethod
    def int_softmax(x, scaling_factor):

        def int_polynomial(x_int, scaling_factor):
            coef = [0.35815147, 0.96963238, 1.]  # ax**2 + bx + c
            coef[1] /= coef[0]
            coef[2] /= coef[0]
            b_int = torch.floor(coef[1] / scaling_factor)
            c_int = torch.floor(coef[2] / scaling_factor**2)
            z = x_int + b_int
            z = x_int * z
            z = z + c_int
            scaling_factor = coef[0] * scaling_factor**2
            return z, scaling_factor

        def int_exp(x_int, scaling_factor):
            x0 = -0.6931  # -ln2
            n = 30  # sufficiently large integer
            x0_int = torch.floor(x0 / scaling_factor)
            x_int = torch.max(x_int, n * x0_int)
            q = torch.floor(x_int / x0_int)
            r = x_int - x0_int * q
            exp_int, exp_scaling_factor = int_polynomial(r, scaling_factor)
            exp_int = torch.clamp(torch.floor(exp_int * 2**(n - q)), min=0)
            scaling_factor = exp_scaling_factor / 2**n
            return exp_int, scaling_factor

        x_int = x / scaling_factor
        x_int_max, _ = x_int.max(dim=-1, keepdim=True)
        x_int = x_int - x_int_max
        exp_int, exp_scaling_factor = int_exp(x_int, scaling_factor)
        exp_int_sum = exp_int.sum(dim=-1, keepdim=True)
        return exp_int, exp_int_sum
    @staticmethod
    def Softmax_FPGA(x, scaling_factor):
        print("模拟FPGA计算")
        def int_polynomial(x_int, scaling_factor):
            coef = [0.35815147, 0.96963238, 1.]  # ax**2 + bx + c
            coef[1] /= coef[0]
            coef[2] /= coef[0]
            b_int = torch.floor(coef[1] / scaling_factor)
            c_int = torch.floor(coef[2] / scaling_factor**2)
            z = x_int + b_int
            z = x_int * z
            z = z + c_int
            scaling_factor = coef[0] * scaling_factor**2
            return z, scaling_factor
                
        def int_exp(x_int, scaling_factor):
            ln2 = -0.6931  # -ln2
            n = 30  # sufficiently large integer
            x0_int = torch.floor(scaling_factor/ln2)
            x_int = torch.max(x_int, n * x0_int)
            z = torch.floor(x_int / x0_int)
            r = x_int*(scaling_factor*(1+torch.floor()))#x_int - x0_int * q
            exp_int, exp_scaling_factor = int_polynomial(r, scaling_factor)
            exp_int = torch.clamp(torch.floor(exp_int * 2**(n - q)), min=0)
            scaling_factor = exp_scaling_factor / 2**n
            return exp_int, scaling_factor
        x_int = x / scaling_factor
        x_int_max, _ = x_int.max(dim=-1, keepdim=True)
        x_int = x_int - x_int_max
        exp_int, exp_scaling_factor = int_exp(x_int, scaling_factor)
        exp_int_sum = exp_int.sum(dim=-1, keepdim=True)
        return exp_int, exp_int_sum         
    
          
    def forward(self, x, scale):
        Pow2=False
        if self.log_i_softmax and scale is not None:
            if not Pow2:
                exp_int, exp_int_sum = self.int_softmax(x, scale)
                softmax_out = torch.round(exp_int_sum / exp_int)
                rounds = self.log_round(softmax_out)
                mask = rounds >= 2**self.bit_type.bits#这里的bits为4，不是8，需要注意
                qlog = torch.clamp(rounds, 0, 2**self.bit_type.bits - 1)
                deq_softmax = 2**(-qlog)
                deq_softmax[mask] = 0
                Correct=x.softmax(dim=-1)
                matrices = [Correct.squeeze().to('cpu'), deq_softmax.squeeze().to('cpu')]
                if False: #将tensor转化为matlab格式
                    tensors_to_mat(matrices, 'Softmax_tensors.mat')


                return deq_softmax#这里返回的也是反量化后的浮点值，下层模块拿到这些浮点值后再用一下量化就又变成定点了
            else:
                Row_Sum=(torch.pow(2,x-x.max(-1).values.unsqueeze(-1))).sum(-1).unsqueeze(-1)#先算一下每一行的指数累加和作为分母                
                Row_Sum=Row_Sum.expand(Row_Sum.shape[0],Row_Sum.shape[1],Row_Sum.shape[2],x.shape[-1])
                x=torch.pow(2,x-x.max(-1).values.unsqueeze(-1))/Row_Sum
                return x                
        else:
            if not Pow2:
                x = x.softmax(dim=-1)
            else:
                Row_Sum=(torch.pow(2,x-x.max(-1).values.unsqueeze(-1))).sum(-1).unsqueeze(-1)#先算一下每一行的指数累加和作为分母                
                Row_Sum=Row_Sum.expand(Row_Sum.shape[0],Row_Sum.shape[1],Row_Sum.shape[2],x.shape[-1])
                x=torch.pow(2,x-x.max(-1).values.unsqueeze(-1))/Row_Sum
                # for batch in range(x.shape[0]):
                #     #遍历所有batch
                #     for head in range(x.shape[1]):
                #         #遍历每个头
                #         Row_Sum=(torch.pow(2,x[batch,head,:,:]-x[batch,head,:,:].max())).sum()#先算一下每一行的指数累加和作为分母
                #         x[batch,head,:,:]=torch.pow(2,x[batch,head,:,:]-x[batch,head,:,:].max(-1))/Row_Sum
                #         for row in range(x.shape[2]):
                #             #遍历每一行
                #             Row_Sum=(torch.pow(2,x[batch,head,row,:]-x[batch,head,row,:].max())).sum()#先算一下每一行的指数累加和作为分母
                #             #遍历每一列
                #             x[batch,head,row,:]=torch.pow(2,x[batch,head,row,:]-x[batch,head,row,:].max())/Row_Sum
                            
            if self.calibrate:
                self.quantizer.observer.update(x)
                if self.last_calibrate:
                    self.quantizer.update_quantization_params(x)
            if not self.quant:
                return x
            # x = self.quantizer(x)
            #我们对softmax不量化,直接用2的指数幂进行输出试一下

            return x
def plot_heatmaps(matrices):
    num_matrices = len(matrices)

    # 创建包含子图的图形
    fig, axes = plt.subplots(1, num_matrices, figsize=(4*num_matrices, 4))

    for i in range(num_matrices):
        matrix = matrices[i]

        # 在每个子图上显示热度图
        axes[i].imshow(matrix, cmap='hot', interpolation='nearest')
        axes[i].set_title(f'Matrix {i+1}')

    # 调整子图之间的间距
    plt.tight_layout()

    # 显示图像
    plt.show()
def tensors_to_mat(tensors, file_path):
    # 创建一个字典，将变量名与对应的 NumPy 数组关联起来
    data = {}
    for i, tensor in enumerate(tensors):
        # 将张量转换为 NumPy 数组
        array = tensor.numpy()
        # 使用默认的变量名 "tensor" + 数字索引
        var_name = f'tensor{i+1}'
        data[var_name] = array

    # 保存为 .mat 文件
    sio.savemat(file_path, data)
    # 创建示例张量
tensor1 = torch.randn(197, 768)
tensor2 = torch.randn(197, 768)
tensor3 = torch.randn(197, 768)



#移植祖传代码中的量化============================================
def gen_B(S1, S2, S3):  # 第一组  β即N_REAL  +++++求shitf++++
    M = (S1 * S2) / S3
    
    M=M.squeeze()
    M=M.cpu()#先将tensor放到cpu上
    M = M.numpy()
    
    daxiao = S2.shape[0]  # 第一层权重的shape[0]是32 shape[0]表示行数 是一维大小位32的列向量
    SCALE = np.zeros(daxiao, dtype=np.uint32, order='C')  # 相当于32个输出通道 每个对应一组shift
    N_REAL = np.zeros(daxiao, dtype=np.uint32, order='C')
    for i,data in enumerate(M):  # enumerate() 函数用于将一个可遍历的数据对象(如列表、元组或字符串)组合为一个索引序列，同时列出数据和数据下标
        ii=M[i]
        while not (ii >= 0.5 and ii <= 1.0):  # 左移到（0.5，1） 左移一次相当于*2
            ii *= 2
        pass
        mmmm = ii * (2 ** 32)  # 乘2^32  

        SCALE[i] = mmmm.astype(np.uint32) #师兄埋下的一个一个远古bug，这里应该是uint32，不然会出现严重错误

    for i,data in enumerate(M):
        N_REAL[i] = round(math.log(SCALE[i] / M[i], 2)) - 32   # fpga加了1这里要减1,  β值也是m维 相当于存的mmmm
        if N_REAL[i] !=0:
            N_REAL[i]=N_REAL[i]-1

    return SCALE,N_REAL


def gen_M_N(S1, S2, S3):  # 第二组求M'即M  ++++++返回scale和shift+++++
    daxiao = S2.shape[0]
    SCALE,N_REAL = gen_B(S1, S2, S3)

    
    # for i, ii in enumerate(M):
    #     Scale=(S1*S2[i]/S3).cpu()
    #     # Scale=Scale.numpy
    #     M[i] = (torch.round(Scale * (2 ** (32 + N_REAL[i] + 1)))).numpy()  # s1s2/s3 *2^(32+β+1)
    # M = M.astype(np.uint32)
    # exit()
    return SCALE, N_REAL


# r_b=s1*s2*q_b
# r_b是量化前的bias,q_b是量化后的bias
def gen_int_bias(s1, s2, bias_float):  # 求bias/s1s2即bb
    aa = bias_float / s1
    # print(bias_float)
    # exit()
    bb = torch.div(aa, s2)  # 对应元素做除法

    # for i, m in enumerate(bb):
    #     bb[i] = round(m.item())
    # bias = bb.int()
    return bb


def gen_M(s1, s2, s3):
    aa = s1 * s2
    M = aa / s3
    return M


def new_bias(z1, q2, bias):  # 求最终的bias=bias/s1s2-q2z1
    q2 = q2.type(torch.float64)
    bias1 = z1 * q2
    shape = bias1.shape
    n_bias = np.zeros(shape[0], dtype=np.float64, order='C')
    for m in range(shape[0]):  # bias1的维度是M C K K 将C K K 做累加 变成M维
        n_bias[m] = bias1[m, :, :, :].sum()  # 从第一组开始一直有m组，m是输出通道数
        # print()
        n_bias[m] = (bias[m] - n_bias[m])  # 做减法
    # print(n_bias) 第一层n_bias是一维32个
    # exit()
    daxiao = shape[0]  # 第一层是32
    SCALE = np.zeros(daxiao, dtype=np.float64, order='C')
    # N_REAL = np.zeros(daxiao, dtype=np.float32, order='C')
    N_REAL = []
    for i, ii in enumerate(n_bias):  # i和ii就是从n_bias中取值
        index = 0

        while not (abs(ii) >= (2 ** 23) and abs(ii) <= (2 ** 24)):
            if index >= 16:  # fpga里面最多移动16位,所有成到16就停止了,这样精度也够了
                break
            else:
                ii *= 2
                index = index + 1

        N_REAL.append(index)
        SCALE[i] = round(ii)
    out_bias = []
    out_bias_bin=[]
    for index in range(shape[0]):
        data_integer_old = ('{:024b}'.format(int(SCALE[index]) & 0xffffff))  # {:024b} 24位2二进制不足补0；& 0xffffff按位与
        n = N_REAL[index]
        symbol = '0'
        if n_bias[index] < 0:  # 符号位
            symbol = '1'#这里也不是多此一举，因为如果你给一个uint24，MSB=1，那么你在FPGA那边如何分辨这是正数还是负数，所以还是需要1bit的符号位来帮助fpga做判断的
        elif n_bias[index] > 0:
            symbol = '0'
        data_integer = data_integer_old[8:]
        data_decimal = '{:07b}'.format(int(n))
        out_bias1 = symbol + str(data_decimal) + str(data_integer_old)  # 1bit+7bit+24bit
        a = int(out_bias1, 2)  # 转成int型 out_bias1为二进制 ；a是十进制
        out_bias.append(a)  # 一个一个写入out_bias
        out_bias_bin.append(out_bias1)
    # print(out_bias)
    # exit()
    return out_bias,out_bias_bin


def get_add_bias(new, shape, old):  # 补0
    for kernel_num in range(shape):
        new[kernel_num] = old[kernel_num]
    return new


def get_add_SCALE(new, shape, old):  # 补0
    for kernel_num in range(shape):
        new[kernel_num] = old[kernel_num]
    return new


def get_add_NREAL(new, shape, old):  # 补0
    for kernel_num in range(shape):
        new[kernel_num] = old[kernel_num]
    return new


def get_weight(new_weight, shape, weight, inchannel):  # 八入八出操作 输入通道inchannel不固定 输出通道outchannel为8
    j = 0

    shift_num = 0
    for index in range(inchannel):
        if (inchannel == (1 << index)):  # index不停左移一位直到与inchannel相等 来判断移了几位   2的shift_num次方=inchannel
            shift_num = index
            break
    # if shape[0] == 32 and shape[1] == 64 and shape[2] == 1:
    #     # print("shape:",new_weight.shape)
    #     with open('weight_1x1_8i8o(2).txt', 'a')as f:
    #         f.write('-' * 40 + '\n')
    #         f.write(str(shape) + '\n')
    for i in range(shape[2]):  # mckk  K
        for ii in range(shape[3]):  # K
            for kernel_times in range(shape[0] >> 3):  # >>右移三位 因为输出通道outchannel默认为8 卷积核个数
                for channel_in_times in range(shape[1] >> shift_num):  # 右移shift_num 输入通道数
                    for iii in range(8):  # shape[0] >> 3 右移了3次即2^3 要补8次
                        for iiii in range(
                                inchannel):  # shape[1] >> shift_num 右移了shift_num即2^shift_num 要补inchannel次(2^shift_num =inchannel)
                            # print('++++++++++++++++++')
                            weight[j] = new_weight[kernel_times * 8 + iii][channel_in_times * inchannel + iiii][i][ii]
                            # if shape[0] == 32 and shape[1] == 64 and shape[2] == 1:
                            # with open('weight_1x1_8i8o(2).txt', 'a')as f:
                            #     f.write(str(kernel_times * 8 + iii) + ',')
                            #     f.write(str(channel_in_times * inchannel + iiii) + ',')
                            #     f.write(str(i) + ',')
                            #     f.write(str(ii) + '\n')
                            #
                            j += 1
    # exit()
    return weight


def add_weight_channel(new_weig, weig, shape):  # 补0 把weig存入new_weig；new_weig是全0，
    for kernel_num in range(shape[0]):
        for channel_in_num in range(shape[1]):
            for row in range(shape[2]):
                for col in range(shape[3]):
                    new_weig[kernel_num][channel_in_num][row][col] = weig[kernel_num][channel_in_num][row][col]
    return new_weig


def tensorr(x):
    tensor_py = torch.from_numpy(np.load(x))  # 创建tensor
    return tensor_py


def get_weight2(new_weight, shape, weight):  # 四维权重写成一维
    j = 0
    for kernel_times in range(shape[0]):
        for channel_in_times in range(shape[1]):
            for i in range(shape[2]):
                for ii in range(shape[3]):
                    # print('++++++++++++++++++')
                    weight[j] = new_weight[kernel_times][channel_in_times][i][ii]
                    j += 1
    return weight

class Gene_OnBoard_Test_Files:
    def __init__(
        self,
        quant_scale1=None,
        quant_zero_point1=None,
        quant_scale2=None,
        quant_zero_point2=None,
        quant_scale3=None,
        quant_zero_point3=None,
        first_convs=0,
        coe_name=None
    ):
        self.quant_scale1 = quant_scale1
        self.quant_zero_point1 = quant_zero_point1
        self.quant_scale2 = quant_scale2
        self.quant_zero_point2 = quant_zero_point2
        self.quant_scale3 = quant_scale3
        self.quant_zero_point3 = quant_zero_point3
        self.first_convs = first_convs
        self.coe_name = coe_name

    # def Gene_OnBoard_Test_Files(self,bias,q_weight,block=0,coee=1):
    #     coe_name = self.coe_name
    #     bias = np.array(bias.data.cpu().numpy(),
    #                     dtype=np.float64)  # 将tensor转成numpy;  bias.data.cpu()把bias.data放入cpu；a.data.cpu().numpy()把tensor转换成numpy的格式
    #     SCALE, N_REAL = gen_M_N(self.quant_scale1, self.quant_scale2, self.quant_scale3)
    #     bias = new_bias(self.quant_zero_point1, q_weight, bias)
    #     # bias = bias.astype(np.uint32)
    #     q_weight = np.array(q_weight.data.cpu().numpy(), dtype=np.int8)
    #     # print("q_weight.shape=", q_weight.shape)  # 输出每一层的权重
    #     shape = q_weight.shape  # 第一层[32,1,3,3]
    #     if (shape[1] % 8 != 0):  # 变成8的倍数 FPGA必须要8的倍数  shape[0]是输出通道数 不足补0；（kernel_num卷积核的数量即输出通道数）
    #         channel_in_num = shape[1] + 8 - shape[1] % 8
    #     else:
    #         channel_in_num = shape[1]
    #     # kernel_num = shape[0]  # shape[0]是输出通道数
    #     if (shape[0] % 8 != 0):  # 变成8的倍数 FPGA必须要8的倍数  shape[0]是输出通道数 不足补0；（kernel_num卷积核的数量即输出通道数）
    #         kernel_num = shape[0] + 8 - shape[0] % 8
    #     else:
    #         kernel_num = shape[0]
    #     new_weig = np.zeros((kernel_num, channel_in_num, shape[2], shape[3]))  # 全0  存储新权重
    #     # new_weight是补0后的四维权重
    #     new_weight = add_weight_channel(new_weig, q_weight, shape)  # 补0   因为kernel_num变了多出来的补成0，用旧权重覆盖。
    #     new_shape = new_weight.shape  # new_shape是变成8的倍数后的权重的shape
    #     daxiao = new_shape[0] * new_shape[1] * new_shape[2] * new_shape[3]  # 四个维度总共有多少点
    #     # print("有多少卷积点daxiao=", daxiao)
    #     weight = np.zeros(daxiao, dtype=np.uint8, order='C')  # 生成右daxiao个的ny数组(一维！！！)；c代表与c语言类似，行优先；F代表列优先
    #     # weight_name = "../8358_onecls_weight_spinal/all_weight_3_2.dat"  # 生成权重文件的名字
    #     global weight_name
    #     # weight_name = "../spinal_weight/onecls_all_5_52.dat"  # 生成权重文件的名字
    #     if block != 0 and coee == 1:  # 如果分块；block!=0分块 coee=1才写文件
    #         shape_block = []
    #         daxiao_new = []
    #         # 如果将weight分成4块  例如256 384 3 3 分成四个64 384 3 3  让每个分别进行kkmc生成coe
    #         for shape_num in range(block):  # 分块操作
    #             print(int(new_shape[0] / block * (
    #                     1 + shape_num)))  # 输出通道数m/block就是每块多少个 * （1+shaoe_num） 如果分成四块：第一次循环0到64 第二次64到128  第三次128到192 第四次192到256
    #             shape_block.append(int(new_shape[0] / block * (1 + shape_num)))  # 分四块是（64，128，192，256）
    #             block_shape = (shape_block[0], new_shape[1], new_shape[2], new_shape[
    #                 3])  # m c k k 如果分成四块：第一次循环是（0~64，3，3，3）第二次（64~128，3，3，3） 第三次（128~192，3，3，3） 第四次（192~256，3，3，3）
    #             daxiao_new.append(shape_block[shape_num] * new_shape[1] * new_shape[2] * new_shape[3])  # 分块的大小
    #             # print(new_weight[:daxiao_new[shape_num], :, :, :], block_shape, weight[:daxiao_new[shape_num]])
    #             if shape_num == 0:
    #                 get_weight(new_weight[:daxiao_new[shape_num], :, :, :], block_shape, weight[:daxiao_new[shape_num]],
    #                         inchannel)  # 分四块；开始0到64  shape_num=0
    #             else:
    #                 get_weight(new_weight[shape_block[shape_num - 1]:shape_block[shape_num], :, :, :], block_shape,
    #                         weight[daxiao_new[shape_num - 1]:daxiao_new[shape_num]],
    #                         inchannel)  # 分四块；64到128 shape_num=1;128到192 shape_num=2;192到256 shape_num=3
    #         # print(weight.shape)
    #         # exit()
    #         for index in range(block):  # 写coe文件 每次写一块的weight+bias+SCALE+N_REAL
    #             coe_name = coe_name + 'block' + str(index) + '.coe'
    #             out = []
    #             with open(weight_name, "a+") as fp:  # 写入权重
    #                 for r in weight[index * daxiao_new[0]:daxiao_new[0] * (index + 1)]:
    #                     out.append(r)
    #                     if len(out) == 4:  # 每次写入四个数，一个数是两位十六进制,一个十六进制的数是4bit，一行32bit
    #                         out.reverse()
    #                         fp.write('0x')
    #                         for m in out:
    #                             m = m.item()
    #                             fp.write('%02x' % m)
    #                         fp.write('\n')
    #                         out = []
    #             with open(weight_name, "a+") as fp:  # 写入bias   #bias是一维 每块有shape_block[0]个
    #                 for r in bias[
    #                         index * shape_block[0]:shape_block[0] * (index + 1)]:  # 分量块 第一次是[0,128]  第二次是[128,256]
    #                     out.append(r)
    #                     fp.write('0x')
    #                     if len(out) == 1:  # bias是一个8位十六进制的数，32bit
    #                         out.reverse()
    #                         for m in out:
    #                             fp.write('%08x' % int(m))
    #                         fp.write('\n')
    #                         out = []
    #             with open(weight_name, "a+") as fp:  # 写入SCALE
    #                 for r in SCALE[index * shape_block[0]:shape_block[0] * (index + 1)]:
    #                     out.append(r)
    #                     fp.write('0x')
    #                     if len(out) == 1:  # SCALE是一个8位十六进制的数，32bit
    #                         out.reverse()
    #                         for m in out:
    #                             m = m.item()
    #                             fp.write('%08x' % m)
    #                         fp.write('\n')
    #                         out = []
    #             with open(weight_name, "a+") as fp:  # 写入N_REAL
    #                 for r in N_REAL[index * shape_block[0]:shape_block[0] * (index + 1)]:
    #                     out.append(r)
    #                     fp.write('0x')
    #                     if len(out) == 1:  # N_REAL是一个8位十六进制的数，32bit
    #                         out.reverse()
    #                         for m in out:
    #                             m = m.item()
    #                             fp.write('%08x' % m)
    #                         fp.write('\n')
    #                         out = []
    #             coe_name = self.coe_name
    #     else:  # 如果不分块
    #         get_weight(new_weight, new_shape, weight, inchannel)  # 做8入8出
    #     if new_weight.shape[0] != shape[0]:  # bias SCALE NREAL进行补0操作
    #         new_dimen_bias = np.zeros(kernel_num, dtype=np.uint32)
    #         new_dimen_SCALE = np.zeros(kernel_num, dtype=np.uint32)
    #         new_dimen_NREAL = np.zeros(kernel_num, dtype=np.uint32)
    #         bias = get_add_bias(new_dimen_bias, shape[0], bias)  # 覆盖
    #         SCALE = get_add_SCALE(new_dimen_SCALE, shape[0], SCALE)
    #         N_REAL = get_add_NREAL(new_dimen_NREAL, shape[0], N_REAL)
    #     coe_name = self.coe_name
    #     if block == 0 and coee == 1:  # 不分块就直接写coe文件
    #         out = []
    #         with open(weight_name, "a+") as fp:  # 写入权重
    #             for r in weight:
    #                 out.append(r)
    #                 if len(out) == 4:
    #                     out.reverse()
    #                     fp.write('0x')
    #                     for m in out:
    #                         m = m.item()
    #                         fp.write('%02x' % m)
    #                     fp.write('\n')
    #                     out = []
    #         with open(weight_name, "a+") as fp:  # 写入bias
    #             for r in bias:
    #                 # for index in range(len(bias)):
    #                 out.append(r)
    #                 fp.write('0x')
    #                 if len(out) == 1:
    #                     out.reverse()
    #                     for m in out:
    #                         fp.write('%08x' % int(m))
    #                     fp.write('\n')
    #                     out = []
    #         # print(bias)
    #         with open(weight_name, "a+") as fp:  # 写入SCALE
    #             for r in SCALE:
    #                 fp.write('0x')
    #                 out.append(r)
    #                 if len(out) == 1:
    #                     out.reverse()
    #                     for m in out:
    #                         m = m.item()
    #                         fp.write('%08x' % m)
    #                     fp.write('\n')
    #                     out = []
    #         # fp.write('==========================')
    #         with open(weight_name, "a+") as fp:  # 写入N_REAL
    #             for r in N_REAL:
    #                 fp.write('0x')
    #                 out.append(r)
    #                 if len(out) == 1:
    #                     out.reverse()
    #                     for m in out:
    #                         m = m.item()
    #                         fp.write('%08x' % m)
    #                     fp.write('\n')
    #                     out = []

def convert_to_binary(number, num_bits):#这转换后是补码
    binary = bin(number & int("1" * num_bits, 2))[2:]
    return '0' * (num_bits - len(binary)) + binary
#test
    number = -1024
    num_bits = 80

    binary_representation = convert_to_binary(number, num_bits)
    print(binary_representation)

def fliplr(string):
    # string = "Hello, World!"
    reversed_string = string[::-1]
    return reversed_string
    # print(reversed_string)
    # 运行以上代码，将输出反转后的字符串："!dlroW ,olleH"。通过使用切片操作符[::-1]，可以从字符串的末尾开始，每次递减一个索引，从而实现字符串的反转。
def compbin2hex(binary):
    #二进制补码转十进制
    output=0
    if binary[0]=='1':#如果为负数
        inverted_binary = ''.join('1' if bit == '0' else '0' for bit in binary[1:])
        output=-(int(inverted_binary,2)+1)
    else:
        binary=fliplr(binary)
        for i in range(len(binary)):
            output=output+(ord(binary[i])-48)*pow(2,i)
    return output

# def Generate_Weight_Bin(Tensor,Type,Path):
#     #生成权重和图片的bin文件
#     #Tensor:输入的tensor
#     #Type：可选：image，ConvWeight，LinearWeight，QuantData
#     #path:存储路径
    
#     #image要求image是量化后的8bit数据
#     with open (Path,'w') as ff:
#     #Wq的维度：[OC,IC,K,K]
#         for OC in range(Tensor.shape[0]):#遍历全部输出通道
#             for K_Row in range(Tensor.shape[2]):#遍历行
#                 for K_Col in range(Tensor.shape[3]):#遍历列
#                     for IC in range(0,Tensor.shape[1],8):#遍历通道
#                         Hex0=Tensor[OC,IC,K_Row,K_Col].item()&0xff
#                         Hex1=Tensor[OC,IC+1,K_Row,K_Col].item()&0xff
#                         Hex2=Tensor[OC,IC+2,K_Row,K_Col].item()&0xff
#                         Hex3=Tensor[OC,IC+3,K_Row,K_Col].item()&0xff
#                         Hex4=Tensor[OC,IC+4,K_Row,K_Col].item()&0xff
#                         Hex5=Tensor[OC,IC+5,K_Row,K_Col].item()&0xff
#                         Hex6=Tensor[OC,IC+6,K_Row,K_Col].item()&0xff
#                         Hex7=Tensor[OC,IC+7,K_Row,K_Col].item()&0xff
#                         #print('%02x%02x%02x%02x%02x%02x%02x%02x'%(Hex7,Hex6,Hex5,Hex4,Hex3,Hex2,Hex1,Hex0))
#                         ff.write('%02x%02x%02x%02x%02x%02x%02x%02x'%(Hex7,Hex6,Hex5,Hex4,Hex3,Hex2,Hex1,Hex0))
#                         ff.write("\n")
#         ff.close()

def Generate_Mat(Tensor,Type,Path):
    tensors_to_mat(Tensor, r'E:\Transformer\Transformer_Arithmatic\Transformer_Main\matlab\tensors.mat')