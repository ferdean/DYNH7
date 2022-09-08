function [F, z_CF] = rollingFriction(z, pod)
% Computes the rolling resistance force (N) of the wheels. It distinguishes
% 3 cases: 
%   (1) z = 0. Pod touching the ground
%   (2) z = z_max. Pod touching the ceiling. It is assumed no current
%   applied to the HEMS. 
%   (3) Otherwise. Pod levitating. 
% ═════════════════════════════════════════════════════════════════════════
% Last updated: 26.12.2021
% ═════════════════════════════════════════════════════════════════════════

% F_LEV worst case scenario computation
x   = 12; % [mm]
y   = 0;  % [A]

F_LEV = pod.levitation.poly_1_unit.p00 + ...
        pod.levitation.poly_1_unit.p10.*x + ...
        pod.levitation.poly_1_unit.p01.*y + ...
        pod.levitation.poly_1_unit.p20.*x.^2 + ...
        pod.levitation.poly_1_unit.p11.*x.*y + ...
        pod.levitation.poly_1_unit.p02.*y.^2 + ...
        pod.levitation.poly_1_unit.p21.*x.^2.*y + ...
        pod.levitation.poly_1_unit.p12.*x.*y.^2 + ...
        pod.levitation.poly_1_unit.p03.*y.^3;

% Main algorithm
if z == 0
    F_N   = pod.mass.mass * 9.81;
    z_CF  = - pod.geometry.z_CF;
elseif z == pod.general.z_range
    F_N   = 6 * F_LEV - pod.mass.mass * 9.81;
    z_CF  = pod.geometry.z_CF;
else
    F_N   = 0;
    z_CF  = 0;
end

F = pod.wheels.number * pod.wheels.roll_coef * F_N; 









