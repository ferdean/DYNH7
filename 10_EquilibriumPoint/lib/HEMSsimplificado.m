function F = HEMSsimplificado(current, airgap, constants)
% Computes the levitation force (N) of all the HEMS units as a function of 
% their air gaps (mm) and intensities (A) using a simplified model
% ═════════════════════════════════════════════════════════════════════════
% Last updated: 26.04.2022
% ══════════════════════════════════════════════════════════════════════

k1 = constants(1);
k2 = constants(2);
k3 = constants(3);
p1 = constants(4);
p2 = constants(5);

airgap = airgap * 1E-3;

FEM = (k1*current)/(airgap*k3-k2)^2; 
PM  = p1/(p2+airgap)^2;

F = FEM + PM;

end