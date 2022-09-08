function sign = LIMdirection(v, x, pod)
% Decides if the LIM force is being applied to accelerate or to brake 
% by comparing the position of the pod with a predefined treshold
% ═════════════════════════════════════════════════════════════════════════
% Last updated: 20.12.2021
% ═════════════════════════════════════════════════════════════════════════

if x >= pod.brakes.d && v > 0    
    sign = -1;
elseif x >= pod.brakes.d && v <= 0
    sign = 0;
else
    sign = 1;
end