#待用Fq-vit的模型，写一版自己的的训练代码，用于测试
import argparse
import math
import os
import time

import torch
import torch.nn as nn
import torchvision.datasets as datasets
import torchvision.transforms as transforms
from PIL import Image
from thop import profile#计算gops的
from config import Config
# from models import *
from models.vit_quant import My_Tiny_Vit,vit_base_patch16_224

from utils.utils import *
parser = argparse.ArgumentParser(description='FQ-ViT')

# parser.add_argument('model',
#                     choices=[
#                         'deit_tiny', 'deit_small', 'deit_base', 'vit_base',
#                         'vit_large', 'swin_tiny', 'swin_small', 'swin_base'
#                     ],
#                     help='model')

parser.add_argument('--quant', default=False, action='store_true')
parser.add_argument('--ptf', default=False, action='store_true')
parser.add_argument('--lis', default=False, action='store_true')
parser.add_argument('--quant-method',
                    default='minmax',
                    choices=['minmax', 'ema', 'omse', 'percentile'])
parser.add_argument('--calib-batchsize',
                    default=4,
                    type=int,
                    help='batchsize of calibration set')
parser.add_argument('--calib-iter', default=100, type=int)
parser.add_argument('--val-batchsize',
                    default=16,
                    type=int,
                    help='batchsize of validation set')
parser.add_argument('--num-workers',
                    default=8,
                    type=int,
                    help='number of data loading workers (default: 16)')
parser.add_argument('--device', default='cuda', type=str, help='device')
parser.add_argument('--print-freq',
                    default=4,
                    type=int,
                    help='print frequency')
parser.add_argument('--seed', default=0, type=int, help='seed')





def seed(seed=0):
    import os
    import random
    import sys

    import numpy as np
    import torch
    sys.setrecursionlimit(100000)
    os.environ['PYTHONHASHSEED'] = str(seed)
    os.environ['CUBLAS_WORKSPACE_CONFIG'] = ':4096:8'
    torch.manual_seed(seed)
    torch.cuda.manual_seed_all(seed)
    torch.backends.cudnn.benchmark = False
    torch.backends.cudnn.deterministic = True
    np.random.seed(seed)
    random.seed(seed)


def main():
    args = parser.parse_args()
    seed(args.seed)

    device = torch.device(args.device)
    cfg = Config(args.ptf, args.lis, args.quant_method)
    model = My_Tiny_Vit(pretrained=False, cfg=cfg)
    exampleInput=torch.rand(1,3,224,224)
    # print(model(exampleInput))
    model(exampleInput)

    # print(My_Tiny_Vit.input_quant)
    # exit()
    # model = vit_base_patch16_224(pretrained=True, cfg=cfg)
    

    # export_onnx(torch.rand(1,3,224,224),model,'exported_onnx.onnx')

    mean = (0.5, 0.5, 0.5)
    std = (0.5, 0.5, 0.5)
    crop_pct = 0.9
    train_transform = build_transform(mean=mean, std=std, crop_pct=crop_pct)
    val_transform = build_transform(mean=mean, std=std, crop_pct=crop_pct)

    # Data
    datapath=r'E:\Transformer\DataSets\imagenet\Mini_Train'
    traindir = os.path.join(datapath, 'train')
    calidir = os.path.join(datapath, 'cali')
    valdir = os.path.join(datapath, 'val')

    train_dataset = datasets.ImageFolder(traindir, train_transform)
    cali_dataset=datasets.ImageFolder(calidir, train_transform)
    val_dataset = datasets.ImageFolder(valdir, val_transform)
    val_loader = torch.utils.data.DataLoader(
        val_dataset,
        batch_size=args.val_batchsize,
        shuffle=False,
        num_workers=args.num_workers,
        pin_memory=True,
    )
    train_loader = torch.utils.data.DataLoader(
        train_dataset,
        batch_size=4,
        shuffle=False,
        num_workers=args.num_workers,
        pin_memory=True,
    )
    model = model.to(device)
    criterion = nn.CrossEntropyLoss().to(device)
    train(100,train_loader, val_loader,model, criterion, device,'float_pth')



    
    # switch to evaluate mode
    model.eval()

    # define loss function (criterion)
    

    if args.quant:
        cali_dataset = datasets.ImageFolder(traindir, train_transform)
        cali_loader = torch.utils.data.DataLoader(
            cali_dataset,
            batch_size=args.calib_batchsize,
            shuffle=True,
            num_workers=args.num_workers,
            pin_memory=True,
            drop_last=True,
        )
        # Get calibration set.
        image_list = []
        for i, (data, target) in enumerate(cali_loader):
            if i == args.calib_iter:
                break
            data = data.to(device)
            image_list.append(data)

        print('Calibrating...')
        model.model_open_calibrate()
        with torch.no_grad():
            for i, image in enumerate(image_list):
                print("Calibrited:",i)
                if i == len(image_list) - 1:
                    # This is used for OMSE method to
                    # calculate minimum quantization error
                    model.model_open_last_calibrate()
                output = model(image)
        model.model_close_calibrate()
        model.model_quant()

    print('Validating...')
    top1,top5=validate(1,val_loader,model,criterion,device)



if __name__ == '__main__':
    main()
