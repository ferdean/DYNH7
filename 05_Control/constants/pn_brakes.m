function pn_brakes()
% Saves the parameters related to the pneumatic breaking system in the 
% global variable -pod-.
% ═════════════════════════════════════════════════════════════════════════
% Last updated: 15.12.2021
% ═════════════════════════════════════════════════════════════════════════

%%% Input/output check (0 inputs - 0 outputs)
narginchk(0,0);
nargoutchk(0,0);

bar2Pa = 1e5;

global pod;

pod.brakes.pressure         = 8;      % [bar]
pod.brakes.friction_coef    = 0.37;   % [-]

pod.brakes.piston_diameter  = 40e-3;  % [m]
pod.brakes.area = ((pod.brakes.piston_diameter/2)^2) * pi; %[m^2}


pod.brakes.fpressure= pod.brakes.pressure * bar2Pa * pod.brakes.area; % [N]


pod.brakes.spring.k    = 1.366;   % [N/mm]
pod.brakes.stroke      = 35;      % [mm]
pod.brakes.prestress.d = 5;       % [mm]

%%% NOTE: prestress.d defines how much distance is the spring tractioned 
%         before the braking.


pod.brakes.normal_force = pod.brakes.fpressure - ...
    2 * (pod.brakes.stroke + pod.brakes.prestress.d) * pod.brakes.spring.k; 
    % [N]                

pod.brakes.force = pod.brakes.normal_force * pod.brakes.friction_coef; 
    % [N] 

pod.brakes.n = 4;  % [-]

end