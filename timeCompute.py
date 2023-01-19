{
 "cells": [
  {
   "cell_type": "code",
   "execution_count": 9,
   "metadata": {},
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "0.00019658350944519042\n"
     ]
    }
   ],
   "source": [
    "import torch\n",
    "import torch.nn as nn\n",
    "import time \n",
    "Picture_IN_Channel=3\n",
    "embed_dim=768\n",
    "patch_size=16\n",
    "device = torch.device('cuda')\n",
    "ConvLayer = nn.Conv2d(Picture_IN_Channel , embed_dim, kernel_size=patch_size, stride=patch_size)\n",
    "ConvLayer=ConvLayer.to(device)\n",
    "Input=torch.rand(1,3,224,224).to(device)\n",
    "startTime=time.time()\n",
    "for i in range(1000):\n",
    "    ConvLayer(Input)\n",
    "endTime=time.time()\n",
    "print((endTime-startTime)/1000)"
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Transformer",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3",
   "version": "3.9.13 (main, Oct 13 2022, 21:23:06) [MSC v.1916 64 bit (AMD64)]"
  },
  "orig_nbformat": 4,
  "vscode": {
   "interpreter": {
    "hash": "495274a28bdb076e4e5d468612a890f31d5e619c1dd6c8cb530d5f7b822d194c"
   }
  }
 },
 "nbformat": 4,
 "nbformat_minor": 2
}
