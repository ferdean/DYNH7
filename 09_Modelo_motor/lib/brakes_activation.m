function [F, F_N] = brakes_activation(x, velocity, emergency, pod)
% Computes the braking force of the pneumatic actuators if and only if 
%     (1) The emergency flag has been raised
%     (2) The pod is above the acceleration phase distance
% ═════════════════════════════════════════════════════════════════════════
% Last updated: 20.12.2021
% ═════════════════════════════════════════════════════════════════════════

if (emergency == 1 && x >= pod.brakes.d && velocity >= 0)
    F       = pod.brakes.force * ones(pod.brakes.n,1);
    F_N     = pod.brakes.normal_force * ones(pod.brakes.n,1);
else
    F       = zeros(pod.brakes.n,1);
    F_N     = zeros(pod.brakes.n,1);
end


