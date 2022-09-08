function constants_H7()
% Computes the needed values for the dynamic model of the pod, divided in: 
%     *mass (Mass and inertia)
%     *brakes (Pressures, friction coefficients and forces)
%     *levitation (Maps of forces)
%     *guiding (Maps of forces)
%     *propulsion (Force as a function of velocity). 
%     *geometry (points of application of forces wrt CG)
%     *general (simulation parameters)
% ═════════════════════════════════════════════════════════════════════════
% Created by:       Javier Lujan y Jose Luis Lores (9.2021)
% Last updated by:  Ferran de Andres (12.2021)
% ═════════════════════════════════════════════════════════════════════════

%%% Input/output check (0 inputs - 0 outputs)
narginchk(0,0);
nargoutchk(0,0);

addpath('.\constants')

global pod;

mass();
pn_brakes();
levitation();
guiding();
propulsion();
geometry();
wheels();
general();

end