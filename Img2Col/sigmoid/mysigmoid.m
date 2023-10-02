function [output] = mysigmoid(x)
    output=1./(1+exp(-x));
end