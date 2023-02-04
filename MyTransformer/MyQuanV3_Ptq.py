#使用pytorch做训练后量化
import os
import sys
import time
import numpy as np

import torch
from torch.ao.quantization import get_default_qconfig, QConfigMapping
from torch.ao.quantization.quantize_fx import prepare_fx, convert_fx, fuse_fx
import torch.nn as nn
from torch.utils.data import DataLoader

import torchvision
from torchvision import datasets
from torchvision.models.resnet import resnet18
import torchvision.transforms as transforms

# Set up warnings
import warnings
warnings.filterwarnings(
    action='ignore',
    category=DeprecationWarning,
    module=r'.*'
)
warnings.filterwarnings(
    action='default',
    module=r'torch.ao.quantization'
)

# Specify random seed for repeatable results
_ = torch.manual_seed(191009)


class AverageMeter(object):
    """Computes and stores the average and current value"""
    def __init__(self, name, fmt=':f'):
        self.name = name
        self.fmt = fmt
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

    def __str__(self):
        fmtstr = '{name} {val' + self.fmt + '} ({avg' + self.fmt + '})'
        return fmtstr.format(**self.__dict__)


def accuracy(output, target, topk=(1,)):
    """Computes the accuracy over the k top predictions for the specified values of k"""
    with torch.no_grad():
        maxk = max(topk)
        batch_size = target.size(0)

        _, pred = output.topk(maxk, 1, True, True)
        pred = pred.t()
        correct = pred.eq(target.view(1, -1).expand_as(pred))

        res = []
        for k in topk:
            correct_k = correct[:k].reshape(-1).float().sum(0, keepdim=True)
            res.append(correct_k.mul_(100.0 / batch_size))
        return res


def evaluate(model, criterion, data_loader,device):
    model.eval()
    model.to(device)
    top1 = AverageMeter('Acc@1', ':6.2f')
    top5 = AverageMeter('Acc@5', ':6.2f')
    cnt = 0
    with torch.no_grad():
        for image, target in data_loader:
            image=image.to(device)
            output = model(image)
            loss = criterion(output, target)
            cnt += 1
            acc1, acc5 = accuracy(output, target, topk=(1, 2))
            top1.update(acc1[0], image.size(0))
            top5.update(acc5[0], image.size(0))
            print('Val[',cnt,"]  [top1]:",acc1,"[top5]:",acc5)
    

    return top1, top5

def load_model(model_file):
    model = resnet18(pretrained=False)
    state_dict = torch.load(model_file)
    model.load_state_dict(state_dict)
    model.to("cpu")
    return model

def print_size_of_model(model):
    if isinstance(model, torch.jit.RecursiveScriptModule):
        torch.jit.save(model, "temp.p")
    else:
        torch.jit.save(torch.jit.script(model), "temp.p")
    print("Size (MB):", os.path.getsize("temp.p")/1e6)
    os.remove("temp.p")

def prepare_data_loaders(data_path):
    normalize = transforms.Normalize(mean=[0.485, 0.456, 0.406],
                                     std=[0.229, 0.224, 0.225])
    dataset = torchvision.datasets.ImageFolder(
        data_path+'/train',transform=transforms.Compose([
            transforms.RandomResizedCrop(224),
            transforms.RandomHorizontalFlip(),
            transforms.ToTensor(),
            normalize,
        ]))
    dataset_test = torchvision.datasets.ImageFolder(
        data_path+'/val',  transform=transforms.Compose([
            transforms.Resize(256),
            transforms.CenterCrop(224),
            transforms.ToTensor(),
            normalize,
        ]))

    train_sampler = torch.utils.data.RandomSampler(dataset)
    test_sampler = torch.utils.data.SequentialSampler(dataset_test)

    data_loader = torch.utils.data.DataLoader(
        dataset, batch_size=train_batch_size,
        sampler=train_sampler)

    data_loader_test = torch.utils.data.DataLoader(
        dataset_test, batch_size=eval_batch_size,
        sampler=test_sampler)

    return data_loader, data_loader_test

