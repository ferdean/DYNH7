function F = LIMtraction(v, pod)
% Computes the traction force (N) of the LIM as a function of 
% the absolute velocity of the prototype (m/s)
% ═════════════════════════════════════════════════════════════════════════
% Last updated: 20.12.2021
% ═════════════════════════════════════════════════════════════════════════

F = pod.propulsion.poly.p3*v^3 + ...
    pod.propulsion.poly.p2*v^2 + ...
    pod.propulsion.poly.p1*v   + ...
    pod.propulsion.poly.p0;