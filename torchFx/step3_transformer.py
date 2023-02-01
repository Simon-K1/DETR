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
from ..models import *

#自己构建一个Vit模型，使用量化感知训练
def vit_base_patch16_224(pretrained=False,
                         quant=False,
                         calibrate=False,
                         cfg=None,
                         **kwargs):
    model = VisionTransformer(patch_size=16,
                              embed_dim=768,
                              depth=12,
                              num_heads=12,
                              mlp_ratio=4,
                              qkv_bias=True,
                              norm_layer=partial(QIntLayerNorm, eps=1e-6),
                              quant=quant,
                              calibrate=calibrate,
                              input_quant=False,
                              cfg=cfg,
                              **kwargs)
    if pretrained:
        url = 'https://storage.googleapis.com/vit_models/augreg/' + \
            'B_16-i21k-300ep-lr_0.001-aug_medium1-wd_0.1-do_0.0-sd_0.0--imagenet2012-steps_20k-lr_0.01-res_224.npz'

        load_weights_from_npz(model, url, check_hash=True)
    return model

