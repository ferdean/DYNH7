function mass()
% Saves the mass and inertia parameters in the global variable -pod-.
% ═════════════════════════════════════════════════════════════════════════
% Last updated: 05.04.2022
% ═════════════════════════════════════════════════════════════════════════

%%% Input/output check (0 inputs - 0 outputs)
narginchk(0,0);
nargoutchk(0,0);

global pod;

pod.mass.mass       = 122.61;                                    % [kg]

pod.mass.inertia    = [ 8.330e01,          0,          0;
                               0,   2.462e02,          0;
                               0,          0,   2.398e02];       % [kg·m^2]

end