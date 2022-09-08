%% Initialize 

clc; close all; clear all;

run initializationControl.m

%% Braking parameters

clc;
% cd C:\FERRAN\2_Hyperloop_2022\1_dynamics_H7\5_Control
w = warning ('off','all');


x_0 = 1.1;                              % [m] Medida de medio carenado

pod.brakes.lim_brake  = 7.5 - x_0;
pod.brakes.v_max      = 1.5/3.6;
pod.brakes.lim_off    = 15.5 - x_0;
pod.brakes.d          = 16.5 - x_0;

pod.brakes.emergency_flag    = 1;
pod.brakes.working_actuators = [1 1 1 1]; % [1 1 1 1] = all working
                                          % [0 1 1 1] = malfunction in (1)


sim('Modelo_control_d_2GDL_2021.slx')
