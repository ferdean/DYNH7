function propulsion()
% Saves the parameters related to the levitation units
% ═════════════════════════════════════════════════════════════════════════
% Last updated: 15.12.2021
% ═════════════════════════════════════════════════════════════════════════

global pod;

%%%% Propulsion force fitting: 
%
% x = velocity    [m/s]
% f = force       [N]
%
% Linear model:
%
% f(x) = p0 + p1*x + p2*x^2 + p3*x^3
%
% Coefficients:

pod.propulsion.poly.p0 =      232.8;
pod.propulsion.poly.p1 = - 6.354000;
pod.propulsion.poly.p2 = - 0.604400;
pod.propulsion.poly.p3 = - 0.007235;


%pod.propulsion.br_poly.p0 =   299.8;
%pod.propulsion.br_poly.p1 =  5.634;
%pod.propulsion.br_poly.p2 = -0.1843;
pod.propulsion.br_poly.p0 =   299.8/3.2;
pod.propulsion.br_poly.p1 =  5.634/3.2;
pod.propulsion.br_poly.p2 = -0.1843/3.2;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Control model (Dates 03.02.2022)

pod.propulsion.x.p10 =   8.158;
pod.propulsion.x.p11 =   -1.202; 

% f(x,y) = p10*x + p11*x*y, voltage, speed


%      f(x,y) = p00 + p10*x + p01*y + p11*x*y + p02*y^2

pod.propulsion.current.p00 =       3.044;
pod.propulsion.current.p10 =        2.87;
pod.propulsion.current.p01 =      -2.571;
pod.propulsion.current.p11 =    -0.01369;
pod.propulsion.current.p02 =      0.3258;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Old model (previous to 15.12.2021)

x = [0.000 0.789 1.579 2.368 3.157 3.947 4.736 5.525 6.315 7.104 7.893 ... 
     9.472 11.051 12.629 14.208 15.787]; %velocity [mps]

z = [234.478 226.478 220.095 213.302 205.904 197.784 188.810 178.848 ...
     167.819 155.658 142.330 109.947 77.650 40.028 3.679 -48.136]; 
     % Propulsion Force [N]

pod.propulsion.cs = spline(x,[0 z -40]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
