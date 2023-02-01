#使用pytorch.fx可以自动插入量化节点，不用像传统eager那样手动插入量化节点
# https://blog.csdn.net/weixin_42638415/article/details/122488460

import torch.nn as nn
import torch
from Mymodels import Test_Net

Test_Module=Test_Net(2)
print(Test_Module)#打印网络只会将有效的网络层打印出来，不会打印类似展平，转置这些操作

from torch.quantization import get_default_qconfig,quantize_jit
from torch.quantization.quantize_fx import prepare_fx,convert_fx

qConfig=get_default_qconfig("fbgemm")
qConfig_Dict={"":qConfig}
model_prepared=prepare_fx(Test_Module,qConfig_Dict)#Prepare a model for post training static quantization
calibrate(prepared_model, sample_inference_data)
post_training_quantize(model_prepared,train_loader)




import torchvision.datasets as datasets
import torchvision.transforms as transforms
val_dataset = datasets.ImageFolder('E:\\Transformer\\DataSets\\imagenet\\imagenet2012mini\\val')
val_loader = torch.utils.data.DataLoader(
    val_dataset,
    batch_size=1,#args.val_batchsize,
    shuffle=False,
    num_workers=1,#args.num_workers,
    pin_memory=True,
)

for i, (data, target) in enumerate(val_loader):#一次验证一个batch，每个target就有batch的维度
        # data = data.to('cuda')
        # target = target.to('cuda')
        print(data,"---",target)

# switch to evaluate mode