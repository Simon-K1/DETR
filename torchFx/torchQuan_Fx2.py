import torch
from torch.ao.quantization import QConfigMapping#torch1.13才有
import torch.quantization.quantize_fx as quantize_fx
import copy

from Mymodels import Test_Net
model_fp = Test_Net(In_Channels=1)
input_fp32=torch.rand(1,3,224,224)
#
# post training dynamic/weight_only quantization
#

# we need to deepcopy if we still want to keep model_fp unchanged after quantization since quantization apis change the input model
model_to_quantize = copy.deepcopy(model_fp)
model_to_quantize.eval()
qconfig_mapping = QConfigMapping().set_global(torch.quantization.default_dynamic_qconfig)
# a tuple of one or more example inputs are needed to trace the model
example_inputs = (input_fp32)
# prepare
model_prepared = quantize_fx.prepare_fx(model_to_quantize, qconfig_mapping, example_inputs)
# no calibration needed when we only have dynamic/weight_only quantization
# quantize
model_quantized = quantize_fx.convert_fx(model_prepared)
print("PDQ===========================\n",model_quantized)

#
# post training static quantization
#

model_to_quantize = copy.deepcopy(model_fp)
qconfig_mapping = QConfigMapping().set_global(torch.quantization.get_default_qconfig('qnnpack'))
model_to_quantize.eval()
# prepare
model_prepared = quantize_fx.prepare_fx(model_to_quantize, qconfig_mapping, example_inputs)
# calibrate (not shown)
# quantize
model_quantized = quantize_fx.convert_fx(model_prepared)
print("PTQ==========================\n",model_quantized)
#
# quantization aware training for static quantization
#

model_to_quantize = copy.deepcopy(model_fp)
qconfig_mapping = QConfigMapping().set_global(torch.quantization.get_default_qat_qconfig('qnnpack'))
model_to_quantize.train()
# prepare
model_prepared = quantize_fx.prepare_qat_fx(model_to_quantize, qconfig_mapping, example_inputs)
# training loop (not shown)
# quantize
model_quantized = quantize_fx.convert_fx(model_prepared)

#
# fusion
#
model_to_quantize = copy.deepcopy(model_fp)
model_fused = quantize_fx.fuse_fx(model_to_quantize)