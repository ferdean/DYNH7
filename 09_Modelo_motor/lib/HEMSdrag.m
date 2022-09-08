function F = HEMSdrag(v, pod)
% Computes the drag force (N) of one HEMS unit as a function of the 
% velocity (m/s)
% ═════════════════════════════════════════════════════════════════════════
% Last updated: 15.12.2021
% ═════════════════════════════════════════════════════════════════════════

F = pod.levitation.drag_1_unit.poly.p3*v^3 + ...
    pod.levitation.drag_1_unit.poly.p2*v^2 + ...
    pod.levitation.drag_1_unit.poly.p1*v   + ...
    pod.levitation.drag_1_unit.poly.p0;


