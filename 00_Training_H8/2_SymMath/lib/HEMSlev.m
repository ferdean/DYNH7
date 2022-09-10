function F = HEMSlev(airgap, intensity, pod)
% Computes the levitation force (N) of all the HEMS units as a function of 
% their air gaps (mm) and intensities (A)
% ═════════════════════════════════════════════════════════════════════════
% Last updated: 15.12.2021
% ════════════════════════════════════════════════════════════════════════

if ~(isscalar(airgap))
    x   = airgap(1:6);
    y   = intensity(1:6);
else
    x   = airgap;
    y   = intensity;
end


F = pod.levitation.poly_1_unit.p00 + ...
    pod.levitation.poly_1_unit.p10.*x + ...
    pod.levitation.poly_1_unit.p01.*y + ...
    pod.levitation.poly_1_unit.p20.*x.^2 + ...
    pod.levitation.poly_1_unit.p11.*x.*y + ...
    pod.levitation.poly_1_unit.p02.*y.^2 + ...
    pod.levitation.poly_1_unit.p21.*x.^2.*y + ...
    pod.levitation.poly_1_unit.p12.*x.*y.^2 + ...
    pod.levitation.poly_1_unit.p03.*y.^3;


