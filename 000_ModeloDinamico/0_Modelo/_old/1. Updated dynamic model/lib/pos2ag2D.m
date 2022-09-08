function airgaps = pos2ag2D(z, theta, pod)
% Computes the airgaps (mm) as a function of the position (m) and 
% attitude (rad) of the prototype
% ═════════════════════════════════════════════════════════════════════════
% Last updated: 15.01.2022
% ═════════════════════════════════════════════════════════════════════════

airgaps = zeros(3,1);

airgaps(1) = z - pod.geometry.x_LEV * sin(theta) - pod.geometry.z_LEV * cos(theta);
airgaps(2) = z                                   - pod.geometry.z_LEV * cos(theta);
airgaps(3) = z + pod.geometry.x_LEV * sin(theta) - pod.geometry.z_LEV * cos(theta);

airgaps = airgaps * 1e3;

if any(airgaps<=11)
    airgaps = 11 * ones(3,1);
elseif any(airgaps>=23)
    airgaps = 23 * ones(3,1);
end
