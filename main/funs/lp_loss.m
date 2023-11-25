function OutPut = lp_loss(pred, tgt, p,reduction)
    if reduction == "NONE"
        OutPut= mean(sum(abs(pred - tgt).^(p),1),"all");%.pow(p).sum(1).mean()
    else
        OutPut= mean(abs((pred - tgt)).^(p),"all");%.abs().pow(p).mean()
    end
end
