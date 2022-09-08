function levitation()
% Saves the parameters related to the levitation units
% ═════════════════════════════════════════════════════════════════════════
% Last updated: 15.12.2021
% ═════════════════════════════════════════════════════════════════════════

%%% Input/output check (0 inputs - 0 outputs)
narginchk(0,0);
nargoutchk(0,0);

global pod;

pod.levitation.n = 6;         % [-]

%%% Drag force fitting (SPLINES):
v = [0.00 1.5 3 4.5 6 7.5 9];                       % [m/s]
D = [-0.009 4.600 7.607 8.514 8.522 8.071 7.653];   % [N]

%%% NOTE: Drag force computed for 1 unit at 18 mm airgap

pod.levitation.drag1.cs = spline(v,[1 D -0.05]);

%%%% Drag force fitting: 
%
% x = velocity    [m/s]
% f = force       [N]
%
% Linear model:
%
% f(x) = p0 + p1*x + p2*x^2 + p3*x^3
%
% Coefficients:

pod.levitation.drag_1_unit.poly.p0 =         0;
pod.levitation.drag_1_unit.poly.p1 =   4.05400;
pod.levitation.drag_1_unit.poly.p2 = - 0.59800;
pod.levitation.drag_1_unit.poly.p3 =   0.02696;


%%%% Levitation force fitting: 
%
% X = air_gap     [mm]
% Y = current     [A}
% f = force       [N]
%
% Linear model:
%
% f(x,y) = p00 + p10*x + p01*y + p20*x^2 + p11*x*y + p02*y^2 + p21*x^2*y +
%          p12*x*y^2 + p03*y^3
%
% Coefficients:

pod.levitation.poly_1_unit.p00 =       926.8;
pod.levitation.poly_1_unit.p10 =       -62.3;
pod.levitation.poly_1_unit.p01 =       10.82;
pod.levitation.poly_1_unit.p20 =       1.203;
pod.levitation.poly_1_unit.p11 =     -0.4806;
pod.levitation.poly_1_unit.p02 =    -0.06986;
pod.levitation.poly_1_unit.p21 =    0.007783;
pod.levitation.poly_1_unit.p12 =    0.002722;
pod.levitation.poly_1_unit.p03 =   -0.001275;

end