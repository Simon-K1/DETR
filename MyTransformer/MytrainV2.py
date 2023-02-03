from Mymodels import Vit
from utils.utils import *
if __name__== '__main__':
    print("fuck====================================\n")
    In_Channels=3
    Embed_Dim=384
    Picture_Size=224
    Patch_Size=16
    Num_Class=3
    Num_Heads=6
    Encoder_Layers=6
    model=Vit(In_Channels=In_Channels,Out_Channels=Embed_Dim,Picture_Size=Picture_Size,Patch_Size=Patch_Size
    ,Num_Class=Num_Class,Num_Heads=Num_Heads,Encoder_Layers=Encoder_Layers)

    mean = (0.5, 0.5, 0.5)
    std = (0.5, 0.5, 0.5)
    crop_pct = 0.9
    train_transform = build_transform(mean=mean, std=std, crop_pct=crop_pct)
    val_dataset = datasets.ImageFolder('E:/Transformer/DataSets/imagenet/Mini_Train/val',train_transform)
    train_dataset = datasets.ImageFolder('E:/Transformer/DataSets/imagenet/Mini_Train/train',train_transform)
    model_save_path='Export/float'
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
    model.to(device)
    criterion = nn.CrossEntropyLoss().to(device)


    # torch.save(model.state_dict(), model_save_path)
    
    train(100,train_loader,val_loader, model,criterion, device,model_save_path)


