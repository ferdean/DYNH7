function guiding()
% Saves the parameters related to the EM guiding system in the 
% global variable -pod-.
% ═════════════════════════════════════════════════════════════════════════
% Last updated: 15.12.2021
% ═════════════════════════════════════════════════════════════════════════

%%% Input/output check (0 inputs - 0 outputs)
narginchk(0,0);
nargoutchk(0,0);

global pod;

pod.guiding.drag    = 0; % [N]


%%%% Guiding force fitting: 
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

pod.guiding.poly.p00 =       225.1;
pod.guiding.poly.p10 =      -46.06;
pod.guiding.poly.p01 =           0;
pod.guiding.poly.p20 =       2.212;
pod.guiding.poly.p11 =           0;
pod.guiding.poly.p02 =      0.4289;
pod.guiding.poly.p21 =           0;
pod.guiding.poly.p12 =    -0.02646;
pod.guiding.poly.p03 =           0;


end