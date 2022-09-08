% ╔═══════════════════════════════════════════════════════════════════════╗
% ║───────────────╔╗─╔╗───────────╔╗──────────╔╗─╔╦═══╦╗──╔╗──────────────║
% ║───────────────║║─║║───────────║║──────────║║─║║╔═╗║╚╗╔╝║──────────────║
% ║───────────────║╚═╝╠╗─╔╦══╦══╦═╣║╔══╦══╦══╗║║─║║╚═╝╠╗║║╔╝──────────────║
% ║───────────────║╔═╗║║─║║╔╗║║═╣╔╣║║╔╗║╔╗║╔╗║║║─║║╔══╝║╚╝║───────────────║
% ║───────────────║║─║║╚═╝║╚╝║║═╣║║╚╣╚╝║╚╝║╚╝║║╚═╝║║───╚╗╔╝───────────────║
% ║───────────────╚╝─╚╩═╗╔╣╔═╩══╩╝╚═╩══╩══╣╔═╝╚═══╩╝────╚╝────────────────║
% ║───────────────────╔═╝║║║──────────────║║──────────────────────────────║
% ║───────────────────╚══╝╚╝──────────────╚╝──────────────────────────────║
% ╚═══════════════════════════════════════════════════════════════════════╝
%% Script initialization (for loop)
clear
clc
close all

cd C:\FERRAN\2_Hyperloop_2022\1_dynamics_H7\10_EquilibriumPoint

addpath lib
addpath constants

syms I_rear I_front 

assume(abs(I_rear) <= 40); 
assume(abs(I_front) <= 40);

global pod;
constants_H7()

% Additional constants
x_LEV = 0.527;        % [m]
g     = 9.81;           % [m/s^2]
AG    = 17.5;           % [mm]

numPoints = 375;

excentricity_map = linspace(0, 7.5e-2, numPoints);
I_rear_double    = zeros(1, numPoints);
I_front_double   = zeros(1, numPoints);


for idx = 1:numPoints

    %%% Definitions
    % COG excentricity
    x_exc = excentricity_map(idx);
    
    % Forces
    F_front   = HEMSlev(AG, I_front, pod);
    F_central = HEMSlev(AG, 0, pod);
    F_rear    = HEMSlev(AG, I_rear, pod);

    % Dynamic equations
    eq_forces = 2 * (F_rear + F_front + F_central) - pod.mass.mass * g;
    eq_moment = 2 * F_front * (x_LEV + x_exc) - 2 * F_rear * (x_LEV - x_exc);
    
    %%% Easy solver
    sol = solve([eq_forces, eq_moment], [I_rear, I_front], 'MaxDegree', 3);
    
    % Numerical solution
    I_rear_double(idx)  = real(double(vpa(sol.I_rear, 6)));    
    I_front_double(idx) = real(double(vpa(sol.I_front, 6))); 
end

save('I_rear.mat','I_rear_double')
save('I_front.mat','I_front_double')

%% Script initialization (1 value)
clear
clc
close all

cd C:\FERRAN\2_Hyperloop_2022\1_dynamics_H7\10_EquilibriumPoint

addpath lib
addpath constants

load variables/COEFICIENTES_HEMS.mat

syms I_rear I_front 

assume(abs(I_rear) <= 40); 
assume(abs(I_front) <= 40);

global pod;
constants_H7()

% Additional constants
x_LEV = 0.527;        % [m]
g     = 9.81;           % [m/s^2]
AG    = 17.5;           % [mm]


%%% Definitions
% COG excentricity
x_exc = 0.0128;

% Forces
% F_front   = HEMSlev(AG, I_front, pod);
% F_central = HEMSlev(AG, 0, pod);
% F_rear    = HEMSlev(AG, I_rear, pod);
F_front   = HEMSsimplificado(I_front, AG, [k1, k2, k3, p1, p2]);
F_central = HEMSsimplificado(0,       AG, [k1, k2, k3, p1, p2]);
F_rear    = HEMSsimplificado(I_rear,  AG, [k1, k2, k3, p1, p2]);

% Dynamic equations
eq_forces = 2 * (F_rear + F_front + F_central) - pod.mass.mass * g;
eq_moment = 2 * F_front * (x_LEV + x_exc) - 2 * F_rear * (x_LEV - x_exc);

%%% Easy solver
sol = solve([eq_forces, eq_moment], [I_rear, I_front], 'MaxDegree', 3);

% Numerical solution
I_rear_double  = real(double(vpa(sol.I_rear, 6)));    
I_front_double = real(double(vpa(sol.I_front, 6))); 

%% Post process (TODO)
% 
% clear I_rear I_front
% 
% 
% 
% [I_rear, I_front] = eqPoint(0);
% 
% function [I_rear, I_front] = eqPoint(x_exc)
% % Computes the intensities (A) at the equilibrium point as a funtion of the
% % excentricity of the COG (m)
% % ═════════════════════════════════════════════════════════════════════════
% % Last updated: 08.04.2022
% % ════════════════════════════════════════════════════════════════════════
% 
% I_rear = 1256.0/(((1.482e+5*x_exc + 10200.0)^2 - 1.982e+9)^(1/2) - ...
%     1.482e+5*x_exc - 10200.0)^(1/3) + (((1.482e+5*x_exc + 10200.0)^2 - ...
%     1.982e+9)^(1/2) - 1.482e+5*x_exc - 10200.0)^(1/3) - 5.455;
% 
% I_front = 1256.0/(1.482e+5*x_exc + ((1.482e+5*x_exc - 10200.0)^2 - ...
%     1.982e+9)^(1/2) - 10200.0)^(1/3) + (1.482e+5*x_exc + ((1.482e+5*x_exc - ...
%     10200.0)^2 - 1.982e+9)^(1/2) - 10200.0)^(1/3) - 5.455;
% 
% end













