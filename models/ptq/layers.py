# Copyright (c) MEGVII Inc. and its affiliates. All Rights Reserved.
import torch
import torch.nn as nn
from torch.nn import functional as F

from .bit_type import BIT_TYPE_DICT
from .observer import build_observer
from .quantizer import build_quantizer
import struct

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
        weight = self.quantizer(self.weight)#先对权重量化，再反量化回浮点
        if True:#模拟硬件量化计算，重写整形前向传播公式，
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
            
            Wq=(weight*S1)/S3
            Xq=Xq-Z1
            #self.bias.data=(self.bias.data/S3+Z3)
            Cq=(F.conv2d(Xq, Wq, self.bias/S3+Z3, self.stride, self.padding,
                        self.dilation, self.groups))
            return (Cq-Z3)*S3
        
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
                x = x_q * out_scale

            else:
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
        self.bit_type = bit_type
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
        big[extra_mask] = big[extra_mask] + 1
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

    def forward(self, x, scale):
        Pow2=False
        if self.log_i_softmax and scale is not None:
            if not Pow2:
                exp_int, exp_int_sum = self.int_softmax(x, scale)
                softmax_out = torch.round(exp_int_sum / exp_int)
                rounds = self.log_round(softmax_out)
                mask = rounds >= 2**self.bit_type.bits
                qlog = torch.clamp(rounds, 0, 2**self.bit_type.bits - 1)
                deq_softmax = 2**(-qlog)
                deq_softmax[mask] = 0
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
