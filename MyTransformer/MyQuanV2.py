
#想实现QAT，但是失败了
import torch
from torch.ao.quantization import get_default_qat_qconfig_mapping,get_default_qat_qconfig,QConfigMapping
from torch.quantization.quantize_fx import prepare_qat_fx
from torch.quantization.quantize_fx import prepare_fx
import torch.optim as optim
import time
from PIL import Image
import math
import torchvision.datasets as datasets
import torchvision.transforms as transforms
from Mymodels import Vit
import torch.nn as nn
import copy
from torchsummary import summary
# from torch.ao.quantization import fuse_fx
# from torch import print_size_of_model
# (optional, but preferred) load the weights from pretrained model
# float_model.load_weights(...)

# define the training loop for quantization aware training
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
    model.to(device)
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
def train(epoch,train_loader, val_loader,model, criterion, device,save_path):
    # batch_time = AverageMeter()
    # losses = AverageMeter()
    # top1 = AverageMeter()
    # top5 = AverageMeter()
    
    # switch to evaluate mode
    model.to(device)
    # optimizer = getattr(torch.optim, config['optimizer'])(model.parameters(), **config['optim_hparas'])
    lr = 0.0001
    optimizer = optim.Adam(model.parameters(), lr=lr)
    # val_start_time = end = time.time()
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






if __name__=='__main__':
    In_Channels=3
    Embed_Dim=384
    Picture_Size=224
    Patch_Size=16
    Num_Class=3
    Num_Heads=6
    Encoder_Layers=6
    float_model=Vit(In_Channels=In_Channels,Out_Channels=Embed_Dim,Picture_Size=Picture_Size,Patch_Size=Patch_Size
    ,Num_Class=Num_Class,Num_Heads=Num_Heads,Encoder_Layers=Encoder_Layers)


    # initialize a floating point model
    # float_model = model.train()
    model_to_quantize = copy.deepcopy(float_model)
    # model_to_quantize.trian()
    # qconfig is the configuration for how we insert observers for a particular
    # operator
    # qconfig = get_default_qconfig("fbgemm")
    # Example of customizing qconfig:
    # qconfig = torch.ao.quantization.QConfig(
    #    activation=FakeQuantize.with_args(observer=MinMaxObserver.with_args(dtype=torch.qint8)),
    #    weight=FakeQuantize.with_args(observer=MinMaxObserver.with_args(dtype=torch.qint8)))
    # `activation` and `weight` are constructors of observer module

    # qconfig_mapping is a collection of quantization configurations, user can
    # set the qconfig for each operator (torch op calls, functional calls, module calls)
    # in the model through qconfig_mapping
    # the following call will get the qconfig_mapping that works best for models
    # that target "fbgemm" backend
    qconfig_mapping = get_default_qat_qconfig("fbgemm")
    qconfig_mapping = QConfigMapping().set_global(torch.quantization.get_default_qat_qconfig('qnnpack'))
    # We can customize qconfig_mapping in different ways, please take a look at
    # the doctring for :func:`~torch.ao.quantization.prepare_fx` for different ways
    # to configure this

    # example_inputs is a tuple of inputs, that is used to infer the type of the
    # outputs in the model
    # currently it's not used, but please make sure model(*example_inputs) runs
    example_inputs = (torch.randn(1, 3, 224, 224),)

    # TODO: add backend_config after we split the backend_config for fbgemm and qnnpack
    # e.g. backend_config = get_default_backend_config("fbgemm")
    # `prepare_qat_fx` inserts observers in the model based on qconfig_mapping and
    # backend_config, if the configuration for an operator in qconfig_mapping
    # is supported in the backend_config (meaning it's supported by the target
    # hardware), we'll insert fake_quantize modules according to the qconfig_mapping
    # otherwise the configuration in qconfig_mapping will be ignored
    # see :func:`~torch.ao.quantization.prepare_fx` for a detailed explanation of
    # how qconfig_mapping interacts with backend_config
    
    # Run training
    mean = (0.5, 0.5, 0.5)
    std = (0.5, 0.5, 0.5)
    crop_pct = 0.9
    train_transform = build_transform(mean=mean, std=std, crop_pct=crop_pct)
    val_dataset = datasets.ImageFolder('E:/Transformer/DataSets/imagenet/Mini_Train/val',train_transform)
    train_dataset = datasets.ImageFolder('E:/Transformer/DataSets/imagenet/Mini_Train/train',train_transform)
    model_save_path='Export/Qat'
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
    #prepare
    prepared_model = prepare_qat_fx(model_to_quantize, qconfig_mapping, example_inputs)
    print(prepared_model.state_dict)
    prepared_model.to('cuda')
    # summary(prepared_model,(3,224,224),batch_size=1)
    print(prepared_model(torch.rand(1,3,224,224).to('cuda')))


    criterion = nn.CrossEntropyLoss().to(device)
    train(1,train_loader,val_loader, prepared_model,criterion, device,model_save_path)
    print("===================train end=============")
    model_quantized =torch.quantization.quantize_fx.convert_fx(prepared_model)
    # model_fused=fuse_fx(model_quantized)
    # print_size_of_model(myModel)
    model_quantized.to('cpu')
    # randInput=torch.rand(1,3,224,224).to('cpu')
    # Output=model_quantized(randInput)
    print(model_quantized.dict)
    # summary(model_quantized,input_size=(3,224,224),batch_size=1, device='cpu')
    # print(model_quantized)
    # torch.save(model_quantized.state_dict(), save_path+str(epoch)+'.pth')
    # validate(1,val_loader,model_quantized,criterion,'cpu')