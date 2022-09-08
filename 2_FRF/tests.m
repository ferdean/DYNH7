close all
clear all
clc

sample = 5 + 4 * rand(10,1);

idx = 1;

while any(idx)
    media  = mean(sample);
    res    = abs(sample - media);
    idx    =  (res>0.15*media);
    
    sample = sample(~(idx));
end
