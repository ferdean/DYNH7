function geometry( )
% Saves the parameters related to the geometry in the global variable pod, 
% with reference coordinate system: body-fixed centered at COG. 
% 
% [ref_1]: https://es.mathworks.com/help/aeroblks/about-aerospace-coordinate-systems.html
% [ref_2]: https://gyazo.com/87737c66f0a2dfb53713a193d4645630
%
% Subsystem indexing reference: 
% https://gyazo.com/5c20fc19aa9dc4c0097296027d0b6686
% ═════════════════════════════════════════════════════════════════════════
% Last updated: 15.12.2021
% ═════════════════════════════════════════════════════════════════════════
% NOTE: All positions in meters [m]
% ═════════════════════════════════════════════════════════════════════════

%%% Input/output check (0 inputs - 0 outputs)
narginchk(0,0);
nargoutchk(0,0);

global pod;

%%% Center of gravity 
x_COG = 0;
y_COG = 0;
z_COG = 0;

%%% Propulsion
x_LIM = 0;
y_LIM = 0;
z_LIM = 0.26192;

%%% Brakes
x_PN  = 0.61701;
y_PN  = 0.34411;
z_PN  = 0;

%%% Levitation
x_LEV = 0.51649;
y_LEV = 0.06675;
z_LEV = 0.32736;

%%% Guidance
x_G   = 0.51401;
y_G   = 0.36461;
z_G   = 0.03264;

%%% Wheels
z_CF  = 0.35818;


%%% Save parameters wrt COG

pod.geometry.x_LIM  = x_LIM - x_COG;
pod.geometry.y_LIM  = y_LIM - y_COG;
pod.geometry.z_LIM  = z_LIM - z_COG;

pod.geometry.x_PN   = x_PN - x_COG;
pod.geometry.y_PN   = y_PN - y_COG;
pod.geometry.z_PN   = z_PN - z_COG; 

pod.geometry.x_LEV  = x_LEV - x_COG;
pod.geometry.y_LEV  = y_LEV - y_COG;
pod.geometry.z_LEV  = z_LEV - z_COG; 

pod.geometry.x_G    = x_G - x_COG;
pod.geometry.y_G    = y_G - y_COG;
pod.geometry.z_G    = z_G - z_COG; 

pod.geometry.z_CF   = z_CF - z_COG; 

end

