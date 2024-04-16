function [outputArg1] = rand_range(range,size)
    assert(range(2)>=range(1),"range(2) must bigger than range(1)");
    outputArg1=range(1) + (range(2)-range(1))*rand(size);
end