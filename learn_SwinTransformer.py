#学习Swin-transformer，研究在Fpga上复用脉动阵列实现Swin-transformer的可能性
import torch
from models import *
# SwinBase_Module=swin_base_patch4_window7_224
# Picture_In=torch.rand(1,3,224,224)
# SwinBase_Module(Picture_In,cfg=)
a=torch.linspace(1,10,10)
b=a[3::3]#从a[3]开始，每3个取一个点
print(b)