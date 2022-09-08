function wheels()
% Saves the parameters related to the pneumatic breaking system in the 
% global variable -pod-.
% ═════════════════════════════════════════════════════════════════════════
% Last updated: 15.12.2021
% ═════════════════════════════════════════════════════════════════════════

%%% Input/output check (0 inputs - 0 outputs)
narginchk(0,0);
nargoutchk(0,0);

global pod;

pod.wheels.number    = 4;       % [-]
pod.wheels.roll_coef = 0.009;   % [-]

end

