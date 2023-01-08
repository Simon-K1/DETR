#coding:utf8
import torch
import torchvision
import torch.nn as nn
from torch.autograd import Variable
import torchvision.models as models
import numpy as np
def print_model_parm_nums():
    model = models.alexnet()
    total = sum([param.nelement() for param in model.parameters()])
    print('  + Number of params: %.2fM' % (total / 1e6))