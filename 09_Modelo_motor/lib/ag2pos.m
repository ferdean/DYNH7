function [u] = ag2pos(airgaps, beta, pod)
% Computes the position and attitute od the pod as a function of the airgaps 
% ═════════════════════════════════════════════════════════════════════════
% Last updated: 27.01.2022
% ═════════════════════════════════════════════════════════════════════════
% INPUT:
%   airgaps   = Vector with airgaps in [m]. The 6 first values correspond
%               to the levitation units, and the 4 last values correspond 
%               to guidance. 
%               Size 10 x 1
%   beta      = Measure acceptance tolerance [-]
%               Scalar
%   pod       = Struct containing data about
%                   *mass (Mass and inertia)
%                   *brakes (Pressures, friction coefficients and forces)
%                   *levitation (Maps of forces)
%                   *guiding (Maps of forces)
%                   *propulsion (Force as a function of velocity). 
%                   *geometry (points of application of forces wrt CG)
%                   *general (simulation parameters)
% OUTPUT:
%   u         = DOF vector, containing the estimations of the position in
%               the y and z directions [m] and the 3 rotation angles [rad]
%               Size 5 x 1
% ═════════════════════════════════════════════════════════════════════════


%%% Input check (3 inputs)
narginchk(3,3);

%%% Ensure inputs are well defined
% airgaps must be a 10 dimensional vector
if ~ismatrix(airgaps) || numel(airgaps) ~= 10
    error('Vector with airgaps is not properly defined');
end

% Filter incorrect measures
if any(isnan(airgaps))
    warning('Signal of unit number %d is incorrect. The system will ignore it, but computation will be slower.', find(isnan(airgaps)));
    airgaps(isnan(airgaps)) = 0;
end

% Beta must be scalar
if ~(isscalar(beta))
    error('beta must be an scalar')
end


%%% Auxiliar vectors initialization 
y_aux    = zeros(4,1);
z_aux    = zeros(6,1);
rotx_aux = zeros(3,1);
roty_aux = zeros(6,1);
rotz_aux = zeros(2,1);
malfunction = true;

%%% Attitude
rotx_aux(1) = asin((airgaps(1) - airgaps(4))/(2 * pod.geometry.y_LEV));
rotx_aux(2) = asin((airgaps(2) - airgaps(5))/(2 * pod.geometry.y_LEV));
rotx_aux(3) = asin((airgaps(3) - airgaps(6))/(2 * pod.geometry.y_LEV));

roty_aux(1) = asin((airgaps(5) - airgaps(4))/(    pod.geometry.z_LEV));
roty_aux(2) = asin((airgaps(6) - airgaps(4))/(2 * pod.geometry.z_LEV));
roty_aux(3) = asin((airgaps(6) - airgaps(5))/(    pod.geometry.z_LEV));
roty_aux(4) = asin((airgaps(3) - airgaps(2))/(    pod.geometry.z_LEV));
roty_aux(5) = asin((airgaps(3) - airgaps(1))/(2 * pod.geometry.z_LEV));
roty_aux(6) = asin((airgaps(2) - airgaps(1))/(    pod.geometry.z_LEV));

rotz_aux(1) = asin((airgaps(8) - airgaps(7 ))/(2 * pod.geometry.x_G));
rotz_aux(1) = asin((airgaps(9) - airgaps(10))/(2 * pod.geometry.x_G));

while any(malfunction)
    rotx = mean(rotx_aux);
    roty = mean(roty_aux);
    rotz = mean(rotz_aux);

    resx = abs(rotx_aux - rotx);
    resy = abs(roty_aux - roty);
    resz = abs(rotz_aux - rotz);

    idxx =  (resx> abs(beta*rotx));
    idxy =  (resy> abs(beta*roty));
    idxz =  (resz> abs(beta*rotz));

    malfunction = [idxx; idxy; idxz];

    rotx_aux = rotx_aux(~(idxx));
    roty_aux = roty_aux(~(idxy));
    rotz_aux = rotz_aux(~(idxz));
end

malfunction = true;

%%% Position
y_aux(1) = airgaps(7)  + pod.geometry.y_G * cos(rotz) + pod.geometry.x_G * sin(rotz);
y_aux(2) = airgaps(8)  + pod.geometry.y_G * cos(rotz) - pod.geometry.x_G * sin(rotz);
y_aux(3) = airgaps(9)  + pod.geometry.y_G * cos(rotz) - pod.geometry.x_G * sin(rotz);
y_aux(4) = airgaps(10) + pod.geometry.y_G * cos(rotz) + pod.geometry.x_G * sin(rotz);

z_aux(1) = airgaps(1)  + pod.geometry.z_LEV * cos(roty) + pod.geometry.x_LEV * sin(roty) - pod.geometry.y_LEV * sin(rotx);
z_aux(2) = airgaps(2)  + pod.geometry.z_LEV * cos(roty)                                  - pod.geometry.y_LEV * sin(rotx);
z_aux(3) = airgaps(3)  + pod.geometry.z_LEV * cos(roty) - pod.geometry.x_LEV * sin(roty) - pod.geometry.y_LEV * sin(rotx);
z_aux(4) = airgaps(4)  + pod.geometry.z_LEV * cos(roty) + pod.geometry.x_LEV * sin(roty) + pod.geometry.y_LEV * sin(rotx);
z_aux(5) = airgaps(5)  + pod.geometry.z_LEV * cos(roty)                                  + pod.geometry.y_LEV * sin(rotx);
z_aux(6) = airgaps(6)  + pod.geometry.z_LEV * cos(roty) - pod.geometry.x_LEV * sin(roty) + pod.geometry.y_LEV * sin(rotx);


while any(malfunction)
    y = mean(y_aux);
    z = mean(z_aux);

    resy = abs(y_aux - y);
    resz = abs(z_aux - z);

    idxy = (resy>beta*y);
    idxz = (resz>beta*z);

    malfunction = [idxy; idxz];

    y_aux = y_aux(~(idxy));
    z_aux = z_aux(~(idxz));
end

u = [y, z, rotx, roty, rotz]';

end