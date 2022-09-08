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
%% Script initialization
clear
clc
close all

addpath('constants/')
addpath('lib/')

global pod;
constants_H7()

%% 6 DOF simulation 

nominal_airgap      = 18e-3;  % [m]

% Initial conditions
initial_conds.x_0   = [0, 0, (nominal_airgap + pod.geometry.z_LEV)];
initial_conds.v_0   = [0, 0, 0];
initial_conds.ang_0 = [0, 0, 0];
initial_conds.w_0   = [0, 0, 0];

% Simulation conditions 
dtMax = 1e-3;  % [s] 
TMax  = 6;     % [s]

pod.brakes.emergency_flag    = 1;
pod.brakes.working_actuators = [1 1 1 1]; % [1 1 1 1] = all working
                                          % [0 1 1 1] = malfunction in (1)
pod.general.propulsion_on    = 0;

beta = 20;                                % Airgap measure acceptance tolerance [-]


% Run simulation
% results = sim("dynamic_model_H7.slx");



































