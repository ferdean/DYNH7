function general()
% Saves general simulations parameters
% ═════════════════════════════════════════════════════════════════════════
% Last updated: 15.12.2021
% ═════════════════════════════════════════════════════════════════════════

%%% Input/output check (0 inputs - 0 outputs)
narginchk(0,0);
nargoutchk(0,0);

global pod;

pod.general.dt      = 0.01;    % [s]
pod.general.d_track = 20;      % [m]

% Pneumatic braking phase starting distance:
pod.brakes.d        = 14;      % [m]

% Range
pod.general.y_range = 2;       % [mm]
pod.general.z_range = 11;      % [mm]

end