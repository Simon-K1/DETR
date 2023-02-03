#构建完整的一个transformer
import torch
from torchvision.models import AlexNet
import torch.nn as nn
from torchviz import make_dot
from collections import OrderedDict
from functools import partial
from itertools import repeat
import collections.abc
import torch.optim as optim
import time

import copy
import math
import os
import numpy as np
import torchvision.datasets as datasets
import torchvision.transforms as transforms
import torch
from PIL import Image


def export_onnx(x:torch.tensor=None,model:torch.nn=None,export_path:str='exported_onnx.onnx'):
    if model is None:
        x=torch.rand(1,3,224,224)
        In_Channels=3
        Embed_Dim=384
        Picture_Size=224
        Patch_Size=16
        Num_Class=3
        Num_Heads=6
        Encoder_Layers=6
        model=Vit(In_Channels,Embed_Dim,Picture_Size,Patch_Size=Patch_Size)
    if export_path is None:
        export_path='exported_onnx.onnx'
    torch.onnx.export(model,               # model being run
                x,                         # model input 
                export_path,   # where to save the model (can be a file or file-like object)                  
                opset_version=11,           # the ONNX version to export the model to                  
                input_names = ['input'],   # the model's input names
                output_names = ['output']  # the model's output names
                )


def build_transform(input_size=224,
                    interpolation='bicubic',
                    mean=(0.485, 0.456, 0.406),
                    std=(0.229, 0.224, 0.225),
                    crop_pct=0.875):
    def _pil_interp(method):
        if method == 'bicubic':
            return Image.BICUBIC
        elif method == 'lanczos':
            return Image.LANCZOS
        elif method == 'hamming':
            return Image.HAMMING
        else:
            return Image.BILINEAR
    resize_im = input_size > 32
    t = []
    if resize_im:
        size = int(math.floor(input_size / crop_pct))
        ip = _pil_interp(interpolation)
        t.append(
            transforms.Resize(
                size,
                interpolation=ip),  # to maintain same ratio w.r.t. 224 images
        )
        t.append(transforms.CenterCrop(input_size))
    t.append(transforms.ToTensor())
    t.append(transforms.Normalize(mean, std))
    return transforms.Compose(t)


class AverageMeter(object):
    """Computes and stores the average and current value"""

    def __init__(self):
        self.reset()

    def reset(self):
        self.val = 0
        self.avg = 0
        self.sum = 0
        self.count = 0

    def update(self, val, n=1):
        self.val = val
        self.sum += val * n
        self.count += n
        self.avg = self.sum / self.count


def accuracy(output, target, topk=(1, )):
    """Computes the precision@k for the specified values of k"""
    maxk = max(topk)
    batch_size = target.size(0)

    _, pred = output.topk(maxk, 1, True, True)
    pred = pred.t()
    correct = pred.eq(target.reshape(1, -1).expand_as(pred))#target只有16个值，1维
    #correct:[5,16]
    res = []
    for k in topk:#然后遍历这五个结果
        correct_k = correct[:k].reshape(-1).float().sum(0)
        res.append(correct_k.mul_(100.0 / batch_size))
    return res
def validate(print_freq, val_loader, model, criterion, device):
    batch_time = AverageMeter()
    losses = AverageMeter()
    top1 = AverageMeter()
    top5 = AverageMeter()

    # switch to evaluate mode
    model.eval()

    val_start_time = end = time.time()
    for i, (data, target) in enumerate(val_loader):#一次验证一个batch，每个target就有batch的维度
        data = data.to(device)
        target = target.to(device)

        with torch.no_grad():
            output = model(data)
        loss = criterion(output, target)

        # measure accuracy and record loss
        prec1, prec5 = accuracy(output.data, target, topk=(1, 2))#output输出1000个值
        losses.update(loss.data.item(), data.size(0))
        top1.update(prec1.data.item(), data.size(0))
        top5.update(prec5.data.item(), data.size(0))

        # measure elapsed time
        batch_time.update(time.time() - end)
        end = time.time()

        if i % print_freq == 0:
            print('Test: [{0}/{1}]\t'
                  'Time {batch_time.val:.3f} ({batch_time.avg:.3f})\t'
                  'Loss {loss.val:.4f} ({loss.avg:.4f})\t'
                  'Prec@1 {top1.val:.3f} ({top1.avg:.3f})\t'
                  'Prec@5 {top5.val:.3f} ({top5.avg:.3f})'.format(
                      i,
                      len(val_loader),
                      batch_time=batch_time,
                      loss=losses,
                      top1=top1,#前面是验证损失，当前bacth的验证精度，后面是平均精度
                      top5=top5,
                  ))
    val_end_time = time.time()
    print(' * Prec@1 {top1.avg:.3f} Prec@5 {top5.avg:.3f} Time {time:.3f}'.
          format(top1=top1, top5=top5, time=val_end_time - val_start_time))
    return top1.avg,top5.avg
def train(epoch,train_loader, val_loader,model, criterion, device,save_path):
    # batch_time = AverageMeter()
    # losses = AverageMeter()
    # top1 = AverageMeter()
    # top5 = AverageMeter()
    
    # switch to evaluate mode

    # optimizer = getattr(torch.optim, config['optimizer'])(model.parameters(), **config['optim_hparas'])
    lr = 0.0001
    optimizer = optim.Adam(model.parameters(), lr=lr)
    val_start_time = end = time.time()
    running_loss=0
    if epoch is None:
        epoch=100
    for epoch in range(epoch):
        model.train()
        for i, (data, target) in enumerate(train_loader):#一次验证一个batch，每个target就有batch的维度
            data = data.to(device)
            target = target.to(device)

            # with torch.no_grad():
            output = model(data)
            loss = criterion(output, target)
            optimizer.zero_grad()
            loss.backward()
            optimizer.step()
            running_loss += loss.item()
            rate = (i + 1) / len(train_loader)
            a = "*" * int(rate * 50)
            b = "." * int((1 - rate) * 50)
            print("[epoch:{}]\rtrain loss: {:^3.0f}%[{}->{}]{:.4f}".format(epoch,int(rate * 100), a, b, loss), end="")


        model.eval()  # change into test model
        top1,top5=validate(1,val_loader,model,criterion,device)
        torch.save(model.state_dict(), save_path+"/FloatVit_"+str(top1)+str(top5)+".pth")