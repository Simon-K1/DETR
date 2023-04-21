import torch
model=torch.load("Test.pth")
print(model["patch_embed.proj.weight"])