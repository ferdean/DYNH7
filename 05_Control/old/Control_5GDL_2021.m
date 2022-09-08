%% Valores linealizacion
s=tf('s');
load ('COEFICIENTES_HEMS.mat'); %Terminos polinomios
load ('COEFICIENTES_EMS.mat'); %Terminos polinomios
addpath('lib')
addpath('constants')
global pod;
constants_H7()
m=pod.mass.mass;
Ixx=pod.mass.inertia(1,1);
Iyy=pod.mass.inertia(2,2);
Izz=pod.mass.inertia(3,3);
x_lev=pod.geometry.x_LEV;
z_lev=pod.geometry.z_LEV;
y_lev=pod.geometry.y_LEV;
z_g= pod.geometry.z_G;
x_g=pod.geometry.x_G;
z_0=18e-3;
z_ini=z_0+z_lev;
theta0=0;
I1_0=0;
I2_0=0;
I3_0=0;
g=9.81;
load('Resultados HEMS v2.mat');
airgap=r.air_gap/1000;
current=r.current;
current_I=r.current(1,2:32);
force=r.force;
inductance=r.inductance;
T = 0.001;
%% INCIALIZACION MODELO FERRAN

nominal_airgap      = z_0;  % [m]

% Initial conditions
initial_conds.x_0   = [0, 0, (nominal_airgap + pod.geometry.z_LEV)];
initial_conds.v_0   = [0, 0, 0];
initial_conds.ang_0 = [0, 0, 0];
initial_conds.w_0   = [0, 0, 0];

% Simulation conditions 
%dtMax = 1e-3;  % [s] 
%dtMax = T;  % [s]
%TMax  = 10;     % [s]

pod.brakes.emergency_flag    = 0;
pod.brakes.working_actuators = [1 1 1 1]; % [1 1 1 1] = all working
                                          % [0 1 1 1] = malfunction in (1)
pod.general.propulsion_on    = 0;
