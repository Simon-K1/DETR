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
from utils import load_weights_from_npz
#Trasnforemr相关组件====================================
def _ntuple(n):
    def parse(x):
        if isinstance(x, collections.abc.Iterable):
            return x
        return tuple(repeat(x, n))

    return parse
to_2tuple = _ntuple(2)

class PatchEmbed(nn.Module):#默认为vit—base
    # patch_size=16,
    # embed_dim=768,
    # depth=12,
    # num_heads=12,
    # mlp_ratio=4,

    def __init__(self,In_Channels:int=1,Out_Channels:int=768,img_size:int=224,patch_size:int=16):
        super(PatchEmbed,self).__init__()
        self.proj=nn.Conv2d(in_channels=In_Channels,out_channels=Out_Channels, kernel_size=patch_size,stride=patch_size,)
        img_size = to_2tuple(img_size)
        patch_size = to_2tuple(patch_size)
        self.img_size = img_size
        self.patch_size = patch_size
        self.grid_size = (img_size[0] // patch_size[0],
                          img_size[1] // patch_size[1])
        self.num_patches = self.grid_size[0] * self.grid_size[1]
    def forward(self,x):
        # print(x.shape)
        x = self.proj(x).flatten(2).transpose(1, 2)
        # print("Out shale:",x.shape)
        return x
def Test_PatchEmbed():
    model=PatchEmbed(In_Channels=1,Out_Channels=384)
    output=model(torch.rand(1,1,224,224))
    # print(output.shape)

class Vit_Transformer(nn.Module):
    def __init__(self,In_Channels:int=3,Out_Channels:int=768,Picture_Size:int=224,Num_Class:int=1,Num_Heads:int=8,Encoder_Layers:int=12):
        super(Vit_Transformer,self).__init__()
        self.In_Channels=In_Channels
        # self.Batch_Size=2
        self.Embed_Dim=Out_Channels
        self.Picture_Size=Picture_Size
        # self.x=torch.rand(Batch_Size,In_Channels,Picture_Size,Picture_Size)
        self.patch_embed=PatchEmbed(In_Channels=self.In_Channels,Out_Channels=self.Embed_Dim)
        # self.Embedding_Out=Embedding_Layer(x)

        self.Num_Heads=Num_Heads
        self.Encoder_layers=Encoder_Layers
        #开始构建Encoder
        #[B,H,W]
        self.cls_token = nn.Parameter(torch.zeros(1, 1, self.Embed_Dim))
        num_patches = self.patch_embed.num_patches
        self.pos_embed = nn.Parameter(
            torch.zeros(1, num_patches + 1, self.Embed_Dim))
        
        

        self.Single_Encoder = nn.TransformerEncoderLayer(d_model=self.Embed_Dim, nhead=self.Num_Heads,batch_first=True,norm_first=True)#在Vit中的norm需要位于atten和FF之前
        self.Encoders= nn.TransformerEncoder(self.Single_Encoder,num_layers=self.Encoder_layers,norm=None)#构建多个连在一起的Encoder
                                                                            #nomrm 就是在末尾加一个normlization

        self.norm=nn.LayerNorm(self.Embed_Dim,)
        
        self.Num_Class=Num_Class
        self.head=nn.Linear(self.Embed_Dim,self.Num_Class)
        self.pre_logits = nn.Identity()


        self.emb_dropout=0.1
        self.dropout = nn.Dropout(self.emb_dropout)
        # print(Class_Out.shape)
                
                                                    
    def forward(self,x):
        Embedding_Out=self.patch_embed(x)
        
        B=Embedding_Out.shape[0]
        H=Embedding_Out.shape[1]
        W=Embedding_Out.shape[2]
        Encoder_Out=self.Encoders(Embedding_Out)

        cls_tokens = self.cls_token.expand(
            B, -1, -1)  # stole cls_tokens impl from Phil Wang, thanks
        # print(Encoder_Out.shape)
        Encoder_Out = torch.cat((cls_tokens, Encoder_Out), dim=1)
        Encoder_Out = Encoder_Out + self.pos_embed

        Norm_Out=self.norm(Encoder_Out)
        Norm_Out=Norm_Out[:,0]
        Class_Out=self.head(Norm_Out)
        return Class_Out

# print(Model)


# In_Channels=3
# Out_Channels=768
# Picture_Size=224
# Num_Class=1
# Num_Heads=8
# Encoder_Layers=12

# Model=Vit_Transformer(In_Channels,Out_Channels,Picture_Size,Num_Class,Num_Heads,Encoder_Layers)
# x=torch.rand(2,In_Channels,Picture_Size,Picture_Size)
# ClassOut=Model(x)
# print(ClassOut.shape)            





import torchvision.datasets as datasets
import torchvision.transforms as transforms
import torch
from PIL import Image
import math
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



#================================================================================================
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

    return losses.avg, top1.avg, top5.avg
def train(epoch,train_loader, val_loader,model, criterion, device):
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
        validate(1,val_loader,model,criterion,device)

import argparse
parser = argparse.ArgumentParser(description='FQ-ViT')
parser.add_argument('--print-freq',
                    default=4,
                    type=int,
                    help='print frequency')
parser.add_argument('--device', default='cuda', type=str, help='device')

def export_onnx(x:torch.tensor=None,model:torch.nn=None,export_path:str='exported_onnx.onnx'):
    if model is None:
        x=torch.rand(1,3,224,224)
        In_Channels=3
        Out_Channels=384
        Picture_Size=224
        Num_Class=3
        Num_Heads=6
        Encoder_Layers=6
        model=Vit_Transformer(In_Channels,Out_Channels,Picture_Size,Num_Class,Num_Heads,Encoder_Layers)
    if export_path is None:
        export_path='exported_onnx.onnx'
    torch.onnx.export(model,               # model being run
                x,                         # model input 
                export_path,   # where to save the model (can be a file or file-like object)                  
                opset_version=11,           # the ONNX version to export the model to                  
                input_names = ['input'],   # the model's input names
                output_names = ['output']  # the model's output names
                )


if __name__== '__main__':
    print("fuck====================================\n")
    In_Channels=3
    Out_Channels=384
    Picture_Size=224
    Num_Class=3
    Num_Heads=6
    Encoder_Layers=6
    model=Vit_Transformer(In_Channels,Out_Channels,Picture_Size,Num_Class,Num_Heads,Encoder_Layers)
    # x=torch.rand(2,In_Channels,Picture_Size,Picture_Size)
    # ClassOut=model(x)
    # print(ClassOut.shape)    
    export_onnx()
    exit()
    mean = (0.5, 0.5, 0.5)
    std = (0.5, 0.5, 0.5)
    crop_pct = 0.9
    train_transform = build_transform(mean=mean, std=std, crop_pct=crop_pct)
    val_dataset = datasets.ImageFolder('E:/Transformer/DataSets/imagenet/Mini_Train/val',train_transform)
    train_dataset = datasets.ImageFolder('E:/Transformer/DataSets/imagenet/Mini_Train/train',train_transform)
    model_save_path='Saved.pth'
    val_loader = torch.utils.data.DataLoader(
        val_dataset,
        batch_size=1,#args.val_batchsize,
        shuffle=False,
        num_workers=8,#args.num_workers,
        pin_memory=True,
    )
    train_loader = torch.utils.data.DataLoader(
        train_dataset,
        batch_size=16,#args.val_batchsize,
        shuffle=True,
        num_workers=8,#args.num_workers,
        pin_memory=True,
    )
    device='cuda'
    # url = 'https://storage.googleapis.com/vit_models/augreg/' + \
    #         'B_16-i21k-300ep-lr_0.001-aug_medium1-wd_0.1-do_0.0-sd_0.0--imagenet2012-steps_20k-lr_0.01-res_224.npz'

    # load_weights_from_npz(model, url, check_hash=True)
    model.to(device)
    criterion = nn.CrossEntropyLoss().to(device)


    torch.save(model.state_dict(), model_save_path)
    
    train(100,train_loader,val_loader, model,criterion, device)


