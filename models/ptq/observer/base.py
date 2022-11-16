# Copyright (c) MEGVII Inc. and its affiliates. All Rights Reserved.
import torch


class BaseObserver:

    def __init__(self, module_type, bit_type, calibration_mode):
        self.module_type = module_type
        self.bit_type = bit_type
        self.calibration_mode = calibration_mode
        self.max_val = None
        self.min_val = None
        self.eps = torch.finfo(torch.float32).eps

    def reshape_tensor(self, v):
        if not isinstance(v, torch.Tensor):
            v = torch.tensor(v)
        v = v.detach()
        if self.module_type in ['conv_weight', 'linear_weight']:
            v = v.reshape(v.shape[0], -1)
        elif self.module_type == 'activation':
            if len(v.shape) == 4:
                v = v.permute(0, 2, 3, 1)#如果维度是4的话，也就是一个4维tensor，，反正就是将每个通道的数据提取出来，比如：[1,3,224,224]->[1,224,224,3]->[224^2,3]
            v = v.reshape(-1, v.shape[-1])#如果是4维矩阵，将通道放到最后一个维度，如果是三维，那么最后一个维度代表通道，也就是矩阵的列
            v = v.transpose(0, 1)#最后变成两个维度，并且将通道放在第一个维度
        else:
            raise NotImplementedError
        return v

    def update(self, v):
        # update self.max_val and self.min_val
        raise NotImplementedError

    def get_quantization_params(self, *args, **kwargs):
        raise NotImplementedError
