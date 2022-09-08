function mass()
% Saves the mass and inertia parameters in the global variable -pod-.
% ═════════════════════════════════════════════════════════════════════════
% Last updated: 15.12.2021
% ═════════════════════════════════════════════════════════════════════════

%%% Input/output check (0 inputs - 0 outputs)
narginchk(0,0);
nargoutchk(0,0);

global pod;

% pod.mass.mass       = 119.3713;                                  % [kg]
pod.mass.mass       = 1.193712538226299e+02;                     % [kg]

pod.mass.inertia    = [ 9.140e01,          0,  -1.797e00;
                               0,   2.779e02,          0;
                       -1.797e00,          0,   2.592e02];       % [kg·m^2]

end