function F_e = BF2E(F, attitude, pod)
% Computes the total force in absoute axis
% ═════════════════════════════════════════════════════════════════════════
% Last updated: 27.12.2021
% ═════════════════════════════════════════════════════════════════════════
F     = reshape(F, [3 1]);


F_e = attitude * F + pod.mass.mass * [0 0 9.81]';