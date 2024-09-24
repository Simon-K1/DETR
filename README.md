# 三维脉动阵列整体架构（一直在修改完善）
<!-- <center style="font-size:18px;color:#C0C0C0;text-decoration:underline">图1.整体架构</center> -->
![Alt text](<Overall_Framework.png>)
![Alt text](%E6%95%B4%E4%BD%93%E6%9E%B6%E6%9E%84.png)

<!-- <center style="font-size:18px;color:#C0C0C0;text-decoration:underline">图2.Switch模式的数据流</center> -->

![Alt text](<Dataflow of switch-mod..png>)

<!-- <center style="font-size:18px;color:#C0C0C0;text-decoration:underline">图4.卷积映射成矩阵乘法</center> -->
![Alt text](<Fig. 8. CNN mapped to matrix multiplication..png>)

<!-- <center style="font-size:18px;color:#C0C0C0;text-decoration:underline">图5.卷积循环展开（2卷积核并行）</center> -->
![Alt text](<Fig. 10. Multiple sliding windows are extended in order along the column dimension to realize parallel computation of multiple sliding Windows on the systolic array..png>)

![Alt text](<The sliding windows are eventually flattened into a submatrix of in matrix A.png>)

![Alt text](%E5%BE%AA%E7%8E%AF%E5%B1%95%E5%BC%80.png)

# 测试流程
[\[text\](<上板测试流程（仿真流程也差不多) (1).pdf>)](<上板测试流程（仿真流程也差不多) (1).pdf>)

<br>【数据排列（img2Col+GEMM）】将卷积映射成脉动阵列上的矩阵乘法，可以支持3*3~16*16，步长1~KernelSize尺度的卷积，
<br>一共有两种模式：直接模式（用于GEMM）和Switch模式（用于卷积）
<br>
<br>【DMA数据搬运】可以从DDR将数据发给加速模块，加速模块处理完的数据再提供DMA发回DDR
<br>【量化模块】对各种非线性函数进行了量化
<br>【数据输出模块】对数据进行最后的整理与输出
# 每个分支是干啥的？
master 分支包含了说明文档，就是本README文件。
<br>一共有三条开发路线，分别是：
<br>transformer 量化（Quan）
<br>transformer硬件实现（Spinal）
<br>matlab测试数据生成（Matlab）
<br>Spinal_Main部分的代码都是已经仿真和上板验证过的
***
# 算法量化部分
## <font color=Red> Quan_Main</font>
<br>稳定的量化主分支,只要改一下数据集的路径量化就能跑通量化代码
<br>给师弟和其他人的代码都走Quan_Main分支
## Quan_V6
打算自己训练一个Vit模型，然后再用FQ-VIT去量化

**目前进度：**<br>
可以自定义自己的vit模型，训练类目前只有3个类<br>
拿到自己训练的模型后可以进行量化并查看精度损失。

## Quan_V5 
用来测试Softmax
## Quan_V4 用来测试layernorm
2022年用来测试layernorm的代码
## Quan_JQ 用来在集群上测试
## 其他的Quan分支，没啥用
***



# 硬件设计部分（需要关注Spinal_Main分支）
## <font color=Red> Spinal_Main 是稳定的分支</font>
目前实现了8*8阵列的卷积+矩阵+卷积+矩阵量化<br>
Spinal_Main分支的所有内容均已上板验证过了，具体看提交记录。）
## ~~Spinal_V1~~
 写layernorm的（已经失效）
## ~~Spinal_V2~~
 写计算模块的第一个缓存模块，img2col（已经失效）
## Spinal_V3 (进行中并且及其不稳定，一堆bug)
用来写计算模块的第二个缓存模块:Weight_Cache,权重缓存(最新分支)

目前正在做三维脉动阵列的设计与实现


***
# Matlab部分
## Matlab_Main
<font size=4 color=Red>**matlab的main分支包含matlab生成仿真测试txt**</font>
<br>matlab分支中包含了完整的测试路线
主要分七步：
<br>Step1:配置好卷积核大小，图片大小，步长等必要信息，
<br>可以一键生成随机图片,随机权重
<br>Step2:根据Step1生成的.mat文件生成仿真指令和上板测试指令
<br>Step3:生成Img2Col数据排列模块的输入数据，用于与仿真数据进行逐字节对比
<br>Step4:生成卷积的标准输出数据，用于与脉动阵列的输出进行逐字节对比
<br>Step5:生成上板测试的bin文件，同时输出expected的上板计算后的数据bin文件
<br>Step6:在板子上跑完后，导出脉动阵列的输出数据可以进行逐字节对比
<br>Step7:矩阵乘法的测试
