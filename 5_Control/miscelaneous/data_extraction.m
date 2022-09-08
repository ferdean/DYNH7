%% Braking parameters

clc;
cd C:\FERRAN\2_Hyperloop_2022\1_dynamics_H7\5_Control
w = warning ('off','all');

% nominal_mass = 1.293712538226299e+02;
% pod.mass.mass       = nominal_mass;
pod.brakes.lim_off  = 9;
pod.brakes.d        = 12.5;
pod.brakes.emergency_flag    = 1;
pod.brakes.working_actuators = [1 1 1 1]; % [1 1 1 1] = all working
                                          % [0 1 1 1] = malfunction in (1)


sim('Modelo_control_d_2GDL_2021.slx')

% braking.emergency_1.vel = velocity.Data;
% braking.emergency_1.pos = position.Data;
% braking.emergency_1.acc = acceleration.Data;