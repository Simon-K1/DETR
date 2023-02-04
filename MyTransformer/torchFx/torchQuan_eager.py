#原来的pytorch量化
import torch
import torchvision
import torch.nn as nn
import torch.optim as optim
# import data_set

# 模型加载
pretrained=True
model_weight_path = "./weights/resnet18-f37072fd.pth"

device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
net = torchvision.models.resnet18(pretrained= pretrained)
names = [item[0] for item in net._modules.items()]
if not pretrained:#如果不使用与训练权重,那么就用自己的权重
    net.load_state_dict(torch.load(model_weight_path), strict=False)

# 指定融合层
fused_layer = [['model_fp32.conv1', 'model_fp32.bn1', 'model_fp32.relu'],
    ['model_fp32.layer1.0.conv1', 'model_fp32.layer1.0.bn1', 'model_fp32.layer1.0.relu'],
    ['model_fp32.layer1.0.conv2', 'model_fp32.layer1.0.bn2'],
    ['model_fp32.layer1.1.conv1', 'model_fp32.layer1.1.bn1', 'model_fp32.layer1.1.relu'],
    ['model_fp32.layer1.1.conv2', 'model_fp32.layer1.1.bn2'],
    ['model_fp32.layer2.0.conv1', 'model_fp32.layer2.0.bn1', 'model_fp32.layer2.0.relu'],
    ['model_fp32.layer2.0.conv2', 'model_fp32.layer2.0.bn2'],
    ['model_fp32.layer2.1.conv1', 'model_fp32.layer2.1.bn1', 'model_fp32.layer2.1.relu'],
    ['model_fp32.layer2.1.conv2', 'model_fp32.layer2.1.bn2'],
    ['model_fp32.layer3.0.conv1', 'model_fp32.layer3.0.bn1', 'model_fp32.layer3.0.relu'],
    ['model_fp32.layer3.0.conv2', 'model_fp32.layer3.0.bn2'],
    ['model_fp32.layer3.1.conv1', 'model_fp32.layer3.1.bn1', 'model_fp32.layer3.1.relu'],
    ['model_fp32.layer3.1.conv2', 'model_fp32.layer3.1.bn2'],
    ['model_fp32.layer4.0.conv1', 'model_fp32.layer4.0.bn1', 'model_fp32.layer4.0.relu'],
    ['model_fp32.layer4.0.conv2', 'model_fp32.layer4.0.bn2'],
    ['model_fp32.layer4.1.conv1', 'model_fp32.layer4.1.bn1', 'model_fp32.layer4.1.relu'],
    ['model_fp32.layer4.1.conv2', 'model_fp32.layer4.1.bn2'],
    ]

# 插入量化与反量化节点
class QuantizedResNet18(nn.Module):
    def __init__(self, model_fp32):
        super(QuantizedResNet18, self).__init__()
        # QuantStub converts tensors from floating point to quantized.
        # This will only be used for inputs.
        self.quant = torch.quantization.QuantStub()
        # DeQuantStub converts tensors from quantized to floating point.
        # This will only be used for outputs.
        self.dequant = torch.quantization.DeQuantStub()
        # FP32 model
        self.model_fp32 = model_fp32

    def forward(self, x):
        # manually specify where tensors will be converted from floating
        # point to quantized in the quantized model
        x = self.quant(x)
        x = self.model_fp32.forward(x)
        # manually specify where tensors will be converted from quantized
        # to floating point in the quantized model
        x = self.dequant(x)
        return x


quantized_model = QuantizedResNet18(net)
quantized_model.eval()

# 层融合
quantized_model = torch.ao.quantization.fuse_modules(quantized_model, fused_layer)
quantized_model.train()

# 量化配置
quantization_config = torch.quantization.QConfig(activation=torch.quantization.MinMaxObserver.with_args(dtype=torch.quint16), weight=torch.quantization.MinMaxObserver.with_args(dtype=torch.qint8, qscheme=torch.per_tensor_affine))
quantized_model.qconfig = quantization_config
quantized_model=torch.ao.quantization.prepare_qat(quantized_model, inplace=True)
quantized_model.to(device)

#超参数
batch_size = 64
lr = 0.0001
epoch = 10


trainloader,testloader,test_num = data_set.load_data(batch_size)
loss_function = nn.CrossEntropyLoss()
optimizer = optim.Adam(quantized_model.parameters(), lr=lr)


# 训练
best_acc = 0.0
save_path_fp32 = './weights/resNet18_fp32.pth'
for epoch in range(epoch):
    # training
    quantized_model.train()
    running_loss = 0.0
    for step, data in enumerate(trainloader, start=0):
        images, labels = data
        optimizer.zero_grad()
        logits = quantized_model(images.to(device))
        loss = loss_function(logits, labels.to(device))
        loss.backward()
        optimizer.step()
        running_loss += loss.item()
        rate = (step + 1) / len(trainloader)
        a = "*" * int(rate * 50)
        b = "." * int((1 - rate) * 50)
        print("\rtrain loss: {:^3.0f}%[{}->{}]{:.4f}".format(int(rate * 100), a, b, loss), end="")

    quantized_model.eval()  # change into test model
    # int_model = torch.ao.quantization.convert(quantized_model, inplace=True)
    # int_model.eval()
    # 以上代码可以将模型转换为int8模型进行测试
    acc = 0.0  # accumulate accurate number / epoch
    with torch.no_grad():
        for val_data in testloader:
            val_images, val_labels = val_data
            outputs = quantized_model(val_images.to(device))  # eval model only have last output layer
            # loss = loss_function(outputs, test_labels)
            predict_y = torch.max(outputs, dim=1)[1]
            acc += (predict_y == val_labels.to(device)).sum().item()
        val_accurate = acc / test_num
        if val_accurate > best_acc:
            best_acc = val_accurate
            torch.save(quantized_model.state_dict(), save_path_fp32)
        print('[epoch %d] train_loss: %.3f  test_accuracy: %.3f' %
            (epoch + 1, running_loss / step, val_accurate))

save_path_int8 = './weights/resNet18_INT16.pth'
quantized_model.eval()  # change into test model

# 转换为int8模型进行保存
int_model = torch.quantization.convert(quantized_model, inplace=True)
torch.save(int_model.state_dict(), save_path_int8)