data_path = 'E:/Transformer/DataSets/imagenet/Mini_Train'
saved_model_dir = 'Export/Ptq'
float_model_file = 'pretrained_float.pth'

train_batch_size = 8
eval_batch_size = 1

data_loader, data_loader_test = prepare_data_loaders(data_path)
example_inputs = (next(iter(data_loader))[0])
criterion = nn.CrossEntropyLoss()

from Mymodels import Vit
In_Channels=3
Embed_Dim=384
Picture_Size=224
Patch_Size=16
Num_Class=3
Num_Heads=6
Encoder_Layers=6
float_model=Vit(In_Channels=In_Channels,Out_Channels=Embed_Dim,Picture_Size=Picture_Size,Patch_Size=Patch_Size
,Num_Class=Num_Class,Num_Heads=Num_Heads,Encoder_Layers=Encoder_Layers)
pretrained=True
if pretrained:
    state_dict = torch.load(r'E:\Transformer\Transformer_Main\MyTransformer\Export\float\FloatVit_93.3333333333333398.0.pth')
    float_model.load_state_dict(state_dict)


float_model.eval()
float_model.to('cuda')
# deepcopy the model since we need to keep the original model around
import copy
model_to_quantize = copy.deepcopy(float_model)
model_to_quantize.eval()
# qconfig_mapping = QConfigMapping.set_global(default_qconfig)
# qconfig_opt=None
# qconfig_mapping = (QConfigMapping()
#     .set_global(qconfig_opt)  # qconfig_opt is an optional qconfig, either a valid qconfig or None
#     .set_object_type(torch.nn.Conv2d, qconfig_opt) # can be a callable...
#     .set_object_type("torch.nn.functional.add", qconfig_opt) # ...or a string of the class name
#     .set_module_name_regex("foo.*bar.*conv[0-9]+", qconfig_opt) # matched in order, first match takes precedence
#     .set_module_name("foo.bar", qconfig_opt)
#     .set_module_name_object_type_order()
# )
#     # priority (in increasing order): global, object_type, module_name_regex, module_name
#     # qconfig == None means fusion and quantization should be skipped for anything
#     # matching the rule (unless a higher priority match is found)
qconfig = get_default_qconfig("fbgemm")
qconfig_mapping = QConfigMapping().set_global(qconfig)
# prepared_model = prepare_fx(model_to_quantize, qconfig_mapping, example_inputs)
prepared_model = prepare_fx(model_to_quantize, qconfig_mapping, example_inputs)
print(prepared_model.graph)


def calibrate(model, data_loader,device):
    model.eval()
    model.to(device)
    i=0
    with torch.no_grad():
        for image, target in data_loader:
            image=image.to(device)
            target=target.to(device)
            model(image)
            print("calibrate times",i)
            i+=1        
calibrate(prepared_model, data_loader_test,'cuda')  # run calibration on sample data
                #很奇怪，这里得用cpu校准，用gpu校准下一步就过不去了，，，，，，，，，，
print("===========calibrate end===========")
prepared_model.to('cpu')#这里得改成cpu，很奇怪
quantized_model = convert_fx(prepared_model)
print(quantized_model)

print("Size of model before quantization")
print_size_of_model(float_model)
print("Size of model after quantization")
print_size_of_model(quantized_model)
# print(quantized_model.parameters)

# test_input=torch.rand(1,3,224,224).to('cuda')
# quantized_model.to('cuda')
# out=quantized_model(test_input)

print(quantized_model.patch_embed)
top1, top2 = evaluate(quantized_model, criterion, data_loader_test,'cpu')#必须用cpu，用cuda会卡死
print("FX graph mode quantized model Evaluation accuracy on test dataset: %2.2f, %2.2f"%(top1.avg, top2.avg))


#阶段二
from torch.fx import symbolic_trace
symbolic_traced : torch.fx.GraphModule = symbolic_trace(quantized_model)
print(symbolic_traced.graph